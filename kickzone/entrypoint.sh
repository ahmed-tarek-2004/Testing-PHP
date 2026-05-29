#!/bin/bash

# Create necessary Nginx directories for Alpine
mkdir -p /run/nginx

# Ensure correct permissions for storage and cache directories
chmod -R 775 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Run Laravel artisan commands
echo "Caching configuration and routes..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Running migrations..."
# تم إضافة || true لمنع الكونتينر من الإغلاق إذا فشل الاتصال بقاعدة البيانات
php artisan migrate --force || true

# Start PHP-FPM in the background
php-fpm -D

# Start Nginx in the foreground
nginx -g "daemon off;"
