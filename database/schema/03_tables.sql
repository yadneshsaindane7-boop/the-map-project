/*
=========================================================
Organization Domain
=========================================================
*/

CREATE TABLE organizations (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(200) NOT NULL,

    type VARCHAR(100),

    address TEXT,

    phone VARCHAR(20),

    email VARCHAR(255),

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Identity Domain
=========================================================
*/

CREATE TABLE users (

    id UUID PRIMARY KEY,

    full_name VARCHAR(150) NOT NULL,

    email VARCHAR(255) UNIQUE NOT NULL,

    phone VARCHAR(20),

    role user_role DEFAULT 'citizen',

    organization_id UUID REFERENCES organizations(id),

    created_at TIMESTAMPTZ DEFAULT now(),

    updated_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Incident Reports
=========================================================
*/

CREATE TABLE incident_reports (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID REFERENCES users(id),

    title VARCHAR(200) NOT NULL,

    description TEXT,

    latitude DOUBLE PRECISION NOT NULL,

    longitude DOUBLE PRECISION NOT NULL,

    osm_way_id BIGINT,

    status incident_status DEFAULT 'pending',

    created_at TIMESTAMPTZ DEFAULT now()

);
CREATE TABLE incident_images (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    incident_id UUID REFERENCES incident_reports(id) ON DELETE CASCADE,

    image_url TEXT NOT NULL,

    uploaded_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Lookup Table - Event Types
=========================================================
*/

CREATE TABLE event_types (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(100) UNIQUE NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Road Events
=========================================================
*/

CREATE TABLE road_events (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    incident_report_id UUID REFERENCES incident_reports(id),

    event_type_id UUID REFERENCES event_types(id),

    organization_id UUID REFERENCES organizations(id),

    title VARCHAR(200) NOT NULL,

    description TEXT,

    status road_event_status DEFAULT 'active',

    start_time TIMESTAMPTZ,

    end_time TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Affected Road Segments
=========================================================
*/

CREATE TABLE road_event_segments (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    road_event_id UUID REFERENCES road_events(id) ON DELETE CASCADE,

    osm_way_id BIGINT NOT NULL,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Favourite Places
=========================================================
*/

CREATE TABLE favorites (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    name VARCHAR(150),

    latitude DOUBLE PRECISION,

    longitude DOUBLE PRECISION,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
User Devices
=========================================================
*/

CREATE TABLE user_devices (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    fcm_token TEXT NOT NULL,

    device_name VARCHAR(100),

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Notifications
=========================================================
*/

CREATE TABLE notifications (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    title VARCHAR(200),

    message TEXT,

    notification_type notification_type,

    is_read BOOLEAN DEFAULT FALSE,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Report Votes
=========================================================
*/

CREATE TABLE report_votes (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    report_id UUID REFERENCES incident_reports(id) ON DELETE CASCADE,

    user_id UUID REFERENCES users(id) ON DELETE CASCADE,

    vote report_vote,

    created_at TIMESTAMPTZ DEFAULT now(),

    UNIQUE(report_id, user_id)

);
/*
=========================================================
Event History
=========================================================
*/

CREATE TABLE event_history (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    road_event_id UUID REFERENCES road_events(id) ON DELETE CASCADE,

    action VARCHAR(100),

    description TEXT,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Audit Logs
=========================================================
*/

CREATE TABLE audit_logs (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID REFERENCES users(id),

    action VARCHAR(255),

    entity VARCHAR(100),

    entity_id UUID,

    created_at TIMESTAMPTZ DEFAULT now()

);
/*
=========================================================
Notification Delivery Logs
=========================================================
*/

CREATE TABLE notification_logs (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    notification_id UUID REFERENCES notifications(id) ON DELETE CASCADE,

    delivered BOOLEAN DEFAULT FALSE,

    delivered_at TIMESTAMPTZ

);
