
<img src="https://github.com/user-attachments/assets/d06d59a1-0162-4b22-993e-8f9a8d5b638c" width=30% height=30%>

# Installer Scada-LTS for linux
| Technology |  Version   | Description |
| :--- |:----------:| --- |
| Java | 17.0.19+10 | Base programic language |
| Server MySQL CE |   8.0.36   | Database server for data persistence |
| Shell MySQL |   8.0.36   | Database client |
| Apache Tomcat |   9.0.86   | Application server |
| Ubuntu/Mint |    >=18    | System |

## Instruction 
The installer requires an internet connection. The first run will take longer due to the need to download and install MySQL 8.0 CE database server, MySQL 8.0 shell and JDK 11.

1. Go to https://github.com/SCADA-LTS/linux-installer and select [releases](https://github.com/SCADA-LTS/linux-installer/releases) tab and then download latest release to desired folder.

2. Go to location of downloaded installer and extract it.

3. Optional: adjust default configuration in `installer.properties` before the first run.
   When the scripts ask `Use default configuration values? [Y/n]` and you answer `Y` or press Enter,
   values from this file will be used. This makes it possible to prepare installer defaults for a
   specific usage without editing shell scripts.

   Available properties:
   * `MYSQL_HOST`
   * `MYSQL_PORT`
   * `MYSQL_DATABASE`
   * `MYSQL_USERNAME`
   * `MYSQL_PASSWORD`
   * `MYSQL_ROOT_PASSWORD`
   * `TOMCAT_PORT`
   * `TOMCAT_USERNAME`
   * `TOMCAT_PASSWORD`
   * `DATABASE_HOST`
   * `DATABASE_PORT`
   * `DATABASE_NAME`
   * `DATABASE_USERNAME`
   * `DATABASE_PASSWORD`

4. Start first script by using terminal and typing `./mysql_start.sh` inside extracted folder.  

    Script will ask for some basic information to make configuration run correctly. Below is an example of the data that can be entered:  
   * Port: 3306  
   * Username: root  
   * Password: root  
   * Root password: root  

   After providing the information you should wait for the line confirming the correct setup of the database:  
   `~/linux-installer-1.2.0/mysql/server/bin/mysqld: ready for connections. Version: '8.0.x'  socket: '/tmp/mysql.sock'  port: 3306  MySQL Community Server - GPL.`

5. Start second terminal in the same folder and run `./tomcat_start.sh` script.

    Similar to first script you will have to provide some information, example below:
    * Enter port: 8080
    * Enter username: tcuser
    * Enter password: tcuser
    * Enter database port: 3306
    * Enter database host: localhost
    * Enter database username: root
    * Enter database password: root

    After that you should be able to access Scada-LTS via web browser by typing in search bar `localhost:8080/Scada-LTS`
6. If there is a problem with permissions:

````
-bash: ./mysql_start.sh: Permission denied
Error: Unable to access jarfile ../replace-1.0.jar
````

Run the following command:

````
chmod +x Scada-LTS_vx.x.x.x_Installer_vx.x.x_Setup/**/*.sh
chmod +x Scada-LTS_vx.x.x.x_Installer_vx.x.x_Setup/*.sh
chmod +x Scada-LTS_vx.x.x.x_Installer_vx.x.x_Setup/**/*.jar
````

7. ❗ If there is MySQL error: `libaio.so.1: cannot open shared object file`

When starting MySQL, the following error may appear:

```text
error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
```

**Cause**

The system is missing the expected libaio.so.1 library.

On newer Linux distributions (especially ARM / aarch64), the library may exist under a different name, e.g.:

```text
libaio.so.1t64
```

**Solution**

Check available libaio libraries

```bash
ldconfig -p | grep libaio
```

Example output:

```text
libaio.so.1t64 (libc6,AArch64) => /lib/aarch64-linux-gnu/libaio.so.1t64
```

Use the path from the previous command and create a symbolic link:
```bash
sudo ln -s /lib/aarch64-linux-gnu/libaio.so.1t64 /lib/aarch64-linux-gnu/libaio.so.1
```

8. After restarting the system, we execute these two scripts similarly, in this order, first we start the installed database:
````
./mysql_start.sh
````
in the next step, we start the tomcat server:
````
./tomcat_start.sh
````
