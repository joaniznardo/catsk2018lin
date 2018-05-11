#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament


nom_maquina=$(hostname)
LOG=$nom_maquina.log

## preparació del servidor
#sudo apt update
#echo "iniciant mv" | tee   /vagrant/log/$LOG



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

sudo cp /vagrant/conf/vm5/resolved.conf /etc/systemd
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


## preparar la vm5 (xarxa2) per poder arribar a la vm2 i vm3 (xarxa1)
## suposem que només hi ha 3 interfícies 1) lo 2) eth0/enp0s3 i 3) eth1/enp0s8 
lastnic=$(ip -4 -o a | tail -1 | awk '{print $2}')
sudo route add -net 192.168.48.0 netmask 255.255.255.0 dev $lastnic
