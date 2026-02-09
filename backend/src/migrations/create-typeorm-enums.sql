-- Create Enum Types with TypeORM naming convention
-- TypeORM creates enum names with table prefix: {table}_{column}_enum

-- For vendors table
DO $$ BEGIN
    CREATE TYPE vendors_commercial_registration_status_enum AS ENUM('pending', 'verified', 'rejected', 'expired');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE vendors_registration_status_enum AS ENUM('pending_approval', 'under_review', 'approved', 'rejected', 'suspended');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- For vendor_certificates table
DO $$ BEGIN
    CREATE TYPE vendor_certificates_type_enum AS ENUM('health', 'municipal', 'food_safety', 'other');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE vendor_certificates_status_enum AS ENUM('pending', 'verified', 'rejected', 'expired');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- For vendor_staff table
DO $$ BEGIN
    CREATE TYPE vendor_staff_role_enum AS ENUM('owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

SELECT 'TypeORM Enums created successfully!' AS message;
