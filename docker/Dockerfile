FROM php:7.2-fpm-stretch
MAINTAINER Denis Vagner <help@abantecart.com>

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    libwebp-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxpm-dev \
    nginx \
    mariadb-server \
    mc \
    net-tools  \
    libxml2-dev && \
    docker-php-ext-install -j$(nproc) iconv mbstring mysqli pdo_mysql zip soap && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    service mysql start;mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'pass';";mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;";mysql -u root -e "create database abantecart;";

RUN sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

ADD default.conf /etc/nginx/sites-available/default
ADD php.ini /usr/local/etc/php/conf.d/40-custom.ini

RUN git clone https://github.com/abantecart/abantecart-src.git /var/www/abantecart \
    && chown -R www-data:www-data /var/www/abantecart
WORKDIR /var/www/abantecart/public_html/

COPY abc.sql /var/www/abantecart/

RUN  service mysql start \
    && /usr/local/bin/php ./install/cli_install.php install --db_host=127.0.0.1 --db_user=admin --db_password=pass --db_name=abantecart  --db_driver=amysqli  --db_prefix=abc_ --admin_path=demo_admin --username=demo  --password=demo  --email=demo@demo.com  --http_server=http://demo.abantecart.com --https_server=https://demo.abantecart.com --with-sample-data \
    && mysql -u admin -ppass abantecart < /var/www/abantecart/abc.sql \
    && apt-get clean \
    && rm -rf /var/www/abantecart/public_html/install

COPY resources /var/www/abantecart/public_html/resources
COPY thumbnails /var/www/abantecart/public_html/image/thumbnails
COPY config.php /var/www/abantecart/public_html/system/

RUN chown -R www-data:www-data /var/www/abantecart

EXPOSE 80 3306

ENTRYPOINT service mysql start && service nginx start && php-fpm
