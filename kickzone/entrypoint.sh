#!/bin/bash

# إنشاء المجلد المطلوب للـ Nginx
mkdir -p /run/nginx

# مسح الكاشات عشان لارافل تقرأ التعديلات الجديدة بشكل سليم
echo "Clearing caches..."
php artisan config:clear
php artisan route:clear
php artisan view:clear

# تشغيل قواعد البيانات
echo "Running migrations..."
php artisan migrate --force || true

# توليد ملفات توثيق Swagger أوتوماتيكياً
echo "Generating Swagger Docs..."
php artisan l5-swagger:generate || true

# إعطاء الصلاحيات (مهم جداً تكون الخطوة دي هنا في الآخر)
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# تشغيل السيرفر
php-fpm -D
nginx -g "daemon off;"
