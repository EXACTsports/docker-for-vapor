FROM php:8.1-fpm-buster

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    curl \
    libonig-dev \
    libmcrypt-dev \
    libxml2 \
    libxml2-dev \
    zlib1g-dev \
    autoconf \
    openssl \
    libssl-dev \
    libpng-dev \
    libpq-dev \
    libpng-dev \
    libzip-dev \
    libxslt-dev \
    libgcrypt-dev \
    libonig-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev

RUN pecl channel-update pecl.php.net && \
    pecl install mcrypt redis-5.3.4 && \
    rm -rf /tmp/pear

RUN docker-php-ext-install \
    mysqli \
    mbstring \
    pdo \
    pdo_mysql \
    xml \
    pcntl \
    bcmath \
    pdo_pgsql \
    zip \
    intl \
    gettext \
    soap \
    sockets \
    xsl

RUN docker-php-ext-configure gd --with-freetype=/usr/lib/ --with-jpeg=/usr/lib/ && \
    docker-php-ext-install gd

RUN docker-php-ext-enable redis

RUN cp /etc/ssl/certs/ca-certificates.crt /opt/cert.pem

COPY runtime/bootstrap /opt/bootstrap
COPY runtime/bootstrap.php /opt/bootstrap.php
COPY runtime/php.ini /usr/local/etc/php/php.ini

RUN chmod 755 /opt/bootstrap
RUN chmod 755 /opt/bootstrap.php

ENTRYPOINT []

CMD /opt/bootstrap

# Install node v16
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt-get install -y \
    nodejs \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    lsb-release \
    xdg-utils \
    wget \
    libgbm-dev \
    libxshmfence-dev \

# install puppeteer using npm
RUN npm install --g --unsafe-perm puppeteer
RUN chmod -R o+rx /usr/lib/node_modules/puppeteer/.local-chromium

# install imagick
RUN apt-get update && \
    apt-get install -y imagemagick
RUN RUN pecl channel-update pecl.php.net && \
    pecl install imagick && \
    docker-php-ext-configure imagick --with-imagick=/usr/lib/ && \
    docker-php-ext-enable imagick

# install ffmpeg
RUN apt-get update && apt-get install -y ffmpeg
RUN pecl channel-update pecl.php.net && \
    pecl install xmlrpc-1.0.0RC3 && \
    rm -rf /tmp/pear
RUN docker-php-ext-configure xmlrpc-1.0.0RC3 --with-xmlrpc=/usr/lib/ && \
    docker-php-ext-install xmlrpc-1.0.0RC3

COPY . /var/task