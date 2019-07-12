FROM php:7.2-fpm
MAINTAINER Dvagner <help@abantecart.com>

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    nginx \
    mysql-server \
    mc \
    net-tools && \
    docker-php-ext-install -j$(nproc) iconv mbstring mysqli pdo_mysql zip && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    service mysql start; mysql -u root -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'pass';";mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;";mysql -u root -e "create database abantecart;";

RUN sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf

ADD default /etc/nginx/sites-available/
ADD php.ini /usr/local/etc/php/conf.d/40-custom.ini

RUN git clone https://github.com/abantecart/abantecart-src.git /var/www/abantecart \
    && chown -R www-data:www-data /var/www/abantecart
WORKDIR /var/www/abantecart/public_html/

COPY resources /var/www/abantecart/public_html/resources
COPY abc.sql /var/www/abantecart/

RUN  service mysql start \
    && /usr/local/bin/php ./install/cli_install.php install --db_host=127.0.0.1 --db_user=admin --db_password=pass --db_name=abantecart  --db_driver=amysqli  --db_prefix=abc_ --admin_path=demo_admin --username=demo  --password=demo  --email=demo@demo.com  --http_server=http://demo.abantecart.com --https_server=https://demo.abantecart.com --with-sample-data \
    && mysql -u admin -ppass abantecart < /var/www/abantecart/abc.sql \
    && apt-get clean

EXPOSE 80 3306

ENTRYPOINT service mysql start && service nginx start && php-fpm