#!/bin/bash
JAVA_VERSION="11.0.22"
JAVA_UPDATE=7

TOMCAT_MAJOR_VERSION=9
TOMCAT_MINOR_VERSION=0
TOMCAT_PATCH_VERSION=86
TOMCAT_VERSION="${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION}"
MACHINE_TYPE=`uname -m`

INSTALLER_HOME=$(dirname "$(realpath "$0")")
JAVA_BASE="${INSTALLER_HOME}/java"
CATALINA_BASE="${INSTALLER_HOME}/tomcat"
JDK_BASE="${JAVA_BASE}/jdk"

if [ ${MACHINE_TYPE} == 'arm64' ]; then
  export JAVA_HOME="${JDK_BASE}/Contents/Home"
else
  export JAVA_HOME="${JDK_BASE}"
fi

export CATALINA_HOME="${CATALINA_BASE}/server"

JAVA_BIN_DIR="$JAVA_HOME/bin"
CATALINA_BIN_DIR="$CATALINA_HOME/bin"

CATALINA_WEBAPPS="$CATALINA_HOME/webapps"
SCADA_LTS_HOME="${CATALINA_WEBAPPS}/Scada-LTS"

if [ ! -d "${JAVA_BIN_DIR}" ]; then
    "${JAVA_BASE}"/java_install.sh "$JAVA_HOME" "${JAVA_VERSION}" "${JAVA_UPDATE}" "${JDK_BASE}"
fi

if [ ! -d "${CATALINA_BIN_DIR}" ]; then
    "$CATALINA_BASE"/tomcat_install.sh "$CATALINA_HOME" ${TOMCAT_MAJOR_VERSION} "${TOMCAT_VERSION}"
fi

if [ ! -d "${CATALINA_BIN_DIR}" ]; then
    echo "Not installed Tomcat version ${TOMCAT_VERSION} then configuration stop"
    exit 1
fi

if [ ! -d "${SCADA_LTS_HOME}" ]; then
    "$CATALINA_BASE"/tomcat_config.sh "$CATALINA_HOME" "${TOMCAT_VERSION}"
fi

"$CATALINA_HOME"/bin/catalina.sh run
