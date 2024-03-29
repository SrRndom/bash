#!/bin/bash
#
#
while :
  do
    clear
    echo "Por favor, seleccione la opcion deseada:"
    echo "  1. Instalar todo"
    echo "  2. Actualizacion de Sistema"
    echo "  3. Instalacion MySQL y JDK"
    echo "  4. Instalacion Base de datos"
    echo "  5. Configuracion Recicladora"
    echo "  6. instalacion Reglas USB"
    echo "  7. Reiniciar"
    echo "  8. Salir "
    read option

    case $option in
      1) 
    echo *Por favor espere. Instalando
	echo *Dependendencias a instalar
	echo -OpenJDK/OpenJRE8
	echo -Python3
	echo -MySQL
	echo Analizando sistema && uname --a && sleep 2
	echo Analisis completo && echo Fecha inicio: &&  date && sleep 2
	echo Actualizacion iniciada
	#ACTUALIZACION DE SISTEMA
	sudo apt-get update -y
	sudo apt-get upgrade -y
	echo ACTUALIZACION DE SISTEMA FINALIZADA
	#INSTALACION DE PAQUETES
	echo INSTALACION DE PAQUETES INICIADA
	REQUIRED_PKG="openjdk-11-jdk"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install openjdk-11-jdk --yes  $REQUIRED_PKG
	fi
	
	REQUIRED_PKG="python3 idle3"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install python3 idle3 --yes  $REQUIRED_PKG
	fi

	REQUIRED_PKG="mariadb-server"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install mariadb-server --yes  $REQUIRED_PKG
	fi
	echo Instalacion finalizada, por favor espere && sleep 5
	#CONFIGURACION SQL
	echo Inicializando configuracion SQL && sleep 3
	rm -r config.properties 2> /dev/null
	ID1=Reciclador$RANDOM
	ID2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*_+|:?=' | fold -w 16 | grep -i '[!@#$%^&*_+|:?=]' | head -n 1)
	   sudo mysql -u root -e "CREATE USER '$ID1'@'localhost' IDENTIFIED BY '$ID2';"
	   sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO '$ID1'@'localhost';"
	   sudo mysql -u root -e "CREATE DATABASE reciclador_local;"
	   sudo mysql -u root reciclador_local < reciclador_local.sql
			read -p "Ingrese URL: " URL
			echo jdbc.url = $URL >> config.properties
			echo jdbc.driver = com.mysql.cj.jdbc.Driver >> config.properties
			echo jdbc.username = $ID1 >> config.properties
			echo jdbc.password = $ID2 >> config.properties
			rm -r /etc/config.properties 2> /dev/null
			sudo mv config.properties /etc
		read -p "INGRESE URL DE CONEXION A LA WEB: " WEB

		sudo mysql -u root -e "use reciclador_local; UPDATE configuraciones SET valor = '$WEB' WHERE id_configuracion = 3;"
			

     echo "VERIFIQUE DATOS POR SEGURIDAD" && sleep 3
	#CONFIGURACION RECICLADORA
	echo CONFIGURACION AGREGAR RECICLADORA
    echo LEA CON CUIDADO LAS INSTRUCCIONES DE NO HACERLO PUEDE GENERAR UNA CONFIGURACION INCORRECTA
	echo A CONTINUACION  SE LE SOLICITARAN CIERTOS DATOS PARA PODER CONFIGURAR SU RECICLADOR
	echo "Contraseña" Aqui deberas ingresar la contraseña para el reciclador donde estas configurando
	echo "Ubicacion" Aqui deberas Ingresar la ubicacion de la recicladora para agilizar su ubicacion
	echo "Nombre" Aqui deberas asignarle un nombre a la recicladora en cuestion
	echo En caso de requerir un espacio usa un guion bajo _ [SOLO APLICA EN LOS CAMPOS UBICACION Y NOMBRE]
 	echo EN CASO DE COMETER UN ERROR PULSE CONTROL+C PARA CANCELAR
	sleep 3s
	read -p "Contrasena: " var_1
	read -p "Ubicacion: " var_2
	read -p "Nombre_Reciclador: " var_3
	java -jar AgenteAgregar.jar agregar $var_1 $var_2 $var_3
	history -c     
	
	  #INSTALACION REGLAS USB
	echo INSTALACION DE CONFIGURACION ESP32 MEDIANTE REGLAS DEL SISTEMA
	echo POR FAVOR ESPERE ESTO SOLO TOMARA UNOS SEGUNDOS && sleep 5s
	rm -r 10-usb-serial.rules 2> /dev/null
	echo "#CONFIGURACION PUERTOS USB" >> 10-usb-serial.rules
	echo "#ESP32 MAESTRO" >> 10-usb-serial.rules
	echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_MAESTRO", ATTRS{product}=="REC_MAESTRO", SYMLINK+="ttyUSB_MAESTRO" >> 10-usb-serial.rules
	echo "#ESP32 SERVOS" >> 10-usb-serial.rules
	echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_SERVOS", ATTRS{product}=="REC_SERVOS", SYMLINK+="ttyUSB_SERVOS" >> 10-usb-serial.rules
	echo "#ESP32 LEDS"  >> 10-usb-serial.rules
	echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_LEDS", ATTRS{product}=="REC_LEDS", SYMLINK+="ttyUSB_LEDS" >> 10-usb-serial.rules
	echo "#ESP32 ULTRASONICOS" >> 10-usb-serial.rules
	echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_ULTRASONICOS", ATTRS{product}=="REC_ULTRASONICOS", SYMLINK+="ttyUSB_ULTRAS" >> 10-usb-serial.rules
	echo "#ESP32 ERRORES"  >> 10-usb-serial.rules
	echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_ERRORES", ATTRS{product}=="REC_ERRORES", SYMLINK+="ttyUSB_ERRORES"  >> 10-usb-serial.rules
	rm -r /etc/udev/rules.d/10-usb-serial.rules 2> /dev/null
	sudo mv 10-usb-serial.rules /etc/udev/rules.d/
		
        echo "Presione Enter para regresar al menu" ; read;;
      2) 
        echo *Por favor espere. Instalando
	echo Analizando sistema && uname --a && sleep 3
	echo Analisis completo && echo Fecha inicio: &&  date && sleep 5
	echo Actualizacion iniciada
	sudo apt-get update -y
	sudo apt-get upgrade -y
	echo ACTUALIZACION DE SISTEMA FINALIZADA
        echo "Presione Enter para regresar al menu" ; read;;
      3) 
    echo *Dependendencias a instalar
	echo -OpenJDK/OpenJRE
	echo -Python3
	echo -MySQL
	echo INSTALACION DE PAQUETES INICIADA
	REQUIRED_PKG="openjdk-11-jdk"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install openjdk-11-jdk --yes  $REQUIRED_PKG
	fi
	
	REQUIRED_PKG="python3 idle3"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install python3 idle3 --yes  $REQUIRED_PKG
	fi

	REQUIRED_PKG="mariadb-server"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install mariadb-server --yes  $REQUIRED_PKG
	fi

	echo Instalacion finalizada, por favor espere && sleep 5
        echo "Presione Enter para regresar al menu" ; read;;
	  4)
	#COMANDOS SQL
	rm -r config.properties 2> /dev/null
	ID1=Reciclador$RANDOM
	ID2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*_+|:?=' | fold -w 16 | grep -i '[!@#$%^&*_+|:?=]' | head -n 1)
	   sudo mysql -u root -e "CREATE USER '$ID1'@'localhost' IDENTIFIED BY '$ID2';"
	   sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO '$ID1'@'localhost';"
	   sudo mysql -u root -e "CREATE DATABASE reciclador_local;"
	   sudo mysql -u root reciclador_local < reciclador_local.sql
			read -p "Ingrese URL: " URL
			echo jdbc.url = $URL >> config.properties
			echo jdbc.driver = com.mysql.cj.jdbc.Driver >> config.properties
			echo jdbc.username = $ID1 >> config.properties
			echo jdbc.password = $ID2 >> config.properties
			rm -r /etc/config.properties 2> /dev/null
			sudo mv config.properties /etc
		read -p "INGRESE URL DE CONEXION A LA WEB: " WEB

		sudo mysql -u root -e "use reciclador_local; UPDATE configuraciones SET valor = '$WEB' WHERE id_configuracion = 3;"
	

		echo "Presione Enter para regresar al menu" ; read;;
      5)
	echo CONFIGURACION AGREGAR RECICLADORA
        echo LEA CON CUIDADO LAS INSTRUCCIONES DE NO HACERLO PUEDE GENERAR UNA CONFIGURACION INCORRECTA
	echo A CONTINUACION  SE LE SOLICITARAN CIERTOS DATOS PARA PODER CONFIGURAR SU RECICLADOR
	echo "Contraseña" Aqui deberas ingresar la contraseña para el reciclador donde estas configurando
	echo "Ubicacion" Aqui deberas Ingresar la ubicacion de la recicladora para agilizar su ubicacion
	echo "Nombre" Aqui deberas asignarle un nombre a la recicladora en cuestion
	echo En caso de requerir un espacio usa un guion bajo _ [SOLO APLICA EN LOS CAMPOS UBICACION Y NOMBRE]
 	echo EN CASO DE COMETER UN ERROR PULSE CONTROL+C PARA CANCELAR
	sleep 3s
	read -p "Contrasena: " var_1
	read -p "Ubicacion: " var_2
	read -p "Nombre_Reciclador: " var_3
	java -jar AgenteAgregar.jar agregar $var_1 $var_2 $var_3
	history -c     
        echo "Presione Enter para continuar" ; read;;
      6)
	  #INSTALACION REGLAS USB
		echo INSTALACION DE CONFIGURACION ESP32 MEDIANTE REGLAS DEL SISTEMA
		echo POR FAVOR ESPERE ESTO SOLO TOMARA UNOS SEGUNDOS && sleep 5s
		rm -r 10-usb-serial.rules 2> /dev/null
		echo "#CONFIGURACION PUERTOS USB" >> 10-usb-serial.rules
		echo "#ESP32 MAESTRO" >> 10-usb-serial.rules
		echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_MAESTRO", ATTRS{product}=="REC_MAESTRO", SYMLINK+="ttyUSB_MAESTRO" >> 10-usb-serial.rules
		echo "#ESP32 SERVOS" >> 10-usb-serial.rules
		echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_SERVOS", ATTRS{product}=="REC_SERVOS", SYMLINK+="ttyUSB_SERVOS" >> 10-usb-serial.rules
		echo "#ESP32 LEDS"  >> 10-usb-serial.rules
		echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_LEDS", ATTRS{product}=="REC_LEDS", SYMLINK+="ttyUSB_LEDS" >> 10-usb-serial.rules
		echo "#ESP32 ULTRASONICOS" >> 10-usb-serial.rules
		echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_ULTRASONICOS", ATTRS{product}=="REC_ULTRASONICOS", SYMLINK+="ttyUSB_ULTRAS" >> 10-usb-serial.rules
		echo "#ESP32 ERRORES"  >> 10-usb-serial.rules
		echo SUBSYSTEM=="tty", ATTRS{serial}=="ESP_ERRORES", ATTRS{product}=="REC_ERRORES", SYMLINK+="ttyUSB_ERRORES"  >> 10-usb-serial.rules
		rm -r /etc/udev/rules.d/10-usb-serial.rules 2> /dev/null
		sudo mv 10-usb-serial.rules /etc/udev/rules.d/
		
		echo "Presione Enter para continuar" ; read;;
	  7)

	sudo reboot ; read;;
      8) echo "Programa Finalizado" ; exit 0 ;;
      *) echo "Ingrese una opcion valida por favor." ;
      echo "Press enter for next iteration!" ; read;;
    esac
  done