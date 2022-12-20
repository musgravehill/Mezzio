FROM php:8.1.0-fpm

# Arguments will be defined in docker-compose.yml  Set default values. Args available only in "build"-time 
ARG arg_user=bob
ARG arg_uid=1000
ARG arg_gid=1000

# ENV always available
ENV env_app_workdir = /var/www

RUN useradd -G www-data,root -u $arg_uid -d /home/$arg_user $arg_user
RUN mkdir -p /home/$arg_user/ && \
    chown -R $arg_user:$arg_user /home/$arg_user 

# Install system dependencies   -y=autoYES
RUN apt-get update && apt-get install -y \
        curl \
        wget \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
	libpng-dev \
	libonig-dev \
	libzip-dev \
	libmcrypt-dev          
RUN docker-php-ext-install -j$(nproc) iconv mbstring mysqli pdo_mysql zip bcmath 
#RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
#       && docker-php-ext-install -j$(nproc) gd exif 

# Get latest Composer   src="--from=composer:latest /usr/bin/composer"  dest="/usr/bin/composer"
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR ${env_app_workdir}

USER ${arg_user}