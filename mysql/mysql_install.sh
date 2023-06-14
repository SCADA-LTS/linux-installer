#!/bin/bash
export USER="root"
export INIT_SCHEMA="$1/scadalts.sql"
export MY_CNF="$1/my.cnf"

export MYSQL_HOME="$1/server/"
export SHELL_HOME="$1/client/"

export DATADIR="$MYSQL_HOME/data"
export SERVER_BIN_DIR="$MYSQL_HOME/bin"
export CLIENT_BIN_DIR="$SHELL_HOME/bin"

if [ ! -d "$SERVER_BIN_DIR" ]; then

    export SERVER_MYSQL_DEST="mysql-8.0.33-linux-glibc2.12-x86_64"
    export SERVER_MSQL_TAR_FILE=$SERVER_MYSQL_DEST".tar"
    export SERVER_MSQL_TAR_XZ_FILE=$SERVER_MYSQL_DEST".tar.xz"

    cd "$MYSQL_HOME"
    wget https://dev.mysql.com/get/Downloads/MySQL-8.0/$SERVER_MSQL_TAR_FILE
    tar -xvf $SERVER_MSQL_TAR_FILE -C "$MYSQL_HOME"
    tar -xvf $SERVER_MSQL_TAR_XZ_FILE -C "$MYSQL_HOME"
    cd "$MYSQL_HOME/$SERVER_MYSQL_DEST"
    mv * "$MYSQL_HOME"
    cd ..
    rm -rf $SERVER_MYSQL_DEST
    rm -f $SERVER_MSQL_TAR_FILE
    rm -f *.tar.xz
fi

if [ ! -d "$CLIENT_BIN_DIR" ]; then

    export SHELL_MYSQL_DEST="mysql-shell-8.0.33-linux-glibc2.12-x86-64bit"
    export SHELL_MYSQL_TAR_GZ_FILE=$SHELL_MYSQL_DEST".tar.gz"

    cd "$SHELL_HOME"
    wget https://dev.mysql.com/get/Downloads/MySQL-Shell/$SHELL_MYSQL_TAR_GZ_FILE
    tar -xvf $SHELL_MYSQL_TAR_GZ_FILE -C "$SHELL_HOME"
    cd "$SHELL_HOME/$SHELL_MYSQL_DEST"
    mv * "$SHELL_HOME"
    cd ..
    rm -rf $SHELL_MYSQL_DEST
    rm -f $SHELL_MYSQL_TAR_GZ_FILE
fi

if [ ! -d "$DATADIR" ]; then
  mkdir -p $DATADIR
  cd $SERVER_BIN_DIR
  ./mysqld --defaults-file=$MY_CNF --initialize-insecure --datadir $DATADIR --user=$USER --init-file=$INIT_SCHEMA --console
fi

