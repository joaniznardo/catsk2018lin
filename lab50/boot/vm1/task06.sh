#!/usr/bin/env bash

## fitxer de configuració 


nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##
sudo apt-get install -y haproxy haproxy-doc
echo "instal·lació programari servidor: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 
sudo cp /vagrant/conf/vm1/haproxy.cfg /etc/haproxy/
echo "còpia dels fitxers de configuració: /etc/haproxy/haproxy.cfg  $?" | tee -a  /vagrant/log/$LOG
sudo cp /vagrant/conf/vm1/rsyslog.conf /etc/
echo "còpia dels fitxers de configuració: /etc/rsyslog.conf  $?" | tee -a  /vagrant/log/$LOG
sudo cp /vagrant/conf/vm1/50-default.conf /etc/rsyslog.d
echo "còpia dels fitxers de configuració: /etc/rsyslog.d/50-default.conf  $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##
sudo systemctl restart haproxy.service
echo "reiniciar servei haproxy: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart rsyslog.service
echo "reiniciar servei rsyslog: $?" | tee -a  /vagrant/log/$LOG

