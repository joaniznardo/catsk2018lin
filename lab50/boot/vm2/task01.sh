#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##
i# @1e
sudo apt install -y net-tools dnsutils wget curl
echo "instal·lació programari a servidor $nom_maquina: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 
# @ 1a
sudo cp /vagrant/conf/vm1/sysctl.conf /etc
echo "còpia dels fitxers de configuració: /etc/sysctl.conf  $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##

# @ 1a
sudo sysctl -p 
echo "reiniciar el fitxer de configuració del nucli: som un router: $?" | tee -a  /vagrant/log/$LOG

##
## alta comptes
## 

# @ 1b 1c 1d
sudo usermod --password $(echo toor | openssl passwd -1 -stdin) root
sudo useradd -m -s /bin/bash user
sudo usermod --password $(echo cat39 | openssl passwd -1 -stdin) user
