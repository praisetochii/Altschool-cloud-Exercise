# LAMP Stack and Laravel Deployment Script

This bash script automates the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack and a Laravel application on an Ubuntu-based server. The script includes the installation of necessary packages, configuration of the webserver (Apache), and the setup of a MySQL database.

# Prerequisites

An Ubuntu-based server.

Sudo privileges on the server.

# Instructions

1. Update Packages:

Update the package list to ensure you have the latest information on available packages.

![alt](/pictures/update.png)

2. Install Apache Server:

Install the Apache web server and enable it to start on boot.

![alt](/pictures/apache.png)

3. Install PHP and MySQL:

Install PHP and the PHP extension for MySQL. Also, install MySQL server.

![alt](/pictures/phpsql.png)

4. Create MySQL User and Database:

Create a MySQL user and grant privileges. Replace 'appuser' and 'password' with your desired username and password.

![alt](/pictures/sqlset.png)

5. Install Git, Composer and php extentions:

Install Git and Composer, a PHP dependency manager and PHP extentions required by laravel.

![alt](/pictures/gitext.png)

6. Clone Laravel Application:

Remove the default Apache index.html and clone a Laravel application from GitHub.

7. Install Laravel Dependencies:

Install Laravel dependencies using Composer.

![alt](/pictures/clone.png)

8. Configure Environment and Permissions:

Copy the Laravel environment file, set appropriate permissions, and generate an application key.

![alt](/pictures/artisan.png)

9. Create Laravel Database:

Create the Laravel application database. Replace 'sample_app_db' with your preferred database name.

![alt](/pictures/DB.png)

10. Configure Apache Virtual Host:

Create a configuration file for the Apache virtual host. This step includes setting the DocumentRoot and Directory settings.

![alt](/SecondExams/pngs/80.png)

11. Enable the Site in Apache and Restart Apache and Enable Mod Rewrite:

Enable the newly created site in Apache and Reload Apache configuration and enable the mod_rewrite module.

![alt](/SecondExams/png/lastpic.png)
