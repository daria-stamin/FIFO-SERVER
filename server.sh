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

while true; do
  if read -r request < "$WELL_KNOWN_FIFO"; then
    echo "Received request: $request"
    PID=$(echo "$request" | grep -oP '(?<=BEGIN-REQ \[)\d+(?=:)')
    COMMAND=$(echo "$request" | grep -oP '(?<=: ).*(?=\] END-REQ)')

    if [[ -n $PID && -n $COMMAND ]]; then
      CLIENT_FIFO="/tmp/server-reply-$PID"
      
      if [[ ! -p $CLIENT_FIFO ]]; then
        mkfifo "$CLIENT_FIFO"
      fi

      # trimite raspunsul in subshell ca sa evite blocarea
      (
        timeout 10 man "$COMMAND" > "$CLIENT_FIFO" 2>/dev/null || echo "Command '$COMMAND' not found." > "$CLIENT_FIFO"
        echo "Response sent to $CLIENT_FIFO for command '$COMMAND'."
        rm -f "$CLIENT_FIFO"
      ) &
    else
      echo "Invalid request format: $request"
    fi
  fi
done

