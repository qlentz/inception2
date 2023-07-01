FROM debian:buster

RUN apt update && apt upgrade -y
RUN apt install -y mariadb-server

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT [ "sh" , "/tmp/entrypoint.sh"]