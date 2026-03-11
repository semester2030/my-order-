-- جداول المناسبات الخاصة
-- شغّل يدوياً على القاعدة المحلية و Render

-- 1. جدول عروض المناسبات (مقدم الخدمة يحدد باقاته وأسعاره)
CREATE TABLE IF NOT EXISTS event_offers (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  vendor_id uuid NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
  service_type varchar(50) NOT NULL,  -- buffet, desserts, drinks, staff
  event_type varchar(50) NOT NULL,   -- wedding, graduation, henna, engagement, other
  title varchar(255),
  description text,
  price_per_person decimal(10,2),    -- سعر للشخص (اختياري)
  price_total decimal(10,2),         -- سعر إجمالي (اختياري)
  min_guests int DEFAULT 1,
  max_guests int,
  is_active boolean DEFAULT true,
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_event_offers_vendor ON event_offers(vendor_id);
CREATE INDEX IF NOT EXISTS idx_event_offers_service_type ON event_offers(service_type);
CREATE INDEX IF NOT EXISTS idx_event_offers_event_type ON event_offers(event_type);

-- 2. جدول طلبات المناسبات (العميل يرسل طلب)
CREATE TABLE IF NOT EXISTS private_event_requests (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid NOT NULL REFERENCES users(id),
  vendor_id uuid NOT NULL REFERENCES vendors(id),
  address_id uuid REFERENCES addresses(id),
  event_type varchar(50) NOT NULL,   -- wedding, graduation, henna, engagement, other
  event_date date NOT NULL,
  event_time time NOT NULL,
  guests_count int DEFAULT 1,
  services jsonb NOT NULL,           -- [{serviceType, guestsCount, notes?}]
  notes text,
  status varchar(20) DEFAULT 'pending',  -- pending, accepted, rejected, cancelled
  created_at timestamp DEFAULT now(),
  updated_at timestamp DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_private_event_requests_vendor ON private_event_requests(vendor_id);
CREATE INDEX IF NOT EXISTS idx_private_event_requests_user ON private_event_requests(user_id);
CREATE INDEX IF NOT EXISTS idx_private_event_requests_status ON private_event_requests(status);
