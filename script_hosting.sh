#!/bin/bash

read -p "Ingrese un nombre de usuario Debian a crear:" usuario

touch /root/archivos-conf-hosting/$usuario.txt


bash altaUsuario.sh $usuario
bash mysql-db-create.sh $usuario




