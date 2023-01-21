#!/bin/bash

# Para limpiar:
function clean()
{
    docker stop client_dspwpcv2_examen_container &&
    docker rm client_dspwpcv2_examen_container &&
    docker stop dspwpcv2_examen_container &&
    docker rm dspwpcv2_examen_container
}

docker build -t dspwpcv2_examen .

docker rm dspwpcv2_examen_container
docker rm client_dspwpcv2_examen_container

docker run --name dspwpcv2_examen_container -d -it dspwpcv2_examen

docker exec -it dspwpcv2_examen_container service vsftpd restart

ip_address=$(docker container inspect dspwpcv2_examen_container | grep -i "ipaddress" | tr ' ' '\n'  | tr -d '",' | grep -E "[0-9]+" | sort -u)

sed -i "s/[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/$ip_address/g" admin_client/dockerfile

docker build -t client_dspwpcv2_examen admin_client/.

docker run --name client_dspwpcv2_examen_container -d -it client_dspwpcv2_examen

docker exec -d -it client_dspwpcv2_examen_container ./script.sh

echo "[+] Ip victima: $ip_address"


