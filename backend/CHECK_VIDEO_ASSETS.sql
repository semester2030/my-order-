-- التحقق من وجود مقاطع الفيديو في قاعدة البيانات
-- شغّل هذا على قاعدة البيانات (محلياً أو على Render)

-- 1) عرض كل السجلات في video_assets
SELECT id, menu_item_id, cloudflare_asset_id, playback_url, status, is_primary, duration
FROM video_assets
ORDER BY created_at DESC;

-- 2) عدد الفيديوهات لكل صنف قائمة
SELECT mi.id, mi.name, COUNT(va.id) as video_count
FROM menu_items mi
LEFT JOIN video_assets va ON va.menu_item_id = mi.id
GROUP BY mi.id, mi.name;

-- إذا كانت النتائج فارغة: 
--   - تأكد أن تطبيق المورد يتصل بنفس الباك اند (Render أو localhost)
--   - إذا رفع المورد على localhost والعميل على Render = قاعدتان مختلفتان، الفيديوهات في المحلية فقط

-- لجعل فيديو أساسياً (إذا كان is_primary = false):
-- UPDATE video_assets SET is_primary = true WHERE id = 'VIDEO_ID_HERE';
-- UPDATE video_assets SET is_primary = false WHERE menu_item_id = 'MENU_ITEM_ID' AND id != 'VIDEO_ID_HERE';
