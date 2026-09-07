-- =========================================================
-- 11. COMPLETE INCIDENT ROAD EVENT
-- =========================================================
--
-- Completes the road event associated with a verified
-- incident report.
--
-- The incident report itself remains "verified" for
-- historical purposes.
--
-- The associated road event becomes "completed", which
-- removes its road restriction from active routing.
-- =========================================================

CREATE OR REPLACE FUNCTION resolve_incident_report(
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
    v_road_event_id uuid;
    v_road_event_status road_event_status;
BEGIN

    -- =====================================================
    -- 1. Validate authority
    -- =====================================================

    SELECT role
    INTO v_user_role
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
            'message',
            'Unauthorized: User is not an authority or admin'
        );
    END IF;


    -- =====================================================
    -- 2. Find and validate incident report
    -- =====================================================

    SELECT status
    INTO v_report_status
    FROM incident_reports
    WHERE id = p_report_id;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message', 'Incident report not found'
        );
    END IF;

    IF v_report_status <> 'verified' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message',
            'Only verified incident reports can be completed'
        );
    END IF;


    -- =====================================================
    -- 3. Find associated active road event
    -- =====================================================

    SELECT id, status
    INTO v_road_event_id, v_road_event_status
    FROM road_events
    WHERE incident_report_id = p_report_id
    ORDER BY start_time DESC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN jsonb_build_object(
            'success', false,
            'message',
            'No road event is associated with this incident'
        );
    END IF;

    IF v_road_event_status <> 'active' THEN
        RETURN jsonb_build_object(
            'success', false,
            'message',
            'The road event is already inactive'
        );
    END IF;


    -- =====================================================
    -- 4. Complete the road event
    -- =====================================================

    UPDATE road_events
    SET
        status = 'completed',
        end_time = NOW()
    WHERE id = v_road_event_id;


    -- =====================================================
    -- 5. Record event history
    -- =====================================================

    INSERT INTO event_history (
        road_event_id,
        action,
        description
    )
    VALUES (
        v_road_event_id,
        'completed',
        'Incident completed by authority and road restriction removed from active routing'
    );


    -- =====================================================
    -- 6. Add audit log
    -- =====================================================

    INSERT INTO audit_logs (
        user_id,
        action,
        entity,
        entity_id
    )
    VALUES (
        p_authority_id,
        'COMPLETE_INCIDENT_ROAD_EVENT',
        'incident_reports',
        p_report_id
    );


    -- =====================================================
    -- 7. Return success
    -- =====================================================

    RETURN jsonb_build_object(
        'success', true,
        'road_event_id', v_road_event_id,
        'message',
        'Incident completed successfully and road restriction removed'
    );

END;
$$;