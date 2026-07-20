#!/bin/bash
INSTALLER_HOME=$(dirname "$(realpath "$0")")
MYSQL_BASE="${INSTALLER_HOME}/mysql"
MYSQL_HOME="${MYSQL_BASE}/server"
BINDIR="${MYSQL_HOME}/bin"

cd "${BINDIR}";
./mysqladmin --socket="/tmp/scadalts_mysqld.sock" -u root -p shutdown;
