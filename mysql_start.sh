#!/bin/bash
MYSQL_MAJOR_VERSION=8
MYSQL_MINOR_VERSION=0
MYSQL_PATCH_VERSION=33

INSTALLER_HOME=$(dirname "$(realpath "$0")")
MYSQL_BASE="${INSTALLER_HOME}/mysql"

export MYSQL_HOME="${MYSQL_BASE}/server"
export DATADIR="$MYSQL_HOME/data"
MY_CNF="$MYSQL_HOME/my.cnf"
BINDIR="$MYSQL_HOME/bin"

MYSQLD_PID="$DATADIR/mysqld.pid"

if [ ! -d "${BINDIR}" ]; then
    "${MYSQL_BASE}"/mysql_install.sh ${MYSQL_MAJOR_VERSION} ${MYSQL_MINOR_VERSION} ${MYSQL_PATCH_VERSION}
fi

cd "${BINDIR}"
./mysqld --defaults-file="${MY_CNF}" --datadir "$DATADIR" --pid-file="${MYSQLD_PID}" --console
