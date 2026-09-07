-- =========================================================
-- 12. ACTIVE INCIDENTS VIEW
-- =========================================================
--
-- Returns only verified incident reports that currently
-- have an ACTIVE road event.
--
-- Completed/cancelled road events are automatically excluded.
-- Incident reports themselves are retained for history.
-- =========================================================

CREATE OR REPLACE VIEW active_incident_reports_view AS
SELECT
    ir.id,
    ir.title,
    ir.description,
    ir.status,
    ir.created_at,
    ir.reported_by,
    ir.event_type_id,
    ir.event_type,
    ir.osm_way_id,
    ir.latitude,
    ir.longitude,

    re.id AS road_event_id,
    re.status AS road_event_status,
    re.start_time AS road_event_start_time,
    re.end_time AS road_event_end_time

FROM incident_reports_map_view ir
INNER JOIN road_events re
    ON re.incident_report_id = ir.id

WHERE ir.status = 'verified'
  AND re.status = 'active';