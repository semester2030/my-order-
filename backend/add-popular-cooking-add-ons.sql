-- إضافة عمود خدمات الطبخ الشعبي (جريش، قرصان، ادامات…) — تشغيل مرة واحدة يدوياً
-- Run this once in your PostgreSQL client (pgAdmin, DBeaver, psql, etc.) — no TypeORM migration needed.

ALTER TABLE vendors
ADD COLUMN IF NOT EXISTS popular_cooking_add_ons jsonb NULL;
