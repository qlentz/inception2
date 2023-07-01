DATA_DIR = /home/quentin/data

all: build up

up:
	@docker-compose -f ./srcs/docker-compose.yml up
stop:
	@docker-compose -f ./srcs/docker-compose.yml stop

build:
	@docker-compose -f ./srcs/docker-compose.yml build

down:
	@docker-compose -f ./srcs/docker-compose.yml down
	@docker system prune -af
	@sudo rm -rf ${DATA_DIR}/mariadb/*
	@sudo rm -rf ${DATA_DIR}/wordpress/*

re: down clean up

clean:
	@docker system prune -af
	@sudo rm -rf ${DATA_DIR}/*
