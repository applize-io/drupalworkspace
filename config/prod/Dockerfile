# Set a build argument for PHP version and PostgreSQL version
ARG PHP_VERSION=8.3
ARG POSTGRES_VERSION=16

# Use the official FrankenPHP image with PHP 8.3
FROM dunglas/frankenphp:1-php${PHP_VERSION}

# Install PostgreSQL client and required tools
RUN apt-get update && \
    apt-get -y install wget gnupg2 lsb-release curl ca-certificates && \
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    apt-get update && \
    apt-get -y --no-install-recommends install postgresql-client-${POSTGRES_VERSION} \
    && apt-get clean
    
# Install necessary PHP extensions and Composer in a single layer
RUN set -eux; \
    install-php-extensions \
        apcu \
        gd \
        opcache \
        pdo_pgsql \
        zip; \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
    rm -rf /var/lib/apt/lists/*

# Define environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="${PATH}:/opt/drupalx/vendor/bin/" \
    DRUPAL_DIR="/opt/drupalx"

# Set the working directory for the application
WORKDIR $DRUPAL_DIR
    
# Copy the Caddyfile configuration to the appropriate directory
COPY config/Caddyfile /etc/caddy/Caddyfile

# Copy the entire Drupal project files from the host to the container
COPY drupal/ .

# Install Composer dependencies
RUN composer update --no-dev --optimize-autoloader

# Create a symbolic link to the web directory in the public folder
RUN set -eux; \
    rm -rf /app/public; \
    ln -sf $DRUPAL_DIR/web /app/public
