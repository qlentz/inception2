#!/bin/bash
set -e

# check if the database already exists
if [ ! -d "/var/lib/mysql/$MARIADB_DATABASE" ]; then
    # Database doesn't exist, initialize MariaDB
    mysql_install_db --user=mysql --datadir="/var/lib/mysql"

    # Start MariaDB in the background
    mysqld_safe --nowatch --datadir="/var/lib/mysql" &

    # Wait for MariaDB to start
    for i in {30..0}; do
        if echo 'SELECT 1' | mysql &> /dev/null; then
            break
        fi
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo >&2 'MariaDB start failed.'
        exit 1
    fi

    # Create a new database and user
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$SQL_DATABASE\` ;"
    mysql -e "GRANT ALL ON \`$SQL_DATABASE\`.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD' ;"
    mysql -e 'FLUSH PRIVILEGES ;'

    # Stop the MariaDB server
    mysqladmin shutdown -u root
fi

# Start MariaDB
exec mysqld_safe --datadir="/var/lib/mysql" --bind-address=0.0.0.0
