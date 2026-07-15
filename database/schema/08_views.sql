CREATE VIEW active_road_events AS
SELECT
    r.id,
    r.title,
    r.description,
    r.start_time,
    r.end_time,
    e.name AS event_type,
    o.name AS organization
FROM road_events r
JOIN event_types e
ON r.event_type_id = e.id
LEFT JOIN organizations o
ON r.organization_id = o.id
WHERE r.status = 'active';