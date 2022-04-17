FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# Uploading packages and create dir for files
RUN apt-get update -y && \
apt-get install postgresql -y && apt-get install sudo -y && \
mkdir /db

# Setup /db as a workdir and while container
# starts copy scripts for start server for psql   
WORKDIR /db
COPY . .


USER postgres

# Server startup with creating db
RUN pg_ctlcluster 12 main start && \
psql -c "CREATE USER admin WITH SUPERUSER PASSWORD 'admin';" && \
#createdb -O admin admin && \
psql -c "\i db.sql" && \
psql -c "ALTER DATABASE userdb OWNER TO admin;" && \
pg_ctlcluster 12 main stop

# Configure remote connection
RUN echo "host all all 	0.0.0.0/0 md5" >> /etc/postgresql/12/main/pg_hba.conf && \
echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf
EXPOSE 5432


CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/12/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]

