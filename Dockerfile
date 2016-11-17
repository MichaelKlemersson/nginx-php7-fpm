FROM nginx:alpine

MAINTAINER Michael Klemersson <michaelklemersson10@gmail.com>

ENV php_conf /etc/php7/php.ini
ENV fpm_conf /etc/php7/php-fpm.d/www.conf

RUN sed -i -e "s/v3.4/edge/" /etc/apk/repositories && apk update \
    && apk --no-cache add bash curl php7 php7-fpm php7-mbstring php7-mcrypt php7-xml \
    php7-fpm \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqlnd \
    php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-ctype \
    php7-zlib \
    php7-gd \
    php7-exif \
    php7-intl \
    php7-sqlite3 \
    php7-pdo_pgsql \
    php7-pgsql \
    php7-xml \
    php7-xsl \
    php7-curl \
    php7-openssl \
    php7-iconv \
    php7-json \
    php7-phar \
    php7-soap \
    php7-dom \
    php7-zip \
    php7-session \
    && sed -i  \
            -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
            -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" \
            -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" \
            -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
            ${php_conf} \
   && sed -i \
            -e "s/^;clear_env = no$/clear_env = no/" \
            ${fpm_conf} \
   && mkdir -p /etc/nginx/sites-available/ \
   && mkdir -p /etc/nginx/sites-enabled/ \
   && rm -rf /var/www \
   && mkdir -p /var/www/app

COPY build/nginx.conf /etc/nginx

VOLUME ["/var/www/app", "/var/log/nginx"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
