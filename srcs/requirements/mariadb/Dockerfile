FROM debian:buster

RUN	apt-get update -y
RUN	apt-get install -y mariadb-server 

COPY ./mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]

