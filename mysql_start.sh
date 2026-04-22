#!/bin/bash
MYSQL_MAJOR_VERSION=8;
MYSQL_MINOR_VERSION=0;
MYSQL_PATCH_VERSION=36;

INSTALLER_HOME=$(dirname "$(realpath "$0")");
MYSQL_BASE="${INSTALLER_HOME}/mysql";

export MYSQL_HOME="${MYSQL_BASE}/server";
export DATADIR="${MYSQL_BASE}/data";
MY_CNF="$MYSQL_HOME/my.cnf";
BINDIR="$MYSQL_HOME/bin";
MY_CNF_REL="../my.cnf";
DATADIR_REL="../../data";

MYSQLD_PID="$DATADIR/mysqld.pid";

#Java
JAVA_VERSION="11.0.22";
JAVA_UPDATE=7;

INSTALLER_HOME=$(dirname "$(realpath "$0")");
JAVA_BASE="${INSTALLER_HOME}/java";
JDK_BASE="${JAVA_BASE}/jdk";
JAVA_HOME=$("${JAVA_BASE}"/java_install.sh "${JAVA_BASE}" "${JAVA_VERSION}" "${JAVA_UPDATE}" "${JDK_BASE}" | tail -n 1);

is_directory_empty() {
    [ -z "$(ls -A "$1" 2>/dev/null)" ];
}

get_configured_datadir() {
    sed -n 's/^[[:space:]]*datadir[[:space:]]*=[[:space:]]*//p' "$1" | tail -n 1;
}

validate_mysql_data_dir() {
    local configured_datadir="";

    if [ ! -f "${MY_CNF}" ]; then
        echo "MySQL configuration file not found: ${MY_CNF}";
        return 1;
    fi

    configured_datadir=$(get_configured_datadir "${MY_CNF}");
    if [ -z "${configured_datadir}" ]; then
        echo "MySQL configuration does not define datadir in: ${MY_CNF}";
        echo "Expected datadir: ${DATADIR}";
        return 1;
    fi

    if [ "${configured_datadir}" != "${DATADIR}" ]; then
        echo "MySQL configuration points to a different data directory";
        echo "Configured in my.cnf: ${configured_datadir}";
        echo "Expected by installer: ${DATADIR}";
        if [ -d "${MYSQL_HOME}/data" ]; then
            echo "Detected stale server-local directory: ${MYSQL_HOME}/data";
        fi
        return 1;
    fi

    if [ ! -d "${DATADIR}" ]; then
        echo "MySQL data directory not found: ${DATADIR}";
        return 1;
    fi

    if is_directory_empty "${DATADIR}"; then
        echo "MySQL data directory is empty: ${DATADIR}";
        return 1;
    fi

    if [ ! -d "${DATADIR}/mysql" ] || [ ! -f "${DATADIR}/auto.cnf" ]; then
        echo "MySQL data directory is incomplete or invalid: ${DATADIR}";
        return 1;
    fi
}

if [ ! -d "${BINDIR}" ]; then
    "${MYSQL_BASE}"/mysql_install.sh ${MYSQL_MAJOR_VERSION} ${MYSQL_MINOR_VERSION} ${MYSQL_PATCH_VERSION} ${JAVA_HOME};
fi

if [ ! -d "${BINDIR}" ]; then
    echo "Not installed MySQL version ${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION} then running stop";
    exit 1;
fi

if ! validate_mysql_data_dir; then
    echo "MySQL data directory validation failed then running stop";
    exit 1;
fi

cd "${BINDIR}";
./mysqld --defaults-file="${MY_CNF_REL}" --datadir "${DATADIR_REL}" --console;
