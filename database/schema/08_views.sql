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

CREATE OR REPLACE VIEW v_active_routing_segments AS
SELECT
    s.id AS segment_id,
    s.road_event_id,
    s.osm_way_id,
    s.is_closed,
    s.weight_modifier,
    e.name AS event_type,
    r.status
FROM road_event_segments s
JOIN road_events r ON r.id = s.road_event_id
LEFT JOIN event_types e ON e.id = r.event_type_id
WHERE r.status = 'active';