#!/bin/bash
JAVA_BASE="`pwd`/java"
CATALINA_BASE="`pwd`/tomcat64"
export CATALINA_HOME="${CATALINA_BASE}/server"
CATALINA_BIN_DIR="$CATALINA_HOME/bin"

if [ ! -d "${CATALINA_BIN_DIR}" ]; then
    $CATALINA_BASE/tomcat_install.sh ${JAVA_BASE} ${CATALINA_BASE}
fi

$CATALINA_HOME/bin/catalina.sh run
