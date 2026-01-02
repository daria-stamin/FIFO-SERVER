#!/bin/bash

# Asigura folosirea corecta 
if [[ $# -ne 1 ]]; then              # verifica sa fie un singur argument
  echo "Usage: $0 <command-name>"    
  exit 1
fi

COMMAND=$1
PID=$$                              # PID-ul clientului, creeaza un FIFO unic
CONFIG_FILE="server_config"         # fisierul din care se citeste path-ul serverului

# Se asigura ca exista fisierul FIFO
if [[ ! -f $CONFIG_FILE ]]; then                                 # -f verifica fisierul
  echo "Error: Configuration file '$CONFIG_FILE' not found."     # afiseaza un mesaj in caz de eroare
  exit 1
fi

WELL_KNOWN_FIFO=$(cat "$CONFIG_FILE")

# Verifica daca serverul ruleaza
if [[ ! -p $WELL_KNOWN_FIFO ]]; then                             # -p verifica daca este FIFO
  echo "Error: Server is not running or the FIFO is missing."    # afiseaza un mesaj in caz contrar
  exit 1
fi
