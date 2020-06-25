    #!/bin/bash
    archivo_usuario=$1
    #Ask user to enter database name and save input to dbname variable
    read -p "Ingrese el nombre de la base de datos:" dbname

    #ask user about username
    read -p "Ingrese el nombre de usuario de la base de datos: " username

    #ask user about allowed hostname
    read -p "Ingrese el nombre del host Por ejemplo: %,ip o hostname : " host

    #ask user about password
    read -p "Ingrese la clave del nuevo usuario ($username) : " password

    #mysql query that will create new user, grant privileges on database with entered password
    query="CREATE DATABASE IF NOT EXISTS $dbname; GRANT ALL PRIVILEGES ON $dbname.* TO $username@$host IDENTIFIED BY '$password'";

    #ask user to confirm all entered data
    read -p "Ejecutar la query? : $query , Confirmar (y/n) : " confirm

    #if user confims then
    if [ "$confirm" == 'y' ]; then

     	mysql -uroot -p  <<EOF
CREATE DATABASE \`${dbname}\`;
CREATE USER $username@$host IDENTIFIED BY '$password';
GRANT ALL PRIVILEGES ON \`${dbname}\`.* TO \`${username}\`@'localhost';
EOF

	#guardo configuracion en el archivo
    
 
	echo "Parametros Servidor Base de datos MySQL: " >> /root/archivos-conf-hosting/$archivo_usuario.txt
	echo "Usuario: $username" >> /root/archivos-conf-hosting/$archivo_usuario.txt
	echo "Password: $password" >> /root/archivos-conf-hosting/$archivo_usuario.txt
	echo "Host: $host" >> /root/archivos-conf-hosting/$archivo_usuario.txt
	echo "DB Name: $dbname" >> /root/archivos-conf-hosting/$archivo_usuario.txt
	echo -e "\n==============================\n" >> /root/archivos-conf-hosting/$archivo_usuario.txt

    else
	    read -p "Abortado, presione una tecla para continuar.."
    fi
