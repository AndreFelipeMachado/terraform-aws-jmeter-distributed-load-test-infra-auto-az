#!/bin/bash
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/root/install-jmeter.log 2>&1
# Everything below will go to the file '/root/install-jmeter.log'
#https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions


echo    "JMETER_HOME = ${JMETER_HOME}"
echo    "JMETER_VERSION = ${JMETER_VERSION}"
echo    "JMETER_DOWNLOAD_URL = ${JMETER_DOWNLOAD_URL}"
echo    "JMETER_CMDRUNNER_VERSION = ${JMETER_CMDRUNNER_VERSION}"
echo    "JMETER_CMDRUNNER_DOWNLOAD_URL = ${JMETER_CMDRUNNER_DOWNLOAD_URL}"
echo    "JMETER_PLUGINS_MANAGER_VERSION = ${JMETER_PLUGINS_MANAGER_VERSION}"
echo    "JMETER_PLUGINS_MANAGER_DOWNLOAD_URL = ${JMETER_PLUGINS_MANAGER_DOWNLOAD_URL}"
echo    "JMETER_PLUGINS = ${JMETER_PLUGINS}"
echo    "JMETER_MODE = ${JMETER_MODE}"
echo    "JMETER_CONTROLLER_HEAP_SIZE_RAM_PERCENTAGE = ${JMETER_CONTROLLER_HEAP_SIZE_RAM_PERCENTAGE}"
echo    "................"

echo "Installing Java"

# Install Java
yum install java -y

echo "Installing JMeter..."

curl -L --silent ${JMETER_DOWNLOAD_URL} > ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz
tar -xzf ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz -C ${JMETER_HOME}
rm -f ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}.tgz

echo "Installing JMeter plugins..."
# Download CMDRunner plugin
curl -L --silent ${JMETER_CMDRUNNER_DOWNLOAD_URL} > ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/lib/cmdrunner-${JMETER_CMDRUNNER_VERSION}.jar

# Download JMeter Plugins Manager
curl -L --silent ${JMETER_PLUGINS_MANAGER_DOWNLOAD_URL} > ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar

# Installing JMeter Plugins
for i in $(echo ${JMETER_PLUGINS} | tr ',' '\n')
do
java -jar ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/lib/cmdrunner-${JMETER_CMDRUNNER_VERSION}.jar --tool org.jmeterplugins.repository.PluginManagerCMD install $i
done

# Generating Plugin Manager CMD in bin
java -cp ${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/lib/ext/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/bin/PluginsManagerCMD.sh help

STATUS=$?
if [ $STATUS -eq 0 ];then
   echo "JMeter and its plugins installed successfully!"
   echo "PATH=${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/bin:$PATH" >> ${JMETER_HOME}/.bashrc
   source ${JMETER_HOME}/.bashrc
   echo "${JMETER_HOME}/apache-jmeter-${JMETER_VERSION}/bin" + " is added to PATH"
fi

# Leader and follower nodes
if [ "${JMETER_MODE}" = "leader" ]; then
    echo "Configuring JMeter as leader node"
    source ${JMETER_HOME}/.bashrc
    export PRIVATE_IP=$(hostname -I | awk '{print $1}')
    echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment
    echo "JAVA_TOOL_OPTIONS=${JMETER_CONTROLLER_HEAP_SIZE_RAM_PERCENTAGE}" >> /etc/environment
    export JAVA_TOOL_OPTIONS=${JMETER_CONTROLLER_HEAP_SIZE_RAM_PERCENTAGE}
fi

if [ "${JMETER_MODE}" = "follower" ]; then
    echo "Configuring JMeter as follower node"
    source ${JMETER_HOME}/.bashrc
    export PRIVATE_IP=$(hostname -I | awk '{print $1}')
    echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment
    jmeter -s -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$PRIVATE_IP -j /tmp/jmeter-server.log
fi

echo "Finished install."
