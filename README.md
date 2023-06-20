
![Scada-LTS logo](https://yt3.ggpht.com/2V_jz6rC-_z3Ir1SL5_TctnE5HAbq_rWbF0PHSfRy3VXdwowrP2XEfTpAcr_VH1TUbzsWjUVWTs=w2120-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj)
# Installer Scada-LTS for linux
| Technology | Version | Description |
| :--- | :---: | --- |
| Java | 11.0.19+7 | Base programic language |
| Server MySQL CE | 8.0.33 | Database server for data persistence |
| Shell MySQL | 8.0.33 | Database client |
| Apache Tomcat | 9.0.75 | Application server |

## Instruction 
The installer requires an internet connection. The first run will take longer due to the need to download and install MySQL 8.0 CE database server, MySQL 8.0 shell and JDK 11.

1. Download and unzip to linux-installer-1.x.x dir: [linux-installer-1.1.1.zip](https://github.com/SCADA-LTS/linux-installer/releases/download/v1.1.1/linux-installer-1.1.1.zip)
2. You may need to set execute permissions, in linux-installer-1.0.0 execute:
````
chmod +x mysql_start.sh
chmod +x tomcat_start.sh
chmod +x tomcat64/bin/catalina.sh
chmod +x mysql/mysql_install.sh
chmod +x java/java_install.sh
````
3. Start MySQL server:
````
./mysql_start.sh
````
4. Start Tomcat with Scada-LTS:
````
./tomcat_start.sh
````
