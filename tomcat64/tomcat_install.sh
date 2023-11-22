#!/bin/bash
export CATALINA_HOME="$1"
TOMCAT_MAJOR_VERSION="$2"
TOMCAT_VERSION="$3"
TOMCAT_DEST="apache-tomcat-${TOMCAT_VERSION}"
TOMCAT_TAR_GZ_FILE="${TOMCAT_DEST}.tar.gz"

if ! command -v wget &> /dev/null
then
    echo "wget could not be found then Tomcat version ${TOMCAT_VERSION} installation stop"
    exit 1
fi
mkdir -p "$CATALINA_HOME"
cd "$CATALINA_HOME"
if [ ! -f "$TOMCAT_TAR_GZ_FILE" ]; then
  wget "https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR_GZ_FILE}"
fi
tar -xvf "${TOMCAT_TAR_GZ_FILE}" -C "$CATALINA_HOME"
cd "$CATALINA_HOME/${TOMCAT_DEST}"
mv * "$CATALINA_HOME"
cd ..
rm -rf "${TOMCAT_DEST}"
#rm -f "${TOMCAT_TAR_GZ_FILE}"
echo "Tomcat version ${TOMCAT_VERSION} installed"