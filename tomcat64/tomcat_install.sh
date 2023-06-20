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

DATABASE_PORT=-1
DATABASE_USERNAME=""
DATABASE_PASSWORD=""

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
    TOMCAT_DEST="apache-tomcat-${TOMCAT_VERSION}"
    TOMCAT_TAR_GZ_FILE="${TOMCAT_DEST}.tar.gz"

    mkdir -p $CATALINA_HOME
    cd $CATALINA_HOME
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

    CATALINA_CONTEXT_XML=${SCADA_LTS_HOME}/META-INF/context.xml
    cd "${CATALINA_BASE}"
    unzip "Scada-LTS.war" -d ${SCADA_LTS_HOME}
    cp -rf context.xml ${CATALINA_CONTEXT_XML}
    cp -rf ${CATALINA_BASE}/lib/*.jar ${CATALINA_LIB}
    cp -ar setenv.sh ${CATALINA_BIN_DIR}

    if [[ ${CATALINA_PORT} -eq -1 ]]; then
        echo -n "[Apache Tomcat Server] Enter port: "
        read -r CATALINA_PORT
        sed -i "s/8080/${CATALINA_PORT}/" ${CATALINA_SERVER_XML}
    fi

    if [ -z ${CATALINA_USERNAME} ] || [ -z ${CATALINA_PASSWORD} ]; then
        echo -n "[Apache Tomcat Server] Enter username: "
        read -r CATALINA_USERNAME
        echo -n "[Apache Tomcat Server] Enter password: "
        read -r CATALINA_PASSWORD
        sed -i "s/<\/tomcat-users>/<role rolename=\"monitoring\"\/><role rolename=\"manager\"\/><role rolename=\"manager-gui\"\/><role rolename=\"admin\"\/><role rolename=\"admin-script\"\/><role rolename=\"admin-gui\"\/><user username=\"${CATALINA_USERNAME}\" password=\"${CATALINA_PASSWORD}\" roles=\"admin,manager,manager-gui,monitoring,admin-script,admin-gui\"\/><\/tomcat-users>/" ${CATALINA_TOMCAT_USERS_XML}
    fi

    if [[ ${DATABASE_PORT} -eq -1 ]]; then
        echo -n "[Apache Tomcat Server] Enter database port: "
        read -r DATABASE_PORT
        sed -i "s/jdbc:mysql:\/\/localhost:3308/jdbc:mysql:\/\/localhost:${DATABASE_PORT}/" ${CATALINA_CONTEXT_XML}
    fi

    if [ -z ${DATABASE_USERNAME} ] || [ -z ${DATABASE_PASSWORD} ]; then
        echo -n "[Apache Tomcat Server] Enter database username: "
        read -r DATABASE_USERNAME
        sed -i "s/username=\"root\"/username=\"${DATABASE_USERNAME}\"/" ${CATALINA_CONTEXT_XML}
        echo -n "[Apache Tomcat Server] Enter database password: "
        read -r DATABASE_PASSWORD
        sed -i "s/password=\"\"/password=\"${DATABASE_PASSWORD}\"/" ${CATALINA_CONTEXT_XML}
    fi
    echo "Tomcat version ${TOMCAT_VERSION} configured"
fi
$CATALINA_HOME/bin/catalina.sh run