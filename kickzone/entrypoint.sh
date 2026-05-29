# #!/bin/bash

# # إنشاء المجلد المطلوب للـ Nginx
# mkdir -p /run/nginx

# # مسح الكاشات عشان لارافل تقرأ التعديلات الجديدة بشكل سليم
# echo "Clearing caches..."
# php artisan config:clear
# php artisan route:clear
# php artisan view:clear

# # تشغيل قواعد البيانات
# echo "Running migrations..."
# php artisan migrate --force || true

# # توليد ملفات توثيق Swagger أوتوماتيكياً
# echo "Generating Swagger Docs..."
# php artisan l5-swagger:generate || true

# # 1️⃣ التعديل الأول: نشر ملفات الـ Assets الخاصة بواجهة Swagger
# echo "Publishing Swagger Assets..."
# php artisan l5-swagger:publish-assets --force || true

# # 2️⃣ التعديل الثاني: إعطاء الصلاحيات (تم إضافة مجلد public لضمان قراءة ملفات الـ Assets)
# echo "Setting permissions..."
# chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public
# chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public

# # تشغيل السيرفر
# php-fpm -D
# nginx -g "daemon off;"
#!/bin/bash

# مسح الكاشات
echo "Clearing caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

# تشغيل المايجريشن أوتوماتيكياً
echo "Running migrations..."
php artisan migrate --force || true

# توليد ونشر توثيق Swagger
echo "Generating Swagger Docs..."
php artisan l5-swagger:generate || true
php artisan l5-swagger:publish-assets --force || true

# إعطاء الصلاحيات النهائية عشان مفيش حاجة تضرب
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/public

# تشغيل سيرفر أباتشي
echo "Starting Apache Server..."
exec "$@"
