DATA_DIR = /home/quentin/data

all: build up

up:
	@docker-compose -f ./srcs/docker-compose.yml up

build:
	@docker-compose -f ./srcs/docker-compose.yml build
	@sudo mkdir -p ${DATA_DIR}/wordpress
	@sudo mkdir -p ${DATA_DIR}/mariadb

down:
	@docker-compose -f ./srcs/docker-compose.yml down

re: down clean up

clean:
	@docker system prune -af
	@sudo rm -rf ${DATA_DIR}/*
