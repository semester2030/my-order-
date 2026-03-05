-- ============================================================
-- الطلب المسبق للطبخ المنزلي — تشغيل يدوي فقط
-- ============================================================
-- شغّل هذا الملف يدوياً عند الحاجة:
--   psql -d <database_name> -f src/migrations/manual-add-scheduled-order-columns.sql
-- أو من pgAdmin / أي عميل PostgreSQL
--
-- آمن للتشغيل المتكرر (ADD COLUMN IF NOT EXISTS)
-- ============================================================

ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "requested_ready_at" timestamp with time zone;
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "order_type" character varying DEFAULT 'ready_now';

ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "min_preparation_minutes" integer;
