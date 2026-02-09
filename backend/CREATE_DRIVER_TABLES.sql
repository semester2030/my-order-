-- ============================================
-- Driver Tables - Manual SQL Script
-- ============================================
-- Use this script to create Driver and JobOffer tables manually
-- Run this in your PostgreSQL database
-- ============================================

-- ============================================
-- 1. Driver Status Enum
-- ============================================
CREATE TYPE driver_status AS ENUM (
  'pending',
  'under_review',
  'documents_requested',
  'approved',
  'rejected',
  'suspended',
  'inactive'
);

-- ============================================
-- 2. License Type Enum
-- ============================================
CREATE TYPE license_type AS ENUM (
  'private',
  'public',
  'transport'
);

-- ============================================
-- 3. Vehicle Type Enum
-- ============================================
CREATE TYPE vehicle_type AS ENUM (
  'motorcycle',
  'car',
  'van',
  'truck'
);

-- ============================================
-- 4. Drivers Table
-- ============================================
CREATE TABLE IF NOT EXISTS drivers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  
  -- Personal Identity
  full_name VARCHAR(255) NOT NULL,
  national_id VARCHAR(10) UNIQUE NOT NULL,
  date_of_birth DATE NOT NULL,
  gender VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female')),
  nationality VARCHAR(100) NOT NULL,
  
  -- Driver License
  license_number VARCHAR(50) UNIQUE,
  license_type license_type,
  license_issue_date DATE,
  license_expiry_date DATE,
  license_issuing_authority VARCHAR(255),
  license_photo_front TEXT,
  license_photo_back TEXT,
  
  -- Vehicle Information
  vehicle_type vehicle_type,
  vehicle_make VARCHAR(100),
  vehicle_model VARCHAR(100),
  vehicle_year INTEGER,
  vehicle_color VARCHAR(50),
  plate_number VARCHAR(20) UNIQUE,
  plate_region VARCHAR(100),
  vehicle_registration_number VARCHAR(100),
  vehicle_registration_expiry DATE,
  vehicle_photo TEXT,
  vehicle_authorization_photo TEXT,
  
  -- Insurance
  insurance_company VARCHAR(255),
  insurance_policy_number VARCHAR(100),
  insurance_start_date DATE,
  insurance_expiry_date DATE,
  insurance_coverage_type VARCHAR(100),
  insurance_photo TEXT,
  
  -- Contact
  phone_number VARCHAR(20) NOT NULL,
  email VARCHAR(255),
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  address JSONB,
  
  -- Banking
  bank_name VARCHAR(255),
  account_number VARCHAR(100),
  account_holder_name VARCHAR(255),
  iban VARCHAR(50),
  swift_code VARCHAR(20),
  
  -- Health (Optional)
  has_medical_conditions BOOLEAN DEFAULT FALSE,
  medical_conditions TEXT[],
  blood_type VARCHAR(10),
  allergies TEXT[],
  
  -- Legal Consents
  terms_and_conditions_accepted BOOLEAN DEFAULT FALSE,
  terms_accepted_at TIMESTAMP,
  privacy_policy_accepted BOOLEAN DEFAULT FALSE,
  privacy_accepted_at TIMESTAMP,
  background_check_consent BOOLEAN DEFAULT FALSE,
  location_tracking_consent BOOLEAN DEFAULT FALSE,
  data_processing_consent BOOLEAN DEFAULT FALSE,
  
  -- Verification
  identity_verified BOOLEAN DEFAULT FALSE,
  identity_verified_at TIMESTAMP,
  identity_verified_by VARCHAR(255),
  identity_rejection_reason TEXT,
  license_verified BOOLEAN DEFAULT FALSE,
  license_verified_at TIMESTAMP,
  license_rejection_reason TEXT,
  vehicle_verified BOOLEAN DEFAULT FALSE,
  vehicle_verified_at TIMESTAMP,
  vehicle_rejection_reason TEXT,
  insurance_verified BOOLEAN DEFAULT FALSE,
  insurance_verified_at TIMESTAMP,
  insurance_rejection_reason TEXT,
  background_check_passed BOOLEAN DEFAULT FALSE,
  background_check_date TIMESTAMP,
  
  -- Status
  status driver_status DEFAULT 'pending',
  rejection_reason TEXT,
  
  -- Availability
  is_online BOOLEAN DEFAULT FALSE,
  last_online_at TIMESTAMP,
  
  -- Location (current)
  current_latitude DECIMAL(10, 8),
  current_longitude DECIMAL(11, 8),
  last_location_update TIMESTAMP,
  
  -- Profile
  profile_photo TEXT,
  languages TEXT[],
  experience_years INTEGER,
  
  -- Timestamps
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 5. Job Status Enum
-- ============================================
CREATE TYPE job_status AS ENUM (
  'pending',
  'accepted',
  'rejected',
  'expired',
  'cancelled'
);

-- ============================================
-- 6. Job Offers Table
-- ============================================
CREATE TABLE IF NOT EXISTS job_offers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID UNIQUE NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  
  status job_status DEFAULT 'pending',
  accepted_by_driver_id UUID REFERENCES drivers(id),
  
  expires_at TIMESTAMP NOT NULL,
  accepted_at TIMESTAMP,
  rejected_at TIMESTAMP,
  
  delivery_fee DECIMAL(10, 2) NOT NULL,
  driver_earnings DECIMAL(10, 2) NOT NULL,
  
  pickup_latitude DECIMAL(10, 8) NOT NULL,
  pickup_longitude DECIMAL(11, 8) NOT NULL,
  delivery_latitude DECIMAL(10, 8) NOT NULL,
  delivery_longitude DECIMAL(11, 8) NOT NULL,
  
  estimated_distance DECIMAL(10, 2) NOT NULL,
  estimated_duration INTEGER NOT NULL,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 7. Indexes for Performance
-- ============================================
CREATE INDEX IF NOT EXISTS idx_drivers_user_id ON drivers(user_id);
CREATE INDEX IF NOT EXISTS idx_drivers_national_id ON drivers(national_id);
CREATE INDEX IF NOT EXISTS idx_drivers_status ON drivers(status);
CREATE INDEX IF NOT EXISTS idx_drivers_is_online ON drivers(is_online);
CREATE INDEX IF NOT EXISTS idx_drivers_plate_number ON drivers(plate_number);

CREATE INDEX IF NOT EXISTS idx_job_offers_order_id ON job_offers(order_id);
CREATE INDEX IF NOT EXISTS idx_job_offers_status ON job_offers(status);
CREATE INDEX IF NOT EXISTS idx_job_offers_accepted_by_driver_id ON job_offers(accepted_by_driver_id);
CREATE INDEX IF NOT EXISTS idx_job_offers_expires_at ON job_offers(expires_at);

-- ============================================
-- 8. Update Order Table (if driver_id column doesn't exist)
-- ============================================
-- Note: This assumes driver_id column already exists in orders table
-- If not, uncomment the following:
-- ALTER TABLE orders ADD COLUMN IF NOT EXISTS driver_id UUID REFERENCES drivers(id);
-- ALTER TABLE orders ADD COLUMN IF NOT EXISTS driver_latitude DECIMAL(10, 8);
-- ALTER TABLE orders ADD COLUMN IF NOT EXISTS driver_longitude DECIMAL(11, 8);

-- ============================================
-- 9. Add Foreign Key Constraint for Order.driver_id
-- ============================================
-- ALTER TABLE orders 
-- ADD CONSTRAINT fk_orders_driver_id 
-- FOREIGN KEY (driver_id) REFERENCES drivers(id);

-- ============================================
-- Done!
-- ============================================
-- Tables created successfully!
-- You can now use TypeORM with synchronize: false
-- ============================================
