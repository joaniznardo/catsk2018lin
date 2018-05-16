#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##
sudo apt-get install -y bind9 bind9utils bind9-doc
echo "instal·lació programari servidor: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 
sudo cp /vagrant/conf/vm2/bind9.service /etc/systemd/system/bind9.service
echo "ampliació a ipv4 del servei: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/named.conf.options /etc/bind/named.conf.options 
echo "configuració de les opcions generals del bind: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/named.conf.local /etc/bind/named.conf.local 
echo "configuració del la part específica del servei de fail-over: $?" | tee -a  /vagrant/log/$LOG

## zones? (se crea el directori on de manera automàtica se generaran les zones)
sudo mkdir /etc/bind/zones
echo "creació del directori on hi seran les zones: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/db* /etc/bind/zones
echo "copiant els fitxers de zones: $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##

sudo systemctl daemon-reload
echo "reiniciar servei bind 1/2: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart bind9
echo "reiniciar servei bind 2/2: $?" | tee -a  /vagrant/log/$LOG

