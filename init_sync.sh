#!/bin/bash
# To make the slave follow the master correctly, you have to tell
# the slave where to read (LOG_FILE) and from which point(POSITION).
# This is what this script does.
#
# This script has to be runned from the phisical host and after vagrant up.
DB=$1

if [ -z "$DB" ]; then
  echo "Parameter database name required: $0 database_name"
  exit 1;
fi

# Configuration
M1_HOST="192.168.30.101"
M2_HOST="192.168.30.102"
M1_CONN=" -u root -h $M1_HOST "
M2_CONN=" -u root -h $M2_HOST "
MYSQL='mysql'

# Drop the database on both sides
SQL=" DROP DATABASE $DB "
$MYSQL $M1_CONN -e "$SQL"
$MYSQL $M2_CONN -e "$SQL"

# Create database on both sides
SQL=" CREATE DATABASE $DB "
$MYSQL $M1_CONN -e "$SQL"
$MYSQL $M2_CONN -e "$SQL"

# Init M1 Status
SQL="SHOW MASTER STATUS"
M1_DATA=$($MYSQL $M1_CONN -N -B -e "$SQL")
M1_LOG_FILE=$(echo "$M1_DATA" | cut -f1)
M1_POSITION=$(echo "$M1_DATA" | cut -f2)
echo "M1 FILE is $M1_LOG_FILE -- M1 position is $M1_POSITION"

# Init M2 Status
SQL="SHOW MASTER STATUS"
M2_DATA=$($MYSQL $M2_CONN -N -B -e "$SQL")
M2_LOG_FILE=$(echo "$M2_DATA" | cut -f1)
M2_POSITION=$(echo "$M2_DATA" | cut -f2)
echo "M2 FILE is $M2_LOG_FILE -- M2 position is $M2_POSITION"

# Init M2 Replication
SQL="STOP SLAVE; CHANGE MASTER TO MASTER_HOST='$M1_HOST',MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_LOG_FILE='$M1_LOG_FILE', MASTER_LOG_POS=  $M1_POSITION;"
$MYSQL $M2_CONN -e "$SQL"
SQL="START SLAVE;"
$MYSQL $M2_CONN -e "$SQL"

# Init M1 Replication
SQL="STOP SLAVE; CHANGE MASTER TO MASTER_HOST='$M2_HOST',MASTER_USER='repl', MASTER_PASSWORD='repl', MASTER_LOG_FILE='$M1_LOG_FILE', MASTER_LOG_POS=  $M2_POSITION;"
$MYSQL $M1_CONN -e "$SQL"
SQL="START SLAVE;"
$MYSQL $M1_CONN -e "$SQL"

echo "============ M2 SLAVE STATUS ============"
SQL="SHOW SLAVE STATUS;"
$MYSQL $M2_CONN -e "$SQL"

echo "============ M1 SLAVE STATUS ============"
SQL="SHOW SLAVE STATUS;"
$MYSQL $M1_CONN -e "$SQL"