#!/bin/bash
MYSQL_MAJOR_VERSION=8;
MYSQL_MINOR_VERSION=0;
MYSQL_PATCH_VERSION=46;

INSTALLER_HOME="$(dirname "$(realpath "$0")")";
MYSQL_BASE="${INSTALLER_HOME}/mysql";

MYSQL_HOME="${MYSQL_BASE}/server";
DATADIR="${MYSQL_HOME}/data";
MY_CNF="${MYSQL_HOME}/my.cnf";
BINDIR="${MYSQL_HOME}/bin";

MYSQLD_PID="${DATADIR}/mysqld.pid";

#Java
JAVA_MAJOR_VERSION=17
JAVA_MINOR_VERSION=0
JAVA_PATCH_VERSION=19
JAVA_VERSION="${JAVA_MAJOR_VERSION}.${JAVA_MINOR_VERSION}.${JAVA_PATCH_VERSION}"
JAVA_UPDATE=10

JAVA_BASE="${INSTALLER_HOME}/java";
JDK_BASE="${JAVA_BASE}/jdk";
JAVA_HOME=$("${JAVA_BASE}"/java_install.sh "${JAVA_BASE}" "${JAVA_MAJOR_VERSION}" "${JAVA_VERSION}" "${JAVA_UPDATE}" "${JDK_BASE}" | tail -n 1);

echo "JAVA_HOME: ${JAVA_HOME}"

if [ ! -d "${BINDIR}" ]; then
    "${MYSQL_BASE}"/mysql_install.sh "${MYSQL_MAJOR_VERSION}" "${MYSQL_MINOR_VERSION}" "${MYSQL_PATCH_VERSION}" "${JAVA_HOME}";
fi

if [ ! -d "${BINDIR}" ]; then
    echo "Not installed MySQL version ${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION} then running stop";
    exit 1;
fi

cd "${BINDIR}";
./mysqld --defaults-file="${MY_CNF}" --datadir "${DATADIR}" --console;
