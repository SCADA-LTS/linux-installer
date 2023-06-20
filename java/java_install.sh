#!/bin/bash
export JAVA_HOME="$1"
JAVA_BIN_DIR="$JAVA_HOME/bin"

JAVA_VERSION="11.0.19"
JAVA_UPDATE="7"

JAVA_VERSION_ENCODED="${JAVA_VERSION}%2B${JAVA_UPDATE}"
JAVA_VERSION="${JAVA_VERSION}_${JAVA_UPDATE}"
JDK_DEST="jdk-${JAVA_VERSION}+${JAVA_UPDATE}"

JAVA_ARCH=""
MACHINE_TYPE=`uname -m`
SERVER_MYSQL_DEST=""
SHELL_MYSQL_DEST=""

if [ ${MACHINE_TYPE} == 'aarch64' ]; then
    echo "raspberry arm machine detected"
    JAVA_ARCH="OpenJDK11U-jdk_aarch64_linux_hotspot_"
elif [ ${MACHINE_TYPE} == 'x86_64' ] || [ ${MACHINE_TYPE} == 'x64' ]; then
    echo "64-bit machine detected"
    JAVA_ARCH="OpenJDK11U-jdk_x64_linux_hotspot_"
else
    echo "x86 architecture, 32-bit is not supported"
fi

if [ ! -d "$JAVA_BIN_DIR" ] && [! -z ${JAVA_ARCH} ]; then
    JDK_TAR_GZ_FILE=${JAVA_ARCH}${JAVA_VERSION}".tar.gz"
    cd "$JAVA_HOME"
    wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-${JAVA_VERSION_ENCODED}/${JDK_TAR_GZ_FILE}
    tar -xvf ${JDK_TAR_GZ_FILE} -C "$JAVA_HOME"
    cd "$JAVA_HOME/${JDK_DEST}"
    mv * "$JAVA_HOME"
    cd ..
    rm -rf ${JDK_DEST}
    rm -f ${JDK_TAR_GZ_FILE}
fi

