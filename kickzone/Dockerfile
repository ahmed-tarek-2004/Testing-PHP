# FROM php:8.3-fpm-alpine

# # Install system dependencies and Nginx
# RUN apk add --no-cache \
#     nginx \
#     libpng-dev \
#     libjpeg-turbo-dev \
#     freetype-dev \
#     libzip-dev \
#     icu-dev \
#     zip \
#     unzip \
#     git \
#     curl \
#     bash

# # Configure and install PHP extensions
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd pdo_mysql bcmath zip intl opcache exif

# # Get latest Composer
# COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# # Set working directory
# WORKDIR /var/www/html

# # Copy application files
# COPY . .

# # Environment variable to allow composer to run as superuser
# ENV COMPOSER_ALLOW_SUPERUSER=1

# # Install PHP dependencies
# RUN composer install --no-dev --optimize-autoloader --no-interaction

# # Set correct permissions for Laravel directories
# RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
#     && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# COPY nginx.conf /etc/nginx/http.d/default.conf

# COPY entrypoint.sh /usr/local/bin/

# # Fix Windows line endings (CRLF to LF) - مهم جداً
# RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh

# EXPOSE 10000

# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
FROM php:8.3-apache

# تنزيل المتطلبات الأساسية ومكتبات الصور
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    freetype-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install zip pdo_mysql gd bcmath

# تفعيل Apache mod_rewrite عشان الـ Routes تشتغل
RUN a2enmod rewrite

# تغيير بورت أباتشي لـ 10000 عشان يشتغل على Back4App بدون مشاكل
RUN sed -i 's/80/10000/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# تغيير مسار السيرفر الافتراضي لملف public الخاص بـ Laravel
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# نسخ ملفات المشروع
COPY . /var/www/html

# تنزيل Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تنزيل مكتبات Laravel بدون ملفات التطوير
RUN composer install --optimize-autoloader --no-dev

# تجهيز ملف التشغيل التلقائي (Entrypoint) ومعالجة مشكلة الويندوز
COPY entrypoint.sh /usr/local/bin/
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

# إعطاء الصلاحيات المبدئية
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# تحديد مسار التشغيل الافتراضي
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["apache2-foreground"]
