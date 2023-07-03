#!/bin/sh

mysql_install_db

# Start the daemon in background
/etc/init.d/mysql start

if [ ! -d "/var/lib/mysql/$SQL_DATABASE" ] ; then

# Set root option so that connexion without root password is not possible. Fields:
    # empty password
    # set root password ?
    # the new password
    # confirm the new password
    # remove anonymous users ?
    # disallow root login remotely ?
    # remove test database and access to it ?
    # reload privilege tables now ?
mysql_secure_installation << _EOF_

Y
$SQL_ROOT_PASSWORD
$SQL_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

# Root privileges
mysql --user=root << _EOF_
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$SQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
FLUSH PRIVILEGES;
ALTER USER '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
_EOF_

fi

# Stop the daemon
/etc/init.d/mysql stop

# Start the daemon in foreground
mysqld --user=root --console --bind-address=0.0.0.0