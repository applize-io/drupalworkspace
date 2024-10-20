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
    # Install PHP extensions
    install-php-extensions \
        apcu \
        gd \
        opcache \
        pdo_pgsql \
        zip; \
        curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer; \
        rm -rf /var/lib/apt/lists/*

# Set environment variables for Composer
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/opt/drupalx/vendor/bin/"

# Define environment variables
ENV COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="${PATH}:/opt/drupalx/vendor/bin/" \
    DRUPAL_TEMP="/opt/drupalx_temp" \
    DRUPAL_DIR="/opt/drupalx"

# Set the working directory
WORKDIR $DRUPAL_DIR

# Copy the Caddyfile configuration to the appropriate directory
COPY config/Caddyfile /etc/caddy/Caddyfile

# Create a temporary directory for the Drupal project and configure it
RUN mkdir -p $DRUPAL_TEMP && \
    composer create-project drupal/recommended-project $DRUPAL_TEMP; \
    rm -rf /app/public; \
    ln -sf $DRUPAL_DIR/web /app/public; \
    cp $DRUPAL_TEMP/web/example.gitignore $DRUPAL_TEMP/.gitignore; \
    cp $DRUPAL_TEMP/web/sites/default/default.settings.php $DRUPAL_TEMP/web/sites/default/settings.php; \
    composer require --working-dir=$DRUPAL_TEMP drush/drush

# Copy custom settings from the host to the container
COPY config/settings /tmp/settings

# Append the content of the settings file to settings.php
RUN cat /tmp/settings >> $DRUPAL_TEMP/web/sites/default/settings.php && \
    rm /tmp/settings
