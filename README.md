# PUNTATA
GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV - PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA

# COME NASCE
Questo piccolo progetto, un unico semplice batch per Windows, nasce nel 2015, quando avevo la necessità di ricordare quale l'ultima puntata di una SerieTV avevo visto, a fronte di directory di file offline presi in download dai miei Provider di Servizi Streaming, sempre più affollate e numerose.

# PERCHE' NASCE
Principalmente perchè ero frustrato dal dover ricordare a mente o scrivermi quale fosse l'ultima puntata di una SerieTV che stavo seguendo OFFLINE 😉😉😉col rischio di rimanere minuti e minuti per trovare il punto dove fossi arrivato!!! 🙄 Le SerieTV ormai imperversano e fanno parte della nostra quotidianità, con qualità sempre maggiore sia a livello di sceneggiature che di tecnologie. Ma, volendo lavorare con file OFFLINE, quindi non direttamente sui Portali dei principali Servizi Streaming, che già adottano questa tecnica per memorizzare l'ultima puntata visionata, mi chiedevo PERCHE' non farlo anche su file OFFLINE senza scervellarsi o sprecare post-it e tempo 😂😂😂 ?

# COSA FA
Il batch elenca le puntate di una SerieTV presenti in una determinata directory, e permette all'utente, tramite un menu interattivo, di selezionare quale puntata visionare. A fronte della scelta, la puntata viene memorizzata come "vista" e al prossimo run l'utente avrà a video, come reminder, quale sia stata l'ultima puntata che ha visto.

# LETTORI MULTIMEDIALI
L'untete ha anche la possibilità di selezionare quale Lettore Multimediale utilizzare per visionare i file video. Per default lo script cerca VLC nei path standard, ed utilizza questo lettore come primario. Il submenu dedicato ai lettori permette all'utente di customizzare il proprio lettore multimediale preferito. Anche il lettore, quando selezionato, verrà memorizzato in un file temporaneo ed utilizzato nel run dello script, su stessa directory o altra directory. La scelta del lettore è dunque globale.

# UTILIZZO E CONDIVISIONE
L'utilizzo dello script è completamente libero. L'utente ha facoltà di condividere lo stesso con qualsiasi altro utente.
Qualsiasi utente ha anche facoltà di aggiungere/rimuovere/ottimizzare/perfezionare/migliorare qualsiasi parte dello script.
Chiedo solamente rimanga il banner originale e che non venga omesso il mio nickname da display.

```
*****************************************************************************
*           GESTIONE DELL'ULTIMA PUNTATA DI UNA SERIE TV                    *
*       PERMETTE ALL'UTENTE DI MEMORIZZARE L'ULTIMA PUNTATA VISTA           *
*                      2.4 BY VerbaL 2015-2025                              *
*****************************************************************************
```

Grazie.

# FILESYSTEM
Il batch utilizza,
* il batch stesso per la memorizzazione dei dati immessi dall'utente
* il file ```C:\Users\<UTENTE>\{PUNTATA}.player``` per memorizzare a livello utente il lettore multimediale selezionato

Non viene utilizzato nessun altro file/path Windows, nè quantomeno il registro.

# RUN
A fronte di una directory

```"E:\!!!.@N0W@TCHiNG.!!!\@SERIETV"```

che presenta questi contenuti,

```
SERIETV S01 1x01 - Titolo Episodio 01.mkv
SERIETV S01 1x02 - Titolo Episodio 02.mkv
SERIETV S01 1x03 - Titolo Episodio 03.mkv
SERIETV S01 1x04 - Titolo Episodio 04.mkv
SERIETV S01 1x05 - Titolo Episodio 05.mkv
SERIETV S01 1x06 - Titolo Episodio 06.mkv
```

Copiare il file batch al suo interno e lanciare il batch. Il batch è programmato per gestire i principali tipi di file multimediali (avi,mkv,mp4).

All'utente verrà proposto un display con i contenuti rilevati ed un menu interattivo con cui agire,

<b>PRIMA LISTA A DISPLAY</b><br>
![immagine](https://github.com/user-attachments/assets/f1afd671-2326-4906-a0dd-48511adb4d94)<br>

<b>SELEZIONE DI UNA PUNTATA</b><br>
![immagine](https://github.com/user-attachments/assets/91670300-b91b-4514-9f60-760704679c37)<br>

<b>SUCCESSIVA LISTA A DISPLAY</b><br>
![immagine](https://github.com/user-attachments/assets/fa489ea1-d84c-4c00-861d-7efb33abcbc5)<br>

A questo punto, la puntata è memorizzata, e al prossimo run l'utente avrà il reminder di quale l'ultima puntata che ha visionato.

Buona visione e buon divertimento.
