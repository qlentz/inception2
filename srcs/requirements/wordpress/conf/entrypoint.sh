#!/bin/sh

sleep 10
chown -R www-data:www-data /var/www/*;
chown -R 755 /var/www/*;
if [ ! -d "/run/php" ]; then
	mkdir -p /run/php
	touch /run/php/php7.3-fpm.pid;
fi

# Wait for MySQL
until mysql -h "mariadb" -u "$SQL_USER" -p"$SQL_PASSWORD" -e "select 1" > /dev/null 2>&1; do
    echo "Waiting for MySQL..."
    sleep 1
done

echo "MySQL is up and running!"

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	# On utilise WP-CLI pour configurer WordPress
	cd /var/www/wordpress
	wp core download 	--allow-root
	wp config create 	--allow-root \
						--dbname=$SQL_DATABASE \
						--dbuser=$SQL_USER \
						--dbpass=$SQL_PASSWORD \
						--dbhost=mariadb.inception \
						--path=/var/www/wordpress
	wp core install --allow-root --url=${WP_URL} --title=${WP_TITLE} --admin_user=${WP_ADMIN_LOGIN} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL}
	wp user create --allow-root ${WP_USER_LOGIN} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD};
fi

# On lance le serveur php-fpm

/usr/sbin/php-fpm7.3 -F