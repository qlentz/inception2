# Dockerfile
FROM debian:buster

# Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copy the database setup script to the Docker image
COPY script.sh /script.sh

# Change the permissions of the script to be executable
RUN chmod +x /script.sh

# Run the command on container startup
CMD ["/script.sh"]

