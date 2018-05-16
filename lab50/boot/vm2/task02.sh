#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##

# @ 2a
sudo apt-get install -y  openssh-server
echo "instal·lació programari a servidor $nom_maquina: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 

# @ 2b
sed -i /PermitRoot/s/prohibit-password/no/  /etc/ssh/sshd_config
echo "modificació dels fitxers de configuració: /etc/openssh-server i fail2ban $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##

# @2a 2h
sudo systemctl restart ssh.service 
echo "reiniciar servei ssh.service: $?" | tee -a  /vagrant/log/$LOG

##
## altres
## 

# @ 2c 2d 2e
# crear nou compte administratiu 
sudo useradd -m -s /bin/bash nimda
sudo usermod --password $(echo admin | openssl passwd -1 -stdin) nimda
sudo usermod -a -G sudo nimda

# generar nou certificat ssh pel compte administratiu

# atés que no se pot copiar a les altres màquines pq no estan activades se copiarà a fora
#### sudo su -l nimda -c "echo admin | tee password.txt && sshpass -f password.txt ssh-copy-id nimda@10.10.10.2 && rm password.txt"
#### sudo su -l nimda -c "echo admin | tee password.txt && sshpass -f password.txt ssh-copy-id nimda@10.10.10.3 && rm password.txt"

# @ 2g
sudo su -l nimda -c cat /vagrant/vm1/conf/id_rsa.pub | tee -a ~/.ssh/authorized_keys 


