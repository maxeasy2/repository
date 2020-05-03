#!/bin/bash
CONF_PATH=${1:-.}
SQL=`cat server.sql | sed "s/{conf_path}/\${CONF_PATH}/g"`

#echo $SQL


./sqlite3 ./database.db "$SQL"
