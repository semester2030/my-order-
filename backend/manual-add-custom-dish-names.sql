-- إضافة عمود أطباق مخصصة (نص حر) لجدول event_requests
-- شغّل يدوياً على القاعدة المحلية و Render

ALTER TABLE event_requests
ADD COLUMN IF NOT EXISTS custom_dish_names TEXT;

COMMENT ON COLUMN event_requests.custom_dish_names IS 'للطبخ المنزلي: وصف الأطباق المطلوبة بنص حر (مثال: كبسة لحم، إدام، سلطة)';
