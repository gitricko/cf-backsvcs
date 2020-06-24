#!/bin/bash

DB_DIR=$(mktemp -d -t postgres.XXX) 

# Doing this becos of errors
# # running bootstrap script ... 2020-06-22 00:27:00.171 GMT [368] LOG:  could not open directory "/tmp/contents913230314/deps/0/conda/envs/dep_env/share/timezone": No such file or directory
LINK_DIR=$(initdb -L /home/vcap/deps/0/conda/envs/dep_env/share -D ${DB_DIR}/postgres 2>&1 | grep '/tmp/contents'| head -1 | grep -oP '(?<=tmp/).*?(?=/deps)')
IP_ADDR=$(/sbin/ifconfig eth0 | head -2 | tail -1 | awk '{print $2}')
echo "Link directory = /tmp/${LINK_DIR}"
echo "Internal IP Address: ${IP_ADDR}"
ln -s /home/vcap/ /tmp/${LINK_DIR}

initdb -L /home/vcap/deps/0/conda/envs/dep_env/share -D ${DB_DIR}/postgres

# Configure pg_hdb.conf file
echo "host    all             all             0.0.0.0/0            trust" >> ${DB_DIR}/postgres/pg_hba.conf
echo "host    replication             all             0.0.0.0/0            trust" >> ${DB_DIR}/postgres/pg_hba.conf

# echo "host    all             all             ${IP_ADDR}/32            trust" >> ${DB_DIR}/postgres/pg_hba.conf

echo "port = 5432" >> ${DB_DIR}/postgres/my_custom.conf
echo "listen_addresses = '0.0.0.0'" >> ${DB_DIR}/postgres/my_custom.conf
echo "include = 'my_custom.conf'" >> ${DB_DIR}/postgres/postgresql.conf

(
    sleep 5
    createuser --no-password --superuser postgres
    # createdb --owner=postgres postgres
    echo "GRANT CONNECT ON DATABASE postgres TO postgres;" | psql postgres
    echo "Users and local db is created..."
) &

postgres -i -N 200 -D ${DB_DIR}/postgres

echo "Postgres crash !...."
nc -l 8081
