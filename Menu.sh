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
    echo "  4. Configuracion Recicladora"
    echo "  5. Reiniciar"
    echo "  6. Salir"
    read option

    case $option in
      1) 
    echo *Por favor espere. Instalando
	echo *Dependendencias a instalar
	echo -OpenJDK/OpenJRE8
	echo -Python3
	echo -MySQL
	echo Analizando sistema && uname --a && sleep 3
	echo Analisis completo && echo Fecha inicio: &&  date && sleep 3
	echo Actualizacion iniciada
	sudo apt-get update -y
	sudo apt-get upgrade -y
	echo ACTUALIZACION DE SISTEMA FINALIZADA
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
	echo Inicializando configuracion SQL && sleep 3
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
      5)

	sudo reboot ; read;;
      6) echo "Programa Finalizado" ; exit 0 ;;
      *) echo "Ingrese una opcion valida por favor." ;
      echo "Press enter for next iteration!" ; read;;
    esac
  done