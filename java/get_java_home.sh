#!/bin/bash
JDK_BASE="$1";
MACHINE_TYPE=$(uname -m);
JAVA_HOME="";
if [ ${MACHINE_TYPE} == "arm64" ]; then
  JAVA_HOME="${JDK_BASE}/Contents/Home";
else
  JAVA_HOME="${JDK_BASE}";
fi
echo "${JAVA_HOME}";