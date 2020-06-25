#!/bin/bash


	usuario=$1
	read -s -p "Ingrese un password para su usuario Debian:" password
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
	useradd -m -p "$pass" "$usuario"
	[ $? -eq 0 ] && echo -e "\nUsuario agregado al sistema\n" || echo -e "\nError al agregar un usuario\n"



mkdir /home/$usuario/public_html
ln -s /home/$usuario/public_html "$usuario"-public

read -p "Ingrese el dominio del virtualhost: " dominio
path=/etc/apache2/sites-available
cd /etc/apache2/sites-available
touch "$dominio".conf
echo "<VirtualHost *:80>" >> "$path"/"$dominio".conf
echo "ServerName $dominio" >> "$path"/"$dominio".conf
echo "ServerAdmin webmaster@localhost" >> "$path"/"$dominio".conf
echo "DocumentRoot /home/$usuario/public_html" >> "$path"/"$dominio".conf
echo "ErrorLog /var/log/apache2/$usuario-error.log" >> "$path"/"$dominio".conf
echo "CustomLog /var/log/apache2/$usuario.log combined" >> "$path"/"$dominio".conf
echo "<Directory /home/$usuario/public_html/>" >> "$path"/"$dominio".conf
echo "AllowOverride none" >> "$path"/"$dominio".conf
echo "Require all granted" >> "$path"/"$dominio".conf
echo "</Directory>" >> "$path"/"$dominio".conf
echo "</VirtualHost>" >> "$path"/"$dominio".conf

a2ensite "$dominio".conf
systemctl restart apache2

echo "Usuario Debian: $usuario" >>  /root/archivos-conf-hosting/$usuario.txt
echo "Password Debian : $password" >> /root/archivos-conf-hosting/$usuario.txt
echo -e "\n==============================\n" >> /root/archivos-conf-hosting/$usuario.txt
echo "Parametros Servidor Web Apache2" >> /root/archivos-conf-hosting/$usuario.txt
echo "Dominio virtual host de apache2: $dominio" >> /root/archivos-conf-hosting/$usuario.txt
echo "Archivo de log apache2: /var/log/apache2/$usuario-error.log" >> /root/archivos-conf-hosting/$usuario.txt
echo "Archivo de custom log apache2: /var/log/apache2/$usuario.log" >> /root/archivos-conf-hosting/$usuario.txt
echo -e "\n==============================\n" >> /root/archivos-conf-hosting/$usuario.txt

bash /root/scripts/dns-config.sh $dominio
