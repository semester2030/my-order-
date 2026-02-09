-- Create Enum Types for Vendor Registration System
-- Run this file manually in psql: psql -d customer_app -f src/migrations/create-enums.sql

-- Vendor Status Enum
DO $$ BEGIN
    CREATE TYPE vendor_status_enum AS ENUM('pending_approval', 'under_review', 'approved', 'rejected', 'suspended');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Verification Status Enum
DO $$ BEGIN
    CREATE TYPE verification_status_enum AS ENUM('pending', 'verified', 'rejected', 'expired');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Certificate Type Enum
DO $$ BEGIN
    CREATE TYPE certificate_type_enum AS ENUM('health', 'municipal', 'food_safety', 'other');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Staff Role Enum
DO $$ BEGIN
    CREATE TYPE staff_role_enum AS ENUM('owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Success message
SELECT 'Enums created successfully!' AS message;
