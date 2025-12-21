# FIFO-SERVER
Proiect ITBI 

Un sistem client–server în Bash care foloseste FIFO-uri drept canale de comunicare. 

Serverul foloseste un FIFO (first in first out) well-known configutabil, citeste cereri de forma: BEGIN-REQ [client-pid: command-name] END-REQ, 
creeaza FIFO-uri personalizate pentru raspunsuri catre fiecare client.

Raspunsul contine pagina de manual pentru comanda ceruta. Dupa afisare, clientul sterge FIFO-ul personal.
