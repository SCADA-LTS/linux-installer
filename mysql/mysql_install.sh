#!/bin/bash
MYSQL_MAJOR_VERSION=$1
MYSQL_MINOR_VERSION=$2
MYSQL_PATCH_VERSION=$3

MYSQL_VERSION="${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}.${MYSQL_PATCH_VERSION}"
MYSQL_INSTALLER_HOME=$(dirname "$(realpath "$0")")
export MYSQL_HOME="${MYSQL_INSTALLER_HOME}/server"
export SHELL_HOME="${MYSQL_INSTALLER_HOME}/client"
export DATADIR="$MYSQL_HOME/data"

INIT_SCHEMA="${MYSQL_INSTALLER_HOME}/scadalts.sql"
COPIED_INIT_SCHEMA="$MYSQL_HOME/scadalts.sql"
MY_CNF="${MYSQL_INSTALLER_HOME}/my.cnf"
COPIED_MY_CNF="$MYSQL_HOME/my.cnf"
SERVER_BIN_DIR="$MYSQL_HOME/bin"
CLIENT_BIN_DIR="$SHELL_HOME/bin"

MYSQL_PORT=-1
MYSQL_USERNAME=""
MYSQL_PASSWORD=""
MYSQL_ROOT_PASSWORD=""

MACHINE_TYPE=`uname -m`

SERVER_MYSQL_DEST=""
SHELL_MYSQL_DEST=""

PORT_REGEX='^((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-5]{0,5})|([0-9]{1,4}))$'
HOSTNAME_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(localhost)|^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)+([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
USERNAME_REGEX='^[a-zA-Z0-9_-]+$'

if ! command -v wget &> /dev/null
then
    echo "wget could not be found then MySQL Community Server version ${MYSQL_VERSION} installation stop"
    exit 1
fi

if [ ${MACHINE_TYPE} == 'arm64' ]; then
    echo "arm64 (Apple Silicon M1/M2) machine detected"
    SERVER_MYSQL_DEST="mysql-${MYSQL_VERSION}-macos13-arm64"
elif [ "${MACHINE_TYPE}" == 'aarch64' ]; then
    echo "raspberry ARM machine detected"
    SERVER_MYSQL_DEST="mysql-${MYSQL_VERSION}-linux-glibc2.17-aarch64-minimal"
elif [ "${MACHINE_TYPE}" == 'x86_64' ] || [ "${MACHINE_TYPE}" == 'x64' ]; then
    echo "64-bit machine detected"
    SERVER_MYSQL_DEST="mysql-${MYSQL_VERSION}-linux-glibc2.17-x86_64-minimal"
    SHELL_MYSQL_DEST="mysql-shell-${MYSQL_VERSION}-linux-glibc2.12-x86-64bit"
else
    echo "x86 32-bit architecture is not supported"
fi

if [ ! -d "${SERVER_BIN_DIR}" ] && [ ! -z "${SERVER_MYSQL_DEST}" ]; then

    SERVER_MSQL_TAR_FILE="${SERVER_MYSQL_DEST}.tar"

    if [ ${MACHINE_TYPE} == 'arm64' ]; then
        SERVER_MSQL_TAR_XZ_FILE="${SERVER_MYSQL_DEST}.tar.gz"
    else
        SERVER_MSQL_TAR_XZ_FILE="${SERVER_MYSQL_DEST}.tar.xz"
    fi
    mkdir -p "$MYSQL_HOME"
    cd "$MYSQL_HOME"
    if [ ! -f "$SERVER_MSQL_TAR_FILE" ]; then
      wget "https://dev.mysql.com/get/Downloads/MySQL-${MYSQL_MAJOR_VERSION}.${MYSQL_MINOR_VERSION}/${SERVER_MSQL_TAR_FILE}"
    fi
    tar -xvf "${SERVER_MSQL_TAR_FILE}" -C "$MYSQL_HOME"
    tar -xvf "${SERVER_MSQL_TAR_XZ_FILE}" -C "$MYSQL_HOME"
    cd "$MYSQL_HOME/${SERVER_MYSQL_DEST}"
    mv * "$MYSQL_HOME"
    cd ..
    rm -rf "${SERVER_MYSQL_DEST}"
    #rm -f "${SERVER_MSQL_TAR_FILE}"
    rm -f *.tar.xz
    rm -f *.tar.gz
    cp -a "${MY_CNF}" "${COPIED_MY_CNF}"
    cp -a "${INIT_SCHEMA}" "${COPIED_INIT_SCHEMA}"

    while [ ${MYSQL_PORT} -eq -1 ] || ! [[ ${MYSQL_PORT} =~ ${PORT_REGEX} ]]
    do
      echo -n "[MySQL Community Server] Enter port: "
      read -r MYSQL_PORT
    done
    echo "port = ${MYSQL_PORT}" >> "${COPIED_MY_CNF}"
    echo "mysqlx_port = 3${MYSQL_PORT}" >> "${COPIED_MY_CNF}"

    while [ -z "${MYSQL_USERNAME}" ] || ! [[ ${MYSQL_USERNAME} =~ ${USERNAME_REGEX} ]]
    do
      echo -n "[MySQL Community Server] Enter username: "
      read -r MYSQL_USERNAME
    done
    echo "user = ${MYSQL_USERNAME}" >> "${COPIED_MY_CNF}"

    while [ -z "${MYSQL_PASSWORD}" ]
    do
      echo -n "[MySQL Community Server] Enter password: "
      read -r MYSQL_PASSWORD
    done

    while [ -z "${MYSQL_HOST}" ] || ! [[ ${MYSQL_HOST} =~ ${HOSTNAME_REGEX} ]]
    do
      echo -n "[MySQL Community Server] Enter hostname: "
      read -r MYSQL_HOST
    done
    "${JAVA_HOME}"/bin/java -jar ../replace-1.0.jar -n "CREATE USER IF NOT EXISTS '${MYSQL_USERNAME}'@'${MYSQL_HOST}' IDENTIFIED BY '';GRANT ALL ON scadalts.* TO '${MYSQL_USERNAME}'@'${MYSQL_HOST}';FLUSH PRIVILEGES;" -f "${COPIED_INIT_SCHEMA}" -d "mysql" -p "${MYSQL_PASSWORD}"

    while [ -z "${MYSQL_ROOT_PASSWORD}" ]
    do
      echo -n "[MySQL Community Server] Enter root password: "
      read -r MYSQL_ROOT_PASSWORD
    done
    "${JAVA_HOME}"/bin/java -jar ../replace-1.0.jar -n "ALTER USER 'root'@'${MYSQL_HOST}' IDENTIFIED BY '';FLUSH PRIVILEGES;" -f "${COPIED_INIT_SCHEMA}" -d "mysql" -p "${MYSQL_ROOT_PASSWORD}"
    echo "MySQL Community Server version ${MYSQL_VERSION} installed"
fi

if [ ! -d "${CLIENT_BIN_DIR}" ] && [ ! -z "${SHELL_MYSQL_DEST}" ]; then

    SHELL_MYSQL_TAR_GZ_FILE="${SHELL_MYSQL_DEST}.tar.gz"

    mkdir -p "$SHELL_HOME"
    cd "$SHELL_HOME"
    if [ ! -f "$SHELL_MYSQL_TAR_GZ_FILE" ]; then
      wget "https://dev.mysql.com/get/Downloads/MySQL-Shell/${SHELL_MYSQL_TAR_GZ_FILE}"
    fi
    tar -xvf "${SHELL_MYSQL_TAR_GZ_FILE}" -C "$SHELL_HOME"
    cd "$SHELL_HOME/${SHELL_MYSQL_DEST}"
    mv * "$SHELL_HOME"
    cd ..
    rm -rf "${SHELL_MYSQL_DEST}"
    rm -f "${SHELL_MYSQL_TAR_GZ_FILE}"
    echo "MySQL Shell version ${MYSQL_VERSION} installed"
fi

if [ -d "${SERVER_BIN_DIR}" ] && [ ! -d "$DATADIR" ]; then
  mkdir -p "$DATADIR"
  cd "${SERVER_BIN_DIR}"
  ./mysqld --defaults-file="$MYSQL_HOME/my.cnf" --initialize-insecure --datadir "$DATADIR" --user="${MYSQL_USERNAME}" --init-file="${COPIED_INIT_SCHEMA}" --console
  echo "MySQL Community Server version ${MYSQL_VERSION} configured"
fi