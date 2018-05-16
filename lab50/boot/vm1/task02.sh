#!/usr/bin/env bash

## fitxer de configuració de la màquina dsn2 (servidor de noms de recolzament

nom_maquina=$(hostname)
LOG=$nom_maquina.log


##
## instal·lació programari 
##

# @ 2h 2a
sudo apt-get install -y fail2ban openssh-server
echo "instal·lació programari a servidor $nom_maquina: $?" | tee -a  /vagrant/log/$LOG

##
## copia dels fitxers de configuració
## 

# @ 2b
sed -i /PermitRoot/s/prohibit-password/no/  /etc/ssh/sshd_config
# @ 2i
sudo cp /etc/fail2ban/jail.{conf,local}
sudo sed -i /bantime/s/600/180/ /etc/fail2ban/jail.local 
sudo sed -i /findtime/s/600/120/ /etc/fail2ban/jail.local
sudo sed -i /maxretry/s/5/4/ /etc/fail2ban/jail.local
echo "modificació dels fitxers de configuració: /etc/openssh-server i fail2ban $?" | tee -a  /vagrant/log/$LOG

##
## reiniciar serveis
##

# @2a 2h
sudo systemctl restart ssh.service 
echo "reiniciar servei ssh.service: $?" | tee -a  /vagrant/log/$LOG
sudo systemctl restart fail2ban.service 
echo "reiniciar servei fail2ban: $?" | tee -a  /vagrant/log/$LOG

##
## altres
## 

# @ 2c 2d 2e
# crear nou compte administratiu 
sudo useradd -m -s /bin/bash nimda
sudo usermod --password $(echo admin | openssl passwd -1 -stdin) nimda
sudo usermod -a -G sudo nimda

# generar nou certificat ssh pel compte administratiu
# @ 2f
sudo su -l nimda -c 'ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa'

# atés que no se pot copiar a les altres màquines pq no estan activades se copiarà a fora
#### sudo su -l nimda -c "echo admin | tee password.txt && sshpass -f password.txt ssh-copy-id nimda@10.10.10.2 && rm password.txt"
#### sudo su -l nimda -c "echo admin | tee password.txt && sshpass -f password.txt ssh-copy-id nimda@10.10.10.3 && rm password.txt"

# @ 2g
cp ~/.ssh/id_rsa.pub /vagrant/vm1/conf


