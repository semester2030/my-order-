-- Migration: السماح للعمود phone بأن يكون NULL (لتسجيل العملاء بالبريد فقط)
-- شغّل هذا الملف يدوياً على قاعدة البيانات

ALTER TABLE users ALTER COLUMN phone DROP NOT NULL;
