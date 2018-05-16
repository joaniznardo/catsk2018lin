#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log

## preparació del servidor
##sudo apt update
##echo "iniciant mv" | tee   /vagrant/log/$LOG

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



## preparació del resolver: /etc/resolv.conf


## està fet ja --- sudo apt update
## echo "actualitzat apt: $?" | tee -a  /vagrant/log/$LOG

sudo apt install -y systemd
echo "actualitzat systemd: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl disable NetworkManager
echo "deshabilitat NetworkManager: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl disable network
echo "deshabilitat network: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl enable systemd-networkd
echo "habilitant networkd: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm1/resolved.conf /etc/systemd
echo "copiant config resolved: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl enable systemd-resolved
echo "habilitant systemd-resolvd" | tee -a  /vagrant/log/$LOG

sudo systemctl start systemd-resolved
echo "inicialitzant systemd-resolvd: $?" | tee -a  /vagrant/log/$LOG

sudo mv /etc/resolv.conf{,.old}
echo "backup antic resolv.conf: $?" | tee -a  /vagrant/log/$LOG

sudo cp {/etc,/vagrant/log}/resolv.conf.old
echo "copy out resolv.conf:  $?" | tee -a  /vagrant/log/$LOG

sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "establint nou resolv.conf: $?" | tee -a  /vagrant/log/$LOG



