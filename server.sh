CONFIG_FILE="server_config"  #numele fisierului de configurare al serverului
echo "/tmp/well-known-fifo" > "$CONFIG_FILE" #salveaza calea FIFO-ului in fisierul de configurare
WELL_KNOWN_FIFO=$(cat "$CONFIG_FILE") #citeste calea FIFO-ului din fisier si o salveaza intr-o variabila

# creeaza fisierul FIFO daca acesta nu exista
if [[ ! -p $WELL_KNOWN_FIFO ]]; then
  mkfifo "$WELL_KNOWN_FIFO"
fi

echo "Server is running and waiting for requests..."

##sterge FIFO-ul creat anterior
cleanup() {
  echo "Cleaning up FIFOs..." 
  rm -f "$WELL_KNOWN_FIFO"  
  exit
}

trap cleanup INT TERM EXIT
