#!/bin/bash
#
#
while :
  do
    clear
	#MENU DE SELECCION PERMITE ELEGIR SI SE DESEA HACER TODO EL PROCESO EN UNA SOLA EXHIBICION O BIEN PARTE POR PARTE
	#HECHO ASI, PARA QUE EN CASO DE EXISTIR UN ERROR EL USUARIO PUEDA REINICIAR DESDE EL MOMENTO DONDE EXISTIO EL MISMO
    echo "Por favor, seleccione la opcion deseada:"
    echo "  1. Instalar todo"
    echo "  2. Actualizacion de Sistema"
    echo "  3. Instalacion MySQL y JDK"
    echo "  4. Instalacion Base de datos"
    echo "  5. Configuracion Recicladora"
    echo "  6. Reiniciar"
    echo "  7. Salir"
    read option

    case $option in
	#OPCION 1 INSTALACION DEL SISTEMA SIN INTERRUPCIONES Y CON MINIMA INTERACCION CON EL USUARIO
	#SE MENCIONA LOS PROGRAMAS QUE SERAN INSTALADOS, ANALIZARA LA VERSION DEL KERNEL LINUX Y EL SISTEMA INSTALADO
	#AL FINALIZAR EL ANALISIS IMPRIMIRA LA FECHA DE INICIO Y SE CONTINUARA CON LA ACTUALIZACION E INSTALACION DE PAQUETES
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
	#EN ESTE SECTOR SE VERIFICARA EL ESTATUS DE LAS ACTUALIZACIONES EN EL SISTEMA OPERATIVO
	#DE SER NECESARIAS EN ESTE PASO INSTALARAN LAS QUE SEAN NECESARIAS
	sudo apt-get update -y
	sudo apt-get upgrade -y
	echo ACTUALIZACION DE SISTEMA FINALIZADA
	#INSTALACION DE PAQUETES
	#EN ESTE SECTOR ANALIZA SI LOS PAQUETES NECESARIOS YA ESTAN INSTALADOS, EN EL CASO DE YA EXISTIR
	#IMPRIMIRA UN MENSAJE CONFIRMANDO LA EXISTENCIA DEL PAQUETE, EN CASO CONTRARIO DE QUE NO EXISTA
	#SE COMANZARA LA DESCARGARA E INSTALACION EL PAQUETE REQUERIDO PARA PODER CONTINUAR
	echo INSTALACION DE PAQUETES INICIADA
	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA OPENJDK 11
	REQUIRED_PKG="openjdk-11-jdk"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install openjdk-11-jdk --yes  $REQUIRED_PKG
	fi
	
	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA PYTHON3 Y IDLE3 SI ES REQUERIDO
	REQUIRED_PKG="python3 idle3"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install python3 idle3 --yes  $REQUIRED_PKG
	fi

	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA MARIADB SERVER
	REQUIRED_PKG="mariadb-server"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install mariadb-server --yes  $REQUIRED_PKG
	fi
	
	echo Instalacion finalizada, por favor espere && sleep 5
	#CONFIGURACION SQL
	#EN ESTE SECTOR SE DA INICIO A LA CONFIGURACION DE LA BASE DE DATOS(SQL) QUE SERA UTILIZADO PARA EL SISTEMA 
	echo Inicializando configuracion SQL && sleep 3
	#SE VERIFICA SI EXISTE EL ARCHIVO config.properties EN CASO DE EXISTIR ESTE SERA ELIMINADO DEFINIVAMENTE
	rm -r config.properties 2> /dev/null
	#"ID1" ASIGNA EL NOMBRE DE RECICLADOR CON UNA SERIE DE NUMEROS ALEATORIOS
	ID1=Reciclador$RANDOM
	#"ID2" GENERA LA CONTRASENA DE MANERA COMPLETAMENTE ALEATORIA PARA UNA MEJOR SEGURIDAD INCLUYENDO LETRAS, CARACTERES Y NUMEROS
	ID2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*_+|:?=' | fold -w 16 | grep -i '[!@#$%^&*_+|:?=]' | head -n 1)
		#GENERA LA CREACION DEL USUARIO Y LLAMANDO A LA VARIABLE "ID1" Y "ID2" PARA EL USUARIO Y CONTRASENA RESPECTIVAMENTE
	   sudo mysql -u root -e "CREATE USER '$ID1'@'localhost' IDENTIFIED BY '$ID2';"
	   #OTORGA LOS PERMISOS NECESARIOS AL USUARIO CREADO LLAMANDO A LA VARIABLE "ID1"
	   sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO '$ID1'@'localhost';"
	   #CREA LA BASE DE DATOS BAJO EL NOMBRE DE "reciclador_local"
	   sudo mysql -u root -e "CREATE DATABASE reciclador_local;"
	   #SE IMPORTARA LA BASE DE DATOS "reciclador_local.sql" A LA RECIEN CREADA DENTRO DE NUESTRO SQL
	   sudo mysql -u root reciclador_local < reciclador_local.sql
			#SOLICITARA LA URL DE USO INTERNO PARA EL FUNCIONAMIENTO DE LA MAQUINA
			read -p "Ingrese URL: " URL
			#INDICA LA URL LLAMANDO A LA VARIABLE URL PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.url = $URL >> config.properties
			#INDICA EL DRIVER UTILIZADO PARA PODER SER UTILIZADO EN LA CONFIGURACION PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.driver = com.mysql.cj.jdbc.Driver >> config.properties
			#LLAMA LA VARIABLE ID1 PARA INDICARLE EL USUARIO QUE UTILIZA LA BASE DE DATOS PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.username = $ID1 >> config.properties
			#LLAMA LA VARIABLE ID2 PARA INDICARLE LA CONTRASENA SEGURA QUE UTILIZA LA BASE DE DATOS PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.password = $ID2 >> config.properties
			#VERIFICA SI EL ARCHIVO "config.properties" NO EXISTE EN /etc, EN CASO DE EXISTIR ES ELIMINADO
			rm -r /etc/config.properties 2> /dev/null
			#MUEVE EL RECIEN CREADO "config.properties" A /etc PARA SER APROVECHADO MAS ADELANTE
			sudo mv config.properties /etc
		#SOLICITARA LA URL A DONDE HARA CONEXIONES EL SISTEMA	
		read -p "INGRESE URL DE CONEXION A LA WEB: " WEB
		#GENERARA UN UPDATE(ACTUALIZACION) DENTRO DE LA BASE DE DATOS "reciclador_local" USANDO LA VARIABLE "WEB" PARA INSERTAR LA URL PREVIAMENTE INGRESADA Y HACER LOS CAMBIOS NECESARIOS
		sudo mysql -u root -e "use reciclador_local; UPDATE configuraciones SET valor = '$WEB' WHERE id_configuracion = 3;"
		
			
	 #SE RECOMIENDA VERIFICAR LOS DATOS EN CASO DE SER NECESARIO
     echo "VERIFIQUE DATOS POR SEGURIDAD" && sleep 3

	#CONFIGURACION RECICLADORA
	#INSTRUCCIONES DEDICADAS PARA EVITAR ERRORES
	echo CONFIGURACION AGREGAR RECICLADORA
    echo LEA CON CUIDADO LAS INSTRUCCIONES DE NO HACERLO PUEDE GENERAR UNA CONFIGURACION INCORRECTA
	echo A CONTINUACION  SE LE SOLICITARAN CIERTOS DATOS PARA PODER CONFIGURAR SU RECICLADOR
	echo "Contraseña" Aqui deberas ingresar la contraseña para el reciclador donde estas configurando
	echo "Ubicacion" Aqui deberas Ingresar la ubicacion de la recicladora para agilizar su ubicacion
	echo "Nombre" Aqui deberas asignarle un nombre a la recicladora en cuestion
	echo En caso de requerir un espacio usa un guion bajo _ [SOLO APLICA EN LOS CAMPOS UBICACION Y NOMBRE]
 	echo EN CASO DE COMETER UN ERROR PULSE CONTROL+C PARA CANCELAR
	
	sleep 3s
	#VARIABLE EXCLUSIVA PARA LA CONTRASENA
	read -p "Contrasena: " var_1
	#VARIABLE EXCLUSIVA PARA LA UBICACION
	read -p "Ubicacion: " var_2
	#VARIABLE EXCLUSIVA PARA EL NOMBRE DE LA MAQUINA
	read -p "Nombre_Reciclador: " var_3
	#COMANDO JAVA QUE SE EJECUTARA EN CONJUNTO DE LAS VARIABLES PARA PODER REALIZAR EL REGISTRO DE LA MAQUINA
	java -jar AgenteAgregar.jar agregar $var_1 $var_2 $var_3
	
	#COMANDO PARA ELIMINAR EL HISTORIAL DE COMANDOS Y NO DEJAR RESIDUOS INECESARIOS
	history -c
	
	
		#FUNCION BASICA PARA VOLVER AL MENU PRINCIPAL
        echo "Presione Enter para regresar al menu" ; read;;
		
		
      2)
	#OPCION 2 ACTUALIZACION DEL SISTEMA SIN INTERACCION DEL USUARIO
	#SE MENCIONA LOS PROGRAMAS QUE SERAN INSTALADOS, ANALIZARA LA VERSION DEL KERNEL LINUX Y EL SISTEMA INSTALADO
	#AL FINALIZAR EL ANALISIS IMPRIMIRA LA FECHA DE INICIO Y SE CONTINUARA CON LA ACTUALIZACION E INSTALACION DE PAQUETES
    echo *Por favor espere. Instalando
	echo Analizando sistema && uname --a && sleep 3
	echo Analisis completo && echo Fecha inicio: &&  date && sleep 5
	echo Actualizacion iniciada
	#ACTUALIZACION DE SISTEMA
	#EN ESTE SECTOR SE VERIFICARA EL ESTATUS DE LAS ACTUALIZACIONES EN EL SISTEMA OPERATIVO
	#DE SER NECESARIAS EN ESTE PASO INSTALARAN LAS QUE SEAN NECESARIAS
	sudo apt-get update -y
	sudo apt-get upgrade -y
	echo ACTUALIZACION DE SISTEMA FINALIZADA
		#FUNCION BASICA PARA VOLVER AL MENU PRINCIPAL
        echo "Presione Enter para regresar al menu" ; read;;
      3) 
	#OPCION 3 INSTALACION DE PAQUETES
	#EN ESTE SECTOR ANALIZA SI LOS PAQUETES NECESARIOS YA ESTAN INSTALADOS, EN EL CASO DE YA EXISTIR
	#IMPRIMIRA UN MENSAJE CONFIRMANDO LA EXISTENCIA DEL PAQUETE, EN CASO CONTRARIO DE QUE NO EXISTA
	#SE COMENZARA LA DESCARGARA E INSTALACION EL PAQUETE REQUERIDO PARA PODER CONTINUAR
    echo *Dependendencias a instalar
	echo -OpenJDK/OpenJRE
	echo -Python3
	echo -MySQL
	echo INSTALACION DE PAQUETES INICIADA
	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA OPENJDK 11
	REQUIRED_PKG="openjdk-11-jdk"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install openjdk-11-jdk --yes  $REQUIRED_PKG
	fi
	
	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA PYTHON Y IDLE3
	REQUIRED_PKG="python3 idle3"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install python3 idle3 --yes  $REQUIRED_PKG
	fi

	#INSTALACION DE LOS PAQUETES REQUERIDOS PARA mariadb-server
	REQUIRED_PKG="mariadb-server"
	PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
	echo Checking for $REQUIRED_PKG: $PKG_OK
	if [ "" = "$PKG_OK" ]; then
	echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
	sudo apt install mariadb-server --yes  $REQUIRED_PKG
	fi

	echo Instalacion finalizada, por favor espere && sleep 5
		#FUNCION BASICA PARA VOLVER AL MENU PRINCIPAL
        echo "Presione Enter para regresar al menu" ; read;;
	  4)
	#OPCION 4CONFIGURACION SQL
	#EN ESTE SECTOR SE DA INICIO A LA CONFIGURACION DE LA BASE DE DATOS(SQL) QUE SERA UTILIZADO PARA EL SISTEMA 
echo Inicializando configuracion SQL && sleep 3
	#SE VERIFICA SI EXISTE EL ARCHIVO config.properties EN CASO DE EXISTIR ESTE SERA ELIMINADO DEFINIVAMENTE
	rm -r config.properties 2> /dev/null
	#"ID1" ASIGNA EL NOMBRE DE RECICLADOR CON UNA SERIE DE NUMEROS ALEATORIOS
	ID1=Reciclador$RANDOM
	#"ID2" GENERA LA CONTRASENA DE MANERA COMPLETAMENTE ALEATORIA PARA UNA MEJOR SEGURIDAD INCLUYENDO LETRAS, CARACTERES Y NUMEROS
	ID2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*_+|:?=' | fold -w 16 | grep -i '[!@#$%^&*_+|:?=]' | head -n 1)
		#GENERA LA CREACION DEL USUARIO Y LLAMANDO A LA VARIABLE "ID1" Y "ID2" PARA EL USUARIO Y CONTRASENA RESPECTIVAMENTE
	   sudo mysql -u root -e "CREATE USER '$ID1'@'localhost' IDENTIFIED BY '$ID2';"
	   #OTORGA LOS PERMISOS NECESARIOS AL USUARIO CREADO LLAMANDO A LA VARIABLE "ID1"
	   sudo mysql -u root -e "GRANT ALL PRIVILEGES ON * . * TO '$ID1'@'localhost';"
	   #CREA LA BASE DE DATOS BAJO EL NOMBRE DE "reciclador_local"
	   sudo mysql -u root -e "CREATE DATABASE reciclador_local;"
	   #SE IMPORTARA LA BASE DE DATOS "reciclador_local.sql" A LA RECIEN CREADA DENTRO DE NUESTRO SQL
	   sudo mysql -u root reciclador_local < reciclador_local.sql
			#SOLICITARA LA URL DE USO INTERNO PARA EL FUNCIONAMIENTO DE LA MAQUINA
			read -p "Ingrese URL: " URL
			#INDICA LA URL LLAMANDO A LA VARIABLE URL PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.url = $URL >> config.properties
			#INDICA EL DRIVER UTILIZADO PARA PODER SER UTILIZADO EN LA CONFIGURACION PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.driver = com.mysql.cj.jdbc.Driver >> config.properties
			#LLAMA LA VARIABLE ID1 PARA INDICARLE EL USUARIO QUE UTILIZA LA BASE DE DATOS PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.username = $ID1 >> config.properties
			#LLAMA LA VARIABLE ID2 PARA INDICARLE LA CONTRASENA SEGURA QUE UTILIZA LA BASE DE DATOS PARA SER ESCRITA EL ARCHIVO "config.properties"
			echo jdbc.password = $ID2 >> config.properties
			#VERIFICA SI EL ARCHIVO "config.properties" NO EXISTE EN /etc, EN CASO DE EXISTIR ES ELIMINADO
			rm -r /etc/config.properties 2> /dev/null
			#MUEVE EL RECIEN CREADO "config.properties" A /etc PARA SER APROVECHADO MAS ADELANTE
			sudo mv config.properties /etc
		#SOLICITARA LA URL A DONDE HARA CONEXIONES EL SISTEMA	
		read -p "INGRESE URL DE CONEXION A LA WEB: " WEB
		#GENERARA UN UPDATE(ACTUALIZACION) DENTRO DE LA BASE DE DATOS "reciclador_local" USANDO LA VARIABLE "WEB" PARA INSERTAR LA URL PREVIAMENTE INGRESADA Y HACER LOS CAMBIOS NECESARIOS
		sudo mysql -u root -e "use reciclador_local; UPDATE configuraciones SET valor = '$WEB' WHERE id_configuracion = 3;"
	
		#FUNCION BASICA PARA VOLVER AL MENU PRINCIPAL
		echo "Presione Enter para regresar al menu" ; read;;
      5)
	#CONFIGURACION RECICLADORA
	#INSTRUCCIONES DEDICADAS PARA EVITAR ERRORES
	echo CONFIGURACION AGREGAR RECICLADORA
    echo LEA CON CUIDADO LAS INSTRUCCIONES DE NO HACERLO PUEDE GENERAR UNA CONFIGURACION INCORRECTA
	echo A CONTINUACION  SE LE SOLICITARAN CIERTOS DATOS PARA PODER CONFIGURAR SU RECICLADOR
	echo "Contraseña" Aqui deberas ingresar la contraseña para el reciclador donde estas configurando
	echo "Ubicacion" Aqui deberas Ingresar la ubicacion de la recicladora para agilizar su ubicacion
	echo "Nombre" Aqui deberas asignarle un nombre a la recicladora en cuestion
	echo En caso de requerir un espacio usa un guion bajo _ [SOLO APLICA EN LOS CAMPOS UBICACION Y NOMBRE]
 	echo EN CASO DE COMETER UN ERROR PULSE CONTROL+C PARA CANCELAR
	
	sleep 3s
	#VARIABLE EXCLUSIVA PARA LA CONTRASENA
	read -p "Contrasena: " var_1
	#VARIABLE EXCLUSIVA PARA LA UBICACION
	read -p "Ubicacion: " var_2
	#VARIABLE EXCLUSIVA PARA EL NOMBRE DE LA MAQUINA
	read -p "Nombre_Reciclador: " var_3
	#COMANDO JAVA QUE SE EJECUTARA EN CONJUNTO DE LAS VARIABLES PARA PODER REALIZAR EL REGISTRO DE LA MAQUINA
	java -jar AgenteAgregar.jar agregar $var_1 $var_2 $var_3
	
	#COMANDO PARA ELIMINAR EL HISTORIAL DE COMANDOS Y NO DEJAR RESIDUOS INECESARIOS
	history -c 
		#FUNCION BASICA PARA VOLVER AL MENU PRINCIPAL
        echo "Presione Enter para continuar" ; read;;
      6)

	sudo reboot ; read;;
      7) echo "Programa Finalizado" ; exit 0 ;;
		#EN CASO DE USAR UNA OPCION NO EXISTENTE DARA EL SIGUIENTE ERROR
      *) echo "Ingrese una opcion valida por favor." ;
	  #VARIABLE PARA LA REUTILIZACION EN OPCIONES GENERALES
      echo "Press enter for next iteration!" ; read;;
    esac
  done