#!/bin/bash
JAVA_BASE="`pwd`/java"
CATALINA_BASE="`pwd`/tomcat64"

if [ ! -d "${SCADA_LTS_HOME}" ]; then
    $CATALINA_BASE/tomcat_config.sh ${JAVA_BASE} ${CATALINA_BASE}
fi

$CATALINA_HOME/bin/catalina.sh run
