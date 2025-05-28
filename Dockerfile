# Base image PHP 8.2 FPM
FROM php:8.2-fpm

ARG user
ARG uid

# Install required libraries for GD extension and other utilities
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libwebp-dev \
    zip \
    unzip \
    git \
    curl \
    vim \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql

# Install Node.js (version 22.x)
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set Laravel working directory
WORKDIR /var/www

COPY package.json .
# Copy project files into the container
COPY . .

# Set permissions for storage and cache folders
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Install Laravel dependencies
# RUN composer install --no-dev --optimize-autoloader

# Expose the port 9000 (or whatever PHP-FPM runs on)
EXPOSE 9000

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

# Switch to the new user
USER $user
# Install npm dependencies
# Run PHP-FPM (or your entrypoint script)
CMD ["php-fpm"]

