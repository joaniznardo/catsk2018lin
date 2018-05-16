#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log

## preparació del servidor
#sudo apt update
#echo "iniciant mv" | tee   /vagrant/log/$LOG

##
## instal·lació de programari
##  

sudo apt install -y apache2
echo "instal·lant apache: $?" | tee -a  /vagrant/log/$LOG

sudo apt install -y vsftpd
echo "instal·lant vsftpd: $?" | tee -a  /vagrant/log/$LOG

sudo apt-get install -y bind9 bind9utils bind9-doc
echo "instal·lació programari servidor: $?" | tee -a  /vagrant/log/$LOG

##
## copia de fitxers de configuració
##

# vsftpd

sudo cp /vagrant/conf/vm2/vsftpd.conf /etc/vsftpd.conf
echo "copiant config a /etc/vsftpd.conf: $?" | tee -a  /vagrant/log/$LOG

# - bind

sudo cp /vagrant/conf/vm2/bind9.service /etc/systemd/system/bind9.service
echo "ampliació a ipv4 del servei: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/named.conf.options /etc/bind/named.conf.options 
echo "configuració de les opcions generals del bind: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/named.conf.local /etc/bind/named.conf.local 
echo "especificació de la zona: $?" | tee -a  /vagrant/log/$LOG

sudo mkdir /etc/bind/zones
echo "creació del directori on hi seran les zones: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/db* /etc/bind/zones
echo "copiant els fitxers de zones: $?" | tee -a  /vagrant/log/$LOG


##
## reinici de serveis
##

# apache

sudo systemctl restart apache2.service
echo "reiniciant apache: $?" | tee -a  /vagrant/log/$LOG

# vsftp

sudo systemctl restart vsftpd.service 
echo "reiniciant  vsftpd: $?" | tee -a  /vagrant/log/$LOG

# bind

sudo systemctl daemon-reload
echo "reiniciar servei bind 1/2: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart bind9
echo "reiniciar servei bind 2/2: $?" | tee -a  /vagrant/log/$LOG

sudo service bind9 status
echo "comprovació estat: $?" | tee -a  /vagrant/log/$LOG


## preparació del resolver: /etc/resolv.conf




sudo apt install -y systemd
echo "actualitzat systemd: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl disable NetworkManager
echo "deshabilitat NetworkManager: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl disable network
echo "deshabilitat network: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl enable systemd-networkd
echo "habilitant networkd: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm2/resolved.conf /etc/systemd
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

##############

sudo apt-get install -y bind9 bind9utils bind9-doc
echo "instal·lació programari servidor: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm1/bind9.service /etc/systemd/system/bind9.service
echo "ampliació a ipv4 del servei: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl daemon-reload
echo "reiniciar servei bind 1/2: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart bind9
echo "reiniciar servei bind 2/2: $?" | tee -a  /vagrant/log/$LOG

sudo service bind9 status
echo "comprovació estat: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm1/named.conf.options /etc/bind/named.conf.options 
echo "configuració de les opcions generals del bind: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm1/named.conf.local /etc/bind/named.conf.local 
echo "configuració del la part específica del servei de fail-over: $?" | tee -a  /vagrant/log/$LOG

## zones? (se crea el directori on de manera automàtica se generaran les zones)
sudo mkdir /etc/bind/zones
echo "creació del directori on hi seran les zones: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm1/db* /etc/bind/zones
echo "copiant els fitxers de zones: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart bind9
echo "reiniciem servei... amb l'esperança que se repliquen les zones: $?" | tee -a  /vagrant/log/$LOG


## preparació del resolver: /etc/resolv.conf


sudo apt update
echo "actualitzat apt: $?" | tee -a  /vagrant/log/$LOG

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

## preparar la mv per fer de router entre les dues xarxes
sudo cp /vagrant/conf/vm1/sysctl.conf /etc/sysctl.conf
sudo sysctl -p


