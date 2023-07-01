FROM debian:buster

RUN apt update && apt upgrade -y
RUN apt install -y nginx
RUN apt install -y openssl

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=qlentz.42.fr/UID=qlentz"

COPY ./conf/default.conf /etc/nginx/sites-enabled/default.conf

RUN mkdir -p /var/www/wordpress
RUN chmod 755 /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress

CMD [ "nginx", "-g", "daemon off;" ]