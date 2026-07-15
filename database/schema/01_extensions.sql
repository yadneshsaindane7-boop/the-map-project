/*
=========================================================
The Map Project
File: 01_extensions.sql
Purpose: Enable required PostgreSQL extensions
=========================================================
*/

-- UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Cryptographic functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Spatial support
CREATE EXTENSION IF NOT EXISTS postgis;