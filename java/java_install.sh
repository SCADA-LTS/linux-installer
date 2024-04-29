#!/bin/bash
JAVA_BASE="$1";
JAVA_VERSION="$2";
JAVA_UPDATE="$3";
JDK_BASE="$4";

JAVA_HOME=$("${JAVA_BASE}"/get_java_home.sh "${JDK_BASE}" | tail -n 1);
JAVA_BIN_DIR="${JAVA_HOME}/bin";
JAVA_VERSION_ENCODED="${JAVA_VERSION}%2B${JAVA_UPDATE}";
JAVA_FULL_VERSION="${JAVA_VERSION}_${JAVA_UPDATE}";
JDK_DEST="jdk-${JAVA_VERSION}+${JAVA_UPDATE}";
JAVA_ARCH="";
MACHINE_TYPE=$(uname -m);
SERVER_MYSQL_DEST="";
SHELL_MYSQL_DEST="";

if ! command -v wget &> /dev/null
then
    echo "wget could not be found then JDK version ${JAVA_FULL_VERSION} installation stop";
    exit 1;
fi

if [ ${MACHINE_TYPE} == 'arm64' ]; then
    echo "arm64 (Apple Silicon M1/M2/M3) machine detected";
    JAVA_ARCH="OpenJDK11U-jdk_aarch64_mac_hotspot_";
elif [ ${MACHINE_TYPE} == 'aarch64' ]; then
    echo "raspberry arm machine detected";
    JAVA_ARCH="OpenJDK11U-jdk_aarch64_linux_hotspot_";
elif [ "${MACHINE_TYPE}" == 'x86_64' ] || [ "${MACHINE_TYPE}" == 'x64' ]; then
    echo "64-bit machine detected";
    JAVA_ARCH="OpenJDK11U-jdk_x64_linux_hotspot_";
else
    echo "x86 architecture, 32-bit is not supported";
fi

if [ ! -d "${JAVA_BIN_DIR}" ] && [ ! -z ${JAVA_ARCH} ]; then
    JDK_TAR_GZ_FILE=${JAVA_ARCH}${JAVA_FULL_VERSION}".tar.gz";
    mkdir -p "${JDK_BASE}";
    cd "${JDK_BASE}";
    if [ ! -f "$JDK_TAR_GZ_FILE" ]; then
      wget https://github.com/adoptium/temurin11-binaries/releases/download/jdk-"${JAVA_VERSION_ENCODED}"/"${JDK_TAR_GZ_FILE}";
      if [ $? -ne 0 ]; then
        echo "Download ${JDK_TAR_GZ_FILE} failed then JDK version ${JAVA_FULL_VERSION} installation stop";
        exit 1;
      fi
    fi
    tar -xvf "${JDK_TAR_GZ_FILE}" -C "${JDK_BASE}";
    cd "${JDK_BASE}/${JDK_DEST}";
    mv * "${JDK_BASE}";
    cd ..;
    rm -rf "${JDK_DEST}";
    #rm -f "${JDK_TAR_GZ_FILE}";
    echo "JDK version ${JAVA_FULL_VERSION} installed";
fi
echo "${JAVA_HOME}";