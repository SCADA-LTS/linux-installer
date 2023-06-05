#!/bin/bash
export MYSQL_HOME="`pwd`/mysql/server"
export MYSQL_BASE="`pwd`/mysql"

export MY_CNF="$MYSQL_BASE/my.cnf"
export BINDIR="$MYSQL_HOME/bin"
export DATADIR="$MYSQL_HOME/data"

export MYSQLD_PID="$DATADIR/mysqld.pid"

if [ ! -d "$DATADIR" ]; then
    $MYSQL_BASE/mysql_install.sh $MYSQL_BASE
fi

cd $BINDIR
./mysqld --defaults-file=$MY_CNF --datadir $DATADIR --pid-file=$MYSQLD_PID --console

