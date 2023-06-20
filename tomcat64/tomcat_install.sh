#!/bin/bash
export JAVA_HOME="$1/jdk"
export CATALINA_HOME="$2/server"
JAVA_BASE="$1"
CATALINA_BASE="$2"

CATALINA_SERVER_XML="$CATALINA_HOME/conf/server.xml"
CATALINA_LIB="$CATALINA_HOME/lib"
CATALINA_TOMCAT_USERS_XML="$CATALINA_HOME/conf/tomcat-users.xml"
JAVA_BIN_DIR="$JAVA_HOME/bin"
CATALINA_BIN_DIR="$CATALINA_HOME/bin"
CATALINA_PORT=-1
CATALINA_USERNAME=""
CATALINA_PASSWORD=""

CATALINA_WEBAPPS="$CATALINA_HOME/webapps"
SCADA_LTS_HOME="${CATALINA_WEBAPPS}/Scada-LTS"

if [ ! -d "${JAVA_BIN_DIR}" ]; then
    ${JAVA_BASE}/java_install.sh ${JAVA_BASE}
fi

if [ ! -d "$CATALINA_BIN_DIR" ]; then

    TOMCAT_MAJOR_VERSION=9
    TOMCAT_MINOR_VERSION=0
    TOMCAT_PATCH_VERSION=76
    TOMCAT_VERSION="${TOMCAT_MAJOR_VERSION}.${TOMCAT_MINOR_VERSION}.${TOMCAT_PATCH_VERSION}"
    TOMCAT_DEST = "apache-tomcat-${TOMCAT_VERSION}"
    TOMCAT_TAR_GZ_FILE="${TOMCAT_DEST}.tar.gz"

    cd "$CATALINA_HOME"
    wget "https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR_GZ_FILE}"
    tar -xvf ${TOMCAT_TAR_GZ_FILE} -C "$CATALINA_HOME"
    cd "$CATALINA_HOME/${TOMCAT_DEST}"
    mv * "$CATALINA_HOME"
    cd ..
    rm -rf ${TOMCAT_DEST}
    rm -f ${TOMCAT_TAR_GZ_FILE}
    echo "Tomcat version ${TOMCAT_VERSION} installed"
fi

if [ ! -d "${SCADA_LTS_HOME}" ]; then
    cd "${CATALINA_BASE}"
    unzip "Scada-LTS.war" -d ${SCADA_LTS_HOME}
    cp -rf context.xml ${SCADA_LTS_HOME}/META-INF/context.xml
    cp -rf ${CATALINA_BASE}/lib/*.jar ${CATALINA_LIB}

    if [${CATALINA_PORT} == -1]; then
        echo -n "Port: "
        read -r CATALINA_PORT
        sed -i "s/'port="8080"'/'port=${CATALINA_PORT}'/" ${CATALINA_SERVER_XML}
    fi

    if [-z ${CATALINA_USERNAME}] || [-z ${CATALINA_PASSWORD}]; then
        echo -n "User: "
        read -r ${CATALINA_USERNAME}
        echo -n "Password: "
        read -r ${CATALINA_PASSWORD}
        sed -i "s/'</tomcat-users>'/'<role rolename="monitoring"/><role rolename="manager"/><role rolename="manager-gui"/><role rolename="admin"/><user username="${CATALINA_USERNAME}" password="${CATALINA_PASSWORD}" roles="admin,manager,manager-gui,monitoring"/></tomcat-users>'/" ${CATALINA_TOMCAT_USERS_XML}
    fi
    echo "Tomcat version ${TOMCAT_VERSION} configured"
fi

$CATALINA_HOME/bin/catalina.sh run
