
![Scada-LTS logo](https://yt3.ggpht.com/2V_jz6rC-_z3Ir1SL5_TctnE5HAbq_rWbF0PHSfRy3VXdwowrP2XEfTpAcr_VH1TUbzsWjUVWTs=w2120-fcrop64=1,00005a57ffffa5a8-k-c0xffffffff-no-nd-rj)
# Installer Scada-LTS for linux
| Technology | Version | Description |
| :--- | :---: | --- |
| Java | 11.0.22+7 | Base programic language |
| Server MySQL CE | 8.0.36 | Database server for data persistence |
| Shell MySQL | 8.0.36 | Database client |
| Apache Tomcat | 9.0.86 | Application server |
| Ubuntu/Mint | >=18 | System |

## Instruction 
The installer requires an internet connection. The first run will take longer due to the need to download and install MySQL 8.0 CE database server, MySQL 8.0 shell and JDK 11.

1. Go to https://github.com/SCADA-LTS/linux-installer and select [releases](https://github.com/SCADA-LTS/linux-installer/releases) tab and then download latest release to desired folder.

2. Go to location of downloaded installer and extract it.

3. Start first script by using terminal and typing `./mysql_start.sh` inside extracted folder.  

    Script will ask for some basic information to make configuration run correctly. Below is an example of the data that can be entered:  
   * Port: 3306  
   * Username: root  
   * Password: root  
   * Root password: root  

   After providing the information you should wait for the line confirming the correct setup of the database:  
   `~/linux-installer-1.2.0/mysql/server/bin/mysqld: ready for connections. Version: '8.0.x'  socket: '/tmp/mysql.sock'  port: 3306  MySQL Community Server - GPL.`

4. Start second terminal in the same folder and run `./tomcat_start.sh` script.

    Similar to first script you will have to provide some information, example below:
    * Enter port: 8080
    * Enter username: tcuser
    * Enter password: tcuser
    * Enter database port: 3306
    * Enter database host: localhost
    * Enter database username: root
    * Enter database password: root

    After that you should be able to access Scada-LTS via web browser by typing in search bar `localhost:8080/Scada-LTS`
5. If there is a problem with permissions, run the following command:
````
chmod +x Scada-LTS_vx.x.x.x_Installer_vx.x.x_Setup/**/*.sh
chmod +x Scada-LTS_vx.x.x.x_Installer_vx.x.x_Setup/*.sh
````

6. After restarting the system, we execute these two scripts similarly, in this order, first we start the installed database:
````
./mysql_start.sh
````
in the next step, we start the tomcat server:
````
./tomcat_start.sh
````
