#!/usr/bin/env bash

## fitxer de configuració inicial: realitza update i crea el fitxer de log 

nom_maquina=$(hostname)
LOG=$nom_maquina.log

## preparació del servidor
sudo apt update
echo "iniciant mv" | tee   /vagrant/log/$LOG
sudo apt install bash-completion
source /etc/bash_completion
