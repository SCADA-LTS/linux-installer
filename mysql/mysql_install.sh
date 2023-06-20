#!/bin/bash
export MYSQL_HOME="$1/server/"
export SHELL_HOME="$1/client/"
export DATADIR="$MYSQL_HOME/data"

USER="root"
INIT_SCHEMA="$1/scadalts.sql"
MY_CNF="$1/my.cnf"

SERVER_BIN_DIR="$MYSQL_HOME/bin"
SERVER_TMP_DIR="$MYSQL_HOME/tmp"
SERVER_LOG_DIR="$MYSQL_HOME/log"
CLIENT_BIN_DIR="$SHELL_HOME/bin"

MYSQL_PORT=-1

MACHINE_TYPE=`uname -m`

MYSQL_MAJOR_VERSION=8
MYSQL_MINOR_VERSION=0
MYSQL_PATCH_VERSION=33
MYSQL_VERSION="${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION}"

SERVER_MYSQL_DEST=""
SHELL_MYSQL_DEST=""

if [ ${MACHINE_TYPE} == 'aarch64' ]; then
    echo "raspberry arm machine detected"
    SERVER_MYSQL_DEST="mysql-${MYSQL_VERSION}-linux-glibc2.17-aarch64-minimal"
elif [ ${MACHINE_TYPE} == 'x86_64' ] || [ ${MACHINE_TYPE} == 'x64' ]; then
    echo "64-bit machine detected"
    SERVER_MYSQL_DEST="mysql-${MYSQL_VERSION}-linux-glibc2.17-x86_64-minimal"
    SHELL_MYSQL_DEST="mysql-shell-${MYSQL_VERSION}-linux-glibc2.12-x86-64bit"
else
    echo "x86 32-bit architecture is not supported"
fi

if [ ! -d ${SERVER_BIN_DIR} ] && [ ! -z ${SERVER_MYSQL_DEST} ]; then

    SERVER_MSQL_TAR_FILE="${SERVER_MYSQL_DEST}.tar"
    SERVER_MSQL_TAR_XZ_FILE="${SERVER_MYSQL_DEST}.tar.xz"

    mkdir -p $MYSQL_HOME
    cd $MYSQL_HOME
    wget "https://dev.mysql.com/get/Downloads/MySQL-${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}/${SERVER_MSQL_TAR_FILE}"
    tar -xvf ${SERVER_MSQL_TAR_FILE} -C $MYSQL_HOME
    tar -xvf ${SERVER_MSQL_TAR_XZ_FILE} -C $MYSQL_HOME
    cd "$MYSQL_HOME/${SERVER_MYSQL_DEST}"
    mv * $MYSQL_HOME
    cd ..
    rm -rf ${SERVER_MYSQL_DEST}
    rm -f ${SERVER_MSQL_TAR_FILE}
    rm -f *.tar.xz
    cp -ar ${MY_CNF} $MYSQL_HOME
    if [ ${MYSQL_PORT} -eq -1 ]; then
        echo -n "[MySQL Community Server] Enter port: "
        read -r MYSQL_PORT
        echo "port = ${MYSQL_PORT}" >> $MYSQL_HOME/my.cnf
    fi
    mkdir -p ${SERVER_LOG_DIR}
    echo "MySQL Community Server version ${MYSQL_VERSION} installed"
fi

if [ ! -d ${CLIENT_BIN_DIR} ] && [ ! -z ${SHELL_MYSQL_DEST} ]; then

    SHELL_MYSQL_TAR_GZ_FILE="${SHELL_MYSQL_DEST}.tar.gz"

    mkdir -p "$SHELL_HOME"
    cd $SHELL_HOME
    wget "https://dev.mysql.com/get/Downloads/MySQL-Shell/${SHELL_MYSQL_TAR_GZ_FILE}"
    tar -xvf "${SHELL_MYSQL_TAR_GZ_FILE}" -C "$SHELL_HOME"
    cd "$SHELL_HOME/${SHELL_MYSQL_DEST}"
    mv * $SHELL_HOME
    cd ..
    rm -rf ${SHELL_MYSQL_DEST}
    rm -f ${SHELL_MYSQL_TAR_GZ_FILE}
    echo "MySQL Shell version ${MYSQL_VERSION} installed"
fi

mkdir -p ${SERVER_TMP_DIR}

if [ ! -d "$DATADIR" ]; then
  mkdir -p $DATADIR
  cd ${SERVER_BIN_DIR}
  ./mysqld --defaults-file="$MYSQL_HOME/my.cnf" --initialize-insecure --datadir $DATADIR --user="${USER}" --init-file="${INIT_SCHEMA}" --console
fi

