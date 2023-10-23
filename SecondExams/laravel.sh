#!/bin/bash

#update packages
sudo apt update

#install apache server
sudo apt install -y apache2

#enable apache to start on boot
sudo systemctl enable apache2

#start apache service
sudo service apache2 start

#install php
sudo apt install -y php libapache2-mod-php php-mysql

#install mysql
sudo apt install -y mysql-server

sudo mysql <<MYSQL_SCRIPT
CREATE USER 'ToGod'@'localhost' IDENTIFIED WITH mysql_native_password BY 'yeehha';
GRANT ALL PRIVILEGES ON *.* TO 'ToGod'@'localhost' WITH GRANT OPTION;
MYSQL_SCRIPT

#install composer
#php -r "copy('http://getcomposer.org/installer', 'composer-setup.php);"
#php composer-setup.php

#sudo mv composer.phar /usr/local/bin/composer

#install git and composer
sudo apt install -y git composer

#installing php extentins required by laravel
sudo apt install -y unzip
sudo apt install -y php-zip php-mysql php-xml php-curl

#clone githun application
cd /var/www/html
sudo rm index.html

git clone https://github.com/laravel/laravel

cd laravel

composer install

cp .env.example .env

sudo chown -R www-data:www-data /var/www/html/laravel

php artisan key:generate

#create the laravel application database
mysql -u appuser -p <<MYSQL_SCRIPT
CREATE DATABASE sample_app_db
MYSQL_SCRIPT

cat <<EOL > .env
DB_DATABASE=sample_app_db
DB_USERNAME=ToGd
DB_PASSWORD=yeehha
EOL

php artisan migrate

#cd /etc/apache2/sites-available/
# Configure the Apache virtual host for Laravel
echo "
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/laravel/public
    <Directory /var/www/html/laravel>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
        DirectoryIndex /resources/views/welcome.blade.php
    </Directory>
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" | sudo tee /etc/apache2/sites-available/laravel.conf

#enable site in apache
sudo a2ensite laravel.conf

sudo systemctl reload apache2

sudo a2enmod rewrite

sudo systemctl restart apache2
