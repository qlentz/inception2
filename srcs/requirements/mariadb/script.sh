#!/bin/bash
set -e

# Initialize Database
if [ ! -d "/var/lib/mysql/$SQL_DATABASE" ]; then
    mysql_install_db --user=mysql --ldata=/var/lib/mysql/

    # Start MariaDB
    /usr/bin/mysqld_safe --datadir="/var/lib/mysql" &

    # Make sure it's started
    for i in {30..0}; do
        if echo 'SELECT 1' | mysql &> /dev/null; then
            break
        fi
        sleep 1
    done

    if [ "$i" = 0 ]; then
        echo >&2 'MySQL init process failed.'
        exit 1
    fi

    # Set root password and create WordPress database, and user
    mysql -u root -e "SET @@SESSION.SQL_LOG_BIN=0;"
    mysql -u root -e "DELETE FROM mysql.user WHERE user = '';"
    mysql -u root -e "CREATE USER '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
    mysql -u root -e "GRANT ALL ON *.* TO '$SQL_USER'@'%';"
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
    mysql -u root -e "GRANT ALL ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
    mysql -u root -e "UPDATE mysql.user SET Password=PASSWORD('$SQL_ROOT_PASSWORD') WHERE User='root';"
    mysql -u root -e "FLUSH PRIVILEGES;"


    # Stop MariaDB
    mysqladmin shutdown
fi

# Start MariaDB
exec /usr/bin/mysqld_safe --datadir="/var/lib/mysql"
