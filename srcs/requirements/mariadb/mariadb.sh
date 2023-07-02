#!/bin/sh

mysql_install_db

# Start the daemon in background
/etc/init.d/mysql start

if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ] ; then

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
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
n
Y
Y
_EOF_

# Root privileges
mysql --user=root launch mysql command line client
mysql --user=root << _EOF_
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
_EOF_

# Create wordpress database and add user
mysql --user=root << _EOF_
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
FLUSH PRIVILEGES;
ALTER USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
_EOF_

fi

# Stop the daemon
/etc/init.d/mysql stop

# Start the daemon in foreground
mysqld --user=root --console --bind-address=0.0.0.0