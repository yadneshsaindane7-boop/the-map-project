/*
=========================================================
The Map Project
File: 02_enums.sql
Purpose: Common ENUM types
=========================================================
*/

CREATE TYPE user_role AS ENUM (
    'citizen',
    'authority',
    'admin'
);

CREATE TYPE incident_status AS ENUM (
    'pending',
    'verified',
    'rejected'
);

CREATE TYPE road_event_status AS ENUM (
    'active',
    'scheduled',
    'completed',
    'cancelled'
);

CREATE TYPE notification_type AS ENUM (
    'alert',
    'warning',
    'information'
);

CREATE TYPE report_vote AS ENUM (
    'confirm',
    'deny'
);