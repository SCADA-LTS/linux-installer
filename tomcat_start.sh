#!/bin/bash
export START_PATH="`pwd`"
export JAVA_BASE="`pwd`/java"
export JAVA_HOME="`pwd`/java/jdk"
export CATALINA_HOME="`pwd`/tomcat64"
export JAVA_BIN_DIR="$JAVA_HOME/bin"

export CATALINA_WEBAPPS="$CATALINA_HOME/webapps"
export SCADA_LTS_HOME="$CATALINA_WEBAPPS/Scada-LTS"

if [ ! -d "$JAVA_BIN_DIR" ]; then
    $JAVA_BASE/java_install.sh $JAVA_BASE
fi

if [ ! -d "$SCADA_LTS_HOME" ]; then
    cd "$CATALINA_WEBAPPS"
    unzip "$SCADA_LTS_HOME.war" -d $SCADA_LTS_HOME
    cd $START_PATH
    cp -rf context.xml $SCADA_LTS_HOME/META-INF/context.xml
fi

$CATALINA_HOME/bin/catalina.sh run
