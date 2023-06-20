#!/bin/bash
MYSQL_BASE="`pwd`/mysql"
export MYSQL_HOME="${MYSQL_BASE}/server"
export DATADIR="$MYSQL_HOME/data"
MY_CNF="$MYSQL_HOME/my.cnf"
BINDIR="$MYSQL_HOME/bin"

MYSQLD_PID="$DATADIR/mysqld.pid"

if [ ! -d $DATADIR ]; then
    $MYSQL_BASE/mysql_install.sh $MYSQL_BASE
fi

cd $BINDIR
./mysqld --defaults-file=${MY_CNF} --datadir $DATADIR --pid-file=${MYSQLD_PID} --console

