#!/bin/bash
export JAVA_HOME="`pwd`/java"
export CATALINA_HOME="`pwd`/tomcat64"
$CATALINA_HOME/bin/catalina.sh run
