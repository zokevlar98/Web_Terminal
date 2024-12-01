#!/bin/bash

set -e

# Mise à jour du système
echo "Mise à jour du système..."
sudo apt update -y
sudo apt upgrade -y

# Installation des dépendances nécessaires
echo "Installation des dépendances..."
sudo apt install -y python3 python3-pip python3-venv curl

# Création de l'environnement virtuel pour WebSSH
echo "Création de l'environnement virtuel Python..."
mkdir -p /home/$(whoami)/webssh-env
python3 -m venv /home/$(whoami)/webssh-env

# Activation de l'environnement virtuel
echo "Activation de l'environnement virtuel..."
source /home/$(whoami)/webssh-env/bin/activate

# Installation de WebSSH
echo "Installation de WebSSH..."
pip install webssh

# Vérification de l'installation de WebSSH
if ! command -v wssh &> /dev/null
then
    echo "Erreur : WebSSH n'est pas installé correctement."
    exit 1
fi

# Exécution de WebSSH en arrière-plan
echo "Exécution de WebSSH en arrière-plan..."
nohup /home/$(whoami)/webssh-env/bin/wssh &

# Affichage du message de succès
echo "WebSSH est maintenant installé et en cours d'exécution. Accédez-y via http://127.0.0.1:8888"