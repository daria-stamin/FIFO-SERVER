# creaza un client unic FIFO
CLIENT_FIFO="/tmp/server-reply-$PID"
if [[ -p $CLIENT_FIFO ]]; then
  rm -f "$CLIENT_FIFO"        #sterge FIFO-ul clientului daca exista deja
fi

mkfifo "$CLIENT_FIFO"

# asigura stergerea cererii clientului
trap 'rm -f "$CLIENT_FIFO"' EXIT

# trimite cererea serverului
echo "BEGIN-REQ [$PID: $COMMAND] END-REQ" > "$WELL_KNOWN_FIFO"
echo "Waiting for response from the server..."

# citeste  si afiseaza raspunsul serverului

if cat "$CLIENT_FIFO"; then
  echo "Response received."
else
  echo "Error: Failed to read response from server."
fi
