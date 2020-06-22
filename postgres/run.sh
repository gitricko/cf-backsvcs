#!/bin/bash

DB_DIR=$(mktemp -d -t postgres.XXX) 

# Doing this becos of errors
# # running bootstrap script ... 2020-06-22 00:27:00.171 GMT [368] LOG:  could not open directory "/tmp/contents913230314/deps/0/conda/envs/dep_env/share/timezone": No such file or directory
LINK_DIR=$(initdb -L /home/vcap/deps/0/conda/envs/dep_env/share -D ${DB_DIR}/postgres 2>&1 | grep '/tmp/contents'| head -1 | grep -oP '(?<=tmp/).*?(?=/deps)')
echo "Link directory = /tmp/${LINK_DIR}"
ln -s /home/vcap/ /tmp/${LINK_DIR}

initdb -L /home/vcap/deps/0/conda/envs/dep_env/share -D ${DB_DIR}/postgres

# Configure pg_hdb.conf file
echo "host    all             all             0.0.0.0/0            trust" >> ${DB_DIR}/postgres/pg_hba.conf

(
    sleep 5
    createuser --no-password --superuser postgresdev
    createdb --owner=postgresdev cfdb
    echo "Users and local db is created..."
) &

postgres -i -N 200 -D ${DB_DIR}/postgres

# nc -l 8080

#ln -s /home/vcap/ /tmp/contents913230314
