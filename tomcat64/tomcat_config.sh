#!/bin/bash
export CATALINA_HOME="$1"
export TOMCAT_VERSION="$2"
CATALINA_BIN_DIR="$CATALINA_HOME/bin"

cd "$CATALINA_HOME"
cd ..
CATALINA_BASE=`pwd`

CATALINA_SERVER_XML="$CATALINA_HOME/conf/server.xml"
CATALINA_LIB="$CATALINA_HOME/lib"
CATALINA_TOMCAT_USERS_XML="$CATALINA_HOME/conf/tomcat-users.xml"
CATALINA_WEBAPPS="$CATALINA_HOME/webapps"
SCADA_LTS_HOME="${CATALINA_WEBAPPS}/Scada-LTS"
CATALINA_CONTEXT_XML="${SCADA_LTS_HOME}/META-INF/context.xml"

CATALINA_PORT=-1
CATALINA_USERNAME=""
CATALINA_PASSWORD=""

DATABASE_PORT=-1
DATABASE_USERNAME=""
DATABASE_PASSWORD=""
DATABASE_HOSTNAME=""

PORT_REGEX='^((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-5]{0,5})|([0-9]{1,4}))$'
HOSTNAME_REGEX="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(localhost)|^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)+([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$"
USERNAME_REGEX='^[a-zA-Z0-9_-]+$'

cd "${CATALINA_BASE}"
unzip "Scada-LTS.war" -d "${SCADA_LTS_HOME}"
cp -af context.xml "${CATALINA_CONTEXT_XML}"
cp -af "${CATALINA_BASE}"/lib/*.jar "${CATALINA_LIB}"
cp -a setenv.sh "${CATALINA_BIN_DIR}"

while [ ${CATALINA_PORT} -eq -1 ] || ! [[ ${CATALINA_PORT} =~ ${PORT_REGEX} ]]
do
    echo -n "[Apache Tomcat Server] Enter port: "
    read -r CATALINA_PORT
done
"${JAVA_HOME}"/bin/java -jar replace-1.0.jar -o "<Connector port=\"8080\"" -n "<Connector port=\"${CATALINA_PORT}\"" -f "${CATALINA_SERVER_XML}"


while [ -z "${CATALINA_USERNAME}" ] || ! [[ ${CATALINA_USERNAME} =~ ${USERNAME_REGEX} ]]
do
  echo -n "[Apache Tomcat Server] Enter username: "
  read -r CATALINA_USERNAME
done

while [ -z "${CATALINA_PASSWORD}" ]
do
    echo -n "[Apache Tomcat Server] Enter password: "
    read -r CATALINA_PASSWORD
done
"${JAVA_HOME}"/bin/java -jar replace-1.0.jar -o "</tomcat-users>" -n "<role rolename=\"monitoring\"/><role rolename=\"manager\"/><role rolename=\"manager-gui\"/><role rolename=\"admin\"/><role rolename=\"admin-script\"/><role rolename=\"admin-gui\"/><user username=\"${CATALINA_USERNAME}\" password=\"\" roles=\"admin,manager,manager-gui,monitoring,admin-script,admin-gui\"/></tomcat-users>" -f "${CATALINA_TOMCAT_USERS_XML}" -p ${CATALINA_PASSWORD}

while [ ${DATABASE_PORT} -eq -1 ] || ! [[ ${DATABASE_PORT} =~ ${PORT_REGEX} ]]
do
    echo -n "[Apache Tomcat Server] Enter database port: "
    read -r DATABASE_PORT
done

while [ -z "${DATABASE_HOSTNAME}" ] || ! [[ ${DATABASE_HOSTNAME} =~ $HOSTNAME_REGEX ]]
do
    echo -n "[Apache Tomcat Server] Enter database host: "
    read -r DATABASE_HOSTNAME
done
"${JAVA_HOME}"/bin/java -jar replace-1.0.jar -o "jdbc:mysql://localhost:3308" -n "jdbc:mysql://${DATABASE_HOSTNAME}:${DATABASE_PORT}" -f "${CATALINA_CONTEXT_XML}"

while [ -z "${DATABASE_USERNAME}" ] || ! [[ ${DATABASE_USERNAME} =~ ${USERNAME_REGEX} ]]
do
  echo -n "[Apache Tomcat Server] Enter database username: "
  read -r DATABASE_USERNAME
done
"${JAVA_HOME}"/bin/java -jar replace-1.0.jar -f -o "username=\"root\"" -n "username=\"${DATABASE_USERNAME}\"" -f "${CATALINA_CONTEXT_XML}"

while [ -z "${DATABASE_PASSWORD}" ]
do
    echo -n "[Apache Tomcat Server] Enter database password: "
    read -r DATABASE_PASSWORD
done
"${JAVA_HOME}"/bin/java -jar replace-1.0.jar -f "${CATALINA_CONTEXT_XML}" -p ${DATABASE_PASSWORD}

echo "Tomcat version ${TOMCAT_VERSION} configured"