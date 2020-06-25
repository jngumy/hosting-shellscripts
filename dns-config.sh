#!/bin/bash

##agrego zona al archivo /etc/bind/named.conf.local

dominio=$1
dominio=${dominio:4}
#echo $dominio
echo -e " zone  \"$dominio\" {
  type master;
  file \"db.$dominio\";
};" >> /etc/bind/named.conf.local




####creo el archivo de zona en /var/cache/bind

echo -e  "

; BIND zone file  $dominio



\$TTL 7D
@			IN SOA	server1.$dominio. admin.$dominio. (
				3          ; serial
				604800          ; refresh
				86400          ; retry
				2419299          ;expire
				10800         ; negative cache ttl
				)
			NS server1 ; servidor de nombre autoritativo

server1 	A	192.168.1.10
@		A	192.168.1.10
router 		A	192.168.1.1
www 		A	192.168.1.10
gateway 	CNAME 	router
gw		CNAME router"  > /var/cache/bind/db.$dominio


##creo el archivo inverso en /var/cache/bind
echo -e "

; BIND reverse data file for $dominio

\$TTL	7D
@	IN	SOA	server1.$dominio. admin.$dominio. (
				3          ; serial
				604800          ; refresh
				86400          ; retry
				2419299          ;expire
				10800         ; negative cache ttl

				)
IN 	NS	server1
;Hosts
10	IN	PTR	server1"  > /var/cache/bind/db.$dominio-reverso 

systemctl restart bind9

