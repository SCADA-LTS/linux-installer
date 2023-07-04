
![Scada-LTS logo](https://yt3.ggpht.com/2V_jz6rC-_z3Ir1SL5_TctnE5HAbq_rWbF0PHSfRy3VXdwowrP2XEfTpAcr_VH1TUbzsWjUVWTs=w2120-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj)
# Installer Scada-LTS for linux
| Technology | Version | Description |
| :--- | :---: | --- |
| Java | 11.0.19+7 | Base programic language |
| Server MySQL CE | 8.0.33 | Database server for data persistence |
| Shell MySQL | 8.0.33 | Database client |
| Apache Tomcat | 9.0.76 | Application server |
| Ubuntu/Mint | >=18 | System |

## Instruction 
The installer requires an internet connection. The first run will take longer due to the need to download and install MySQL 8.0 CE database server, MySQL 8.0 shell and JDK 11.

1. Download and unzip to linux-installer-1.x.x dir: [linux-installer-1.2.0.zip](https://github.com/SCADA-LTS/linux-installer/releases/download/v1.2.0/linux-installer-1.2.0.zip)
2. Start MySQL server:
````
./mysql_start.sh
````
3. After started MySQL server, then start Tomcat with Scada-LTS:
````
./tomcat_start.sh
````
4. If there is a problem with permissions, run the following command:
````
chmod +x linux-installer-1.x.x/**/*.sh
chmod +x linux-installer-1.x.x/*.sh
````
