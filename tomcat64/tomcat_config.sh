#!/bin/bash
export CATALINA_HOME="$1"
cd "$CATALINA_HOME"
cd ..
CATALINA_BASE=`pwd`

CATALINA_SERVER_XML="$CATALINA_HOME/conf/server.xml"
CATALINA_LIB="$CATALINA_HOME/lib"
CATALINA_TOMCAT_USERS_XML="$CATALINA_HOME/conf/tomcat-users.xml"
CATALINA_WEBAPPS="$CATALINA_HOME/webapps"
SCADA_LTS_HOME="${CATALINA_WEBAPPS}/Scada-LTS"
CATALINA_CONTEXT_XML="${SCADA_LTS_HOME}/META-INF/context.xml"
CATALINA_BIN_DIR="$CATALINA_HOME/bin"

CATALINA_PORT=-1
CATALINA_USERNAME=""
CATALINA_PASSWORD=""

DATABASE_PORT=-1
DATABASE_USERNAME=""
DATABASE_PASSWORD=""
DATABASE_HOSTNAME=""

NUMBER_REGEX='^[0-9]+$'
HOSTNAME_REGEX='^[a-zA-Z0-9]+$'

cd "${CATALINA_BASE}"
unzip "Scada-LTS.war" -d "${SCADA_LTS_HOME}"
cp -rf context.xml "${CATALINA_CONTEXT_XML}"
cp -rf "${CATALINA_BASE}"/lib/*.jar "${CATALINA_LIB}"
cp -ar setenv.sh "${CATALINA_BIN_DIR}"

while [ ${CATALINA_PORT} -eq -1 ] || ! [[ ${CATALINA_PORT} =~ ${NUMBER_REGEX} ]]
do
    echo -n "[Apache Tomcat Server] Enter port: "
    read -r CATALINA_PORT
done
sed -i "s/<Connector port=\"8080\"/<Connector port=\"${CATALINA_PORT}\"/" "${CATALINA_SERVER_XML}"

if [ -z "${CATALINA_USERNAME}" ] || [ -z "${CATALINA_PASSWORD}" ]; then
    echo -n "[Apache Tomcat Server] Enter username: "
    read -r CATALINA_USERNAME
    while [ -z "${CATALINA_PASSWORD}" ]
    do

        echo -n "[Apache Tomcat Server] Enter password: "
        read -r CATALINA_PASSWORD

    done

    sed -ri "s|</tomcat-users>|<role rolename=\"monitoring\"\/><role rolename=\"manager\"\/><role rolename=\"manager-gui\"\/><role rolename=\"admin\"\/><role rolename=\"admin-script\"\/><role rolename=\"admin-gui\"\/><user username=\"${CATALINA_USERNAME}\" password=\"${CATALINA_PASSWORD//&/\\&amp;}\" roles=\"admin,manager,manager-gui,monitoring,admin-script,admin-gui\"\/></tomcat-users>|" "${CATALINA_TOMCAT_USERS_XML}"

fi

while [ ${DATABASE_PORT} -eq -1 ] || ! [[ ${DATABASE_PORT} =~ ${NUMBER_REGEX} ]]
do
    echo -n "[Apache Tomcat Server] Enter database port: "
    read -r DATABASE_PORT
done
sed -i "s/jdbc:mysql:\/\/localhost:3308/jdbc:mysql:\/\/localhost:${DATABASE_PORT}/" "${CATALINA_CONTEXT_XML}"

while [ -z "${DATABASE_HOSTNAME}" ] || ! [[ "${DATABASE_HOSTNAME}" =~ ${HOSTNAME_REGEX} ]]
do
    echo -n "[Apache Tomcat Server] Enter database host: "
    read -r DATABASE_HOSTNAME
done
sed -i "s/jdbc:mysql:\/\/localhost:${DATABASE_PORT}/jdbc:mysql:\/\/"${DATABASE_HOSTNAME}":${DATABASE_PORT}/" "${CATALINA_CONTEXT_XML}"

if [ -z "${DATABASE_USERNAME}" ] || [ -z "${DATABASE_PASSWORD}" ]; then
    echo -n "[Apache Tomcat Server] Enter database username: "
    read -r DATABASE_USERNAME
    sed -i "s/username=\"root\"/username=\"${DATABASE_USERNAME}\"/" "${CATALINA_CONTEXT_XML}"
    while [ -z "${DATABASE_PASSWORD}" ]
    do
        echo -n "[Apache Tomcat Server] Enter database password: "
        read -r DATABASE_PASSWORD
    done

    sed -ri "s|password=\"\"|password=\"${DATABASE_PASSWORD//&/\\&amp;}\"|" "${CATALINA_CONTEXT_XML}"

fi
echo "Tomcat version ${TOMCAT_VERSION} configured"