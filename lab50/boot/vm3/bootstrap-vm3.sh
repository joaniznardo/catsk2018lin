#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log

##
##  instal·lació programari
##

sudo apt-get install -y bind9 bind9utils bind9-doc ngnix
echo "instal·lació programari servidor: $?" | tee -a  /vagrant/log/$LOG


##
## configuració
##

sudo cp /vagrant/conf/vm3/bind9.service /etc/systemd/system/bind9.service
echo "ampliació a ipv4 del servei: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm3/named.conf.options /etc/bind/named.conf.options 
echo "configuració de les opcions generals del bind: $?" | tee -a  /vagrant/log/$LOG

sudo cp /vagrant/conf/vm3/named.conf.local /etc/bind/named.conf.local 
echo "configuració del la part específica del servei de fail-over: $?" | tee -a  /vagrant/log/$LOG

## zones? (se crea el directori on de manera automàtica se generaran les zones)
sudo mkdir -m 770 /var/cache/bind/slaves
echo "creació del directori on hi seran les zones: $?" | tee -a  /vagrant/log/$LOG

## zones? (se crea el directori on de manera automàtica se generaran les zones)
sudo chown root:bind /var/cache/bind/slaves
echo "creació del directori on hi seran les zones: $?" | tee -a  /vagrant/log/$LOG

sudo systemctl restart bind9
echo "reiniciem servei... amb l'esperança que se repliquen les zones: $?" | tee -a  /vagrant/log/$LOG


##
## reinici serveis
##

# - dns

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

sudo cp /vagrant/conf/vm3/resolved.conf /etc/systemd
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


## preparar la vm3 (xarxa1) per poder arribar a la vm4 i vm5 (xarxa2)
## suposem que només hi ha 3 interfícies 1) lo 2) eth0/enp0s3 i 3) eth1/enp0s8 
## lastnic=$(ip -4 -o a | tail -1 | awk '{print $2}')
## sudo route add -net 192.168.49.0 netmask 255.255.255.0 dev $lastnic
