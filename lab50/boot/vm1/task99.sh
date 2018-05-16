#!/usr/bin/env bash

## fitxer de 

nom_maquina=$(hostname)
LOG=$nom_maquina.log

##
## instal·lació programari 
##
sudo apt install -y systemd
echo "actualitzat systemd: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 

## preparació del resolver: /etc/resolv.conf

## important!!!! resolv.conf "harcoded"
sudo cp /vagrant/conf/vm1/resolved.conf /etc/systemd
echo "copiant config resolved: $?" | tee -a  /vagrant/log/$LOG

sudo mv /etc/resolv.conf{,.old}
echo "backup antic resolv.conf: $?" | tee -a  /vagrant/log/$LOG

sudo cp {/etc,/vagrant/log}/resolv.conf.old
echo "copy out resolv.conf:  $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##

sudo systemctl disable NetworkManager
echo "deshabilitat NetworkManager: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl disable network
echo "deshabilitat network: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl enable systemd-networkd
echo "habilitant networkd: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl enable systemd-resolved
echo "habilitant systemd-resolvd" | tee -a  /vagrant/log/$LOG

sudo systemctl start systemd-resolved
echo "inicialitzant systemd-resolvd: $?" | tee -a  /vagrant/log/$LOG

# sols després d'haver desactivat network manager i de activar systemd-networkd associem el nou resolv (que conté el client dns que ens interesa a /etc/resolv.conf.
sudo ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf
echo "establint nou resolv.conf: $?" | tee -a  /vagrant/log/$LOG



