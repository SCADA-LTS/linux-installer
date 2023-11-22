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

#Java
JAVA_VERSION="11.0.19"
JAVA_UPDATE=7
MACHINE_TYPE=`uname -m`
INSTALLER_HOME=$(dirname "$(realpath "$0")")
JAVA_BASE="${INSTALLER_HOME}/java"
JDK_BASE="${JAVA_BASE}/jdk"

if [ ${MACHINE_TYPE} == 'arm64' ]; then
  export JAVA_HOME="${JDK_BASE}/Contents/Home"
else
  export JAVA_HOME="${JDK_BASE}"
fi
JAVA_BIN_DIR="$JAVA_HOME/bin"

if [ ! -d "${JAVA_BIN_DIR}" ]; then
    "${JAVA_BASE}"/java_install.sh "$JAVA_HOME" "${JAVA_VERSION}" "${JAVA_UPDATE}" "${JDK_BASE}"
fi

if [ ! -d "${BINDIR}" ]; then
    "${MYSQL_BASE}"/mysql_install.sh ${MYSQL_MAJOR_VERSION} ${MYSQL_MINOR_VERSION} ${MYSQL_PATCH_VERSION}
fi

if [ ! -d "${BINDIR}" ]; then
    echo "Not installed MySQL version ${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION} then running stop"
    exit 1
fi

cd "${BINDIR}"
./mysqld --defaults-file="${MY_CNF}" --datadir "$DATADIR" --console
