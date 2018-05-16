#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##
sudo apt-get install -y xxxxxxxxxxxxx
echo "instal·lació programari a servidor $nom_maquina: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 
sudo cp /vagrant/conf/vm1/haproxy.cfg /etc/haproxy/
echo "còpia dels fitxers de configuració: /etc/xxxxxxx  $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##
sudo systemctl restart xxxxxx.service
echo "reiniciar servei xxxxxxx: $?" | tee -a  /vagrant/log/$LOG


