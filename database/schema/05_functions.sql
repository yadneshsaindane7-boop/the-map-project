/*
=========================================================
Update updated_at automatically
=========================================================
*/

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS
$$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

/*
=========================================================
Submit Incident Report (7 parameters with osm_way_id)
=========================================================
*/

CREATE OR REPLACE FUNCTION submit_incident_report(
    p_title text,
    p_description text,
    p_event_type_id uuid,
    p_user_id uuid,
    p_latitude double precision,
    p_longitude double precision,
    p_osm_way_id bigint
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_report_id uuid;
BEGIN
    INSERT INTO incident_reports (
        user_id,
        title,
        description,
        event_type_id,
        osm_way_id,
        location,
        status
    )
    VALUES (
        p_user_id,
        p_title,
        p_description,
        p_event_type_id,
        p_osm_way_id,
        ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326),
        'pending'
    )
    RETURNING id INTO v_report_id;

    RETURN v_report_id;
END;
$$;

/*
=========================================================
Submit Incident Report (6 parameters backward compatibility)
=========================================================
*/

CREATE OR REPLACE FUNCTION submit_incident_report(
    p_title text,
    p_description text,
    p_event_type_id uuid,
    p_user_id uuid,
    p_latitude double precision,
    p_longitude double precision
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    RETURN submit_incident_report(
        p_title,
        p_description,
        p_event_type_id,
        p_user_id,
        p_latitude,
        p_longitude,
        NULL::bigint
    );
END;
$$;

/*
=========================================================
Approve Incident Report
=========================================================
*/

CREATE OR REPLACE FUNCTION approve_incident_report(
    p_report_id uuid,
    p_authority_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_role user_role;
    v_user_org_id uuid;
    v_report RECORD;
    v_event_type_name text;
    v_road_event_id uuid;
    v_is_closed boolean;
    v_weight_modifier integer;
BEGIN
    -- 1. Validate authority user
    SELECT role, organization_id INTO v_user_role, v_user_org_id
    FROM users
    WHERE id = p_authority_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Authority user not found'
        );
    END IF;

    IF v_user_role NOT IN ('authority', 'admin') THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Unauthorized: User is not an authority or admin'
        );
    END IF;

    -- 2. Validate incident report
    SELECT id, user_id, title, description, event_type_id, status, osm_way_id, location
    INTO v_report
    FROM incident_reports
    WHERE id = p_report_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident report not found'
        );
    END IF;

    IF v_report.status <> 'pending' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident report is not pending'
        );
    END IF;

    -- 3. Critical Validation: verify report is associated with an OSM road
    IF v_report.osm_way_id IS NULL THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident cannot be approved because it is not associated with a road.'
        );
    END IF;

    -- Look up event type name for penalty and closure mapping
    SELECT name INTO v_event_type_name
    FROM event_types
    WHERE id = v_report.event_type_id;

    -- Centralized Event-Type Routing Mapping:
    -- weight_modifier represents additive travel-time delay (seconds).
    CASE LOWER(COALESCE(v_event_type_name, ''))
        WHEN 'road closure' THEN
            v_is_closed := TRUE;
            v_weight_modifier := 0;
        WHEN 'flood' THEN
            v_is_closed := TRUE;
            v_weight_modifier := 0;
        WHEN 'accident' THEN
            v_is_closed := FALSE;
            v_weight_modifier := 900;
        WHEN 'construction' THEN
            v_is_closed := FALSE;
            v_weight_modifier := 300;
        WHEN 'diversion' THEN
            v_is_closed := FALSE;
            v_weight_modifier := 180;
        WHEN 'pothole' THEN
            v_is_closed := FALSE;
            v_weight_modifier := 60;
        ELSE
            v_is_closed := FALSE;
            v_weight_modifier := 60;
    END CASE;

    -- 4. Create road_events record
    INSERT INTO road_events (
        incident_report_id,
        event_type_id,
        organization_id,
        title,
        description,
        status,
        start_time,
        latitude,
        longitude,
        reported_by
    )
    VALUES (
        v_report.id,
        v_report.event_type_id,
        v_user_org_id,
        v_report.title,
        v_report.description,
        'active',
        NOW(),
        ST_Y(v_report.location),
        ST_X(v_report.location),
        v_report.user_id
    )
    RETURNING id INTO v_road_event_id;

    -- 5. Create exactly one road_event_segments record
    INSERT INTO road_event_segments (
        road_event_id,
        osm_way_id,
        is_closed,
        weight_modifier,
        speed_limit
    )
    VALUES (
        v_road_event_id,
        v_report.osm_way_id,
        v_is_closed,
        v_weight_modifier,
        NULL
    );

    -- 6. Update incident report status to verified
    UPDATE incident_reports
    SET status = 'verified'
    WHERE id = p_report_id;

    -- 7. Add event history
    INSERT INTO event_history (
        road_event_id,
        action,
        description
    )
    VALUES (
        v_road_event_id,
        'approved',
        'Incident report approved and active road event created by authority'
    );

    -- 8. Add audit log
    INSERT INTO audit_logs (
        user_id,
        action,
        entity,
        entity_id
    )
    VALUES (
        p_authority_id,
        'APPROVE_INCIDENT_REPORT',
        'incident_reports',
        p_report_id
    );

    RETURN jsonb_build_object(
        'success', true,
        'road_event_id', v_road_event_id,
        'message', 'Incident report approved successfully'
    );
END;
$$;

/*
=========================================================
Reject Incident Report
=========================================================
*/

CREATE OR REPLACE FUNCTION reject_incident_report(
    p_report_id uuid,
    p_authority_id uuid
)
RETURNS jsonb
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_role user_role;
    v_report_status incident_status;
BEGIN
    -- 1. Validate authority
    SELECT role INTO v_user_role
    FROM users
    WHERE id = p_authority_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Authority user not found'
        );
    END IF;

    IF v_user_role NOT IN ('authority', 'admin') THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Unauthorized: User is not an authority or admin'
        );
    END IF;

    -- 2. Validate report
    SELECT status INTO v_report_status
    FROM incident_reports
    WHERE id = p_report_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident report not found'
        );
    END IF;

    IF v_report_status <> 'pending' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident report is not pending'
        );
    END IF;

    -- 3. Update status to rejected
    UPDATE incident_reports
    SET status = 'rejected'
    WHERE id = p_report_id;

    -- 4. Add audit log
    INSERT INTO audit_logs (
        user_id,
        action,
        entity,
        entity_id
    )
    VALUES (
        p_authority_id,
        'REJECT_INCIDENT_REPORT',
        'incident_reports',
        p_report_id
    );

    RETURN jsonb_build_object(
        'success', true,
        'message', 'Incident report rejected'
    );
END;
$$;