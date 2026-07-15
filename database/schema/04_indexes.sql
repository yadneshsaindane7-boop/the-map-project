/*
=========================================================
The Map Project
File: 04_indexes.sql
Purpose: Improve query performance
=========================================================
*/

-- Users
CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_users_role
ON users(role);

-- Incident Reports
CREATE INDEX idx_incident_reports_user
ON incident_reports(user_id);

CREATE INDEX idx_incident_reports_status
ON incident_reports(status);

CREATE INDEX idx_incident_reports_osm_way
ON incident_reports(osm_way_id);

-- Road Events
CREATE INDEX idx_road_events_status
ON road_events(status);

CREATE INDEX idx_road_events_org
ON road_events(organization_id);

CREATE INDEX idx_road_events_event_type
ON road_events(event_type_id);

-- Notifications
CREATE INDEX idx_notifications_user
ON notifications(user_id);

-- Favorites
CREATE INDEX idx_favorites_user
ON favorites(user_id);

-- Report Votes
CREATE INDEX idx_report_votes_report
ON report_votes(report_id);

-- Devices
CREATE INDEX idx_devices_user
ON user_devices(user_id);