
======================================================================
File leggimi di LibreOffice 7.5
======================================================================


Per gli ultimi aggiornamenti a questo file leggimi, consulta la pagina https://git.libreoffice.org/core/tree/master/README.md

Questo file contiene informazioni importanti sul programma LibreOffice. Prima di procedere con l'installazione, ti raccomandiamo di leggere molto attentamente queste informazioni.

La comunità di LibreOffice è responsabile dello sviluppo di questo prodotto e ti invita a considerare la tua partecipazione come membro della comunità. Se sei un nuovo utente, puoi visitare il sito di LibreOffice, dove troverai molte informazioni sul progetto LibreOffice e le comunità che vi ruotano intorno. Visita l'indirizzo https://www.libreoffice.org/.

LibreOffice è davvero un prodotto libero per tutti?
----------------------------------------------------------------------

Tutti sono liberi di usare LibreOffice. Puoi installare questa copia di LibreOffice in qualsiasi computer e utilizzarla per qualsiasi scopo desiderato (incluso l'uso in ambito commerciale, governativo, nella pubblica amministrazione e nelle scuole). Per ulteriori dettagli, consulta la licenza contenuta in questa copia di LibreOffice.

Perché LibreOffice è libero per tutti?
----------------------------------------------------------------------

Puoi usare questa copia di LibreOffice senza pagare niente poiché contributori individuali e aziende patrocinanti hanno progettato, sviluppato, provato, tradotto, documentato, supportato, pubblicizzato e aiutato in molti altri modi per rendere LibreOffice ciò che è oggi: il software di produttività open source primo al mondo, per la casa e l'ufficio.

Se apprezzi i loro sforzi, e desideri che LibreOffice continui a essere disponibile negli anni a venire, considera di contribuire al progetto: consulta https://www.documentfoundation.org/contribution/ per i dettagli. Tutti possono contribuire in qualche modo.

----------------------------------------------------------------------
Avvertenze per l'installazione
----------------------------------------------------------------------

Affinché funzioni in modo completo LibreOffice richiede una versione recente dell'ambiente di runtime Java (JRE). JRE non fa parte del pacchetto di installazione di LibreOffice e deve essere installato separatamente.

Requisiti di sistema
----------------------------------------------------------------------

* Microsoft Windows 7 SP1, 8, 8.1 Update (S14) o 10

Per l'installazione è necessario avere diritti di amministratore.

L'impostazione di LibreOffice come applicazione predefinita per i formati di documento Microsoft Office può essere forzata o esclusa utilizzando i seguenti parametri di comando per l'installazione:

* REGISTER_ALL_MSO_TYPES=1 forzerà la registrazione di LibreOffice come applicazione predefinita per i formati Microsoft Office.
* REGISTER_NO_MSO_TYPES=1 disabiliterà la registrazione di LibreOffice come applicazione predefinita per i formati Microsoft Office.

Assicurati che ci sia spazio libero sufficiente nella cartella temporanea del tuo sistema e di avere diritti di lettura, scrittura ed esecuzione. Prima di avviare il processo di installazione chiudi tutti gli altri programmi.

Installazione di LibreOffice su sistemi Linux basati su Debian/Ubuntu
----------------------------------------------------------------------

Per apprendere come installare un pacchetto di lingua (dopo aver installato la versione inglese US di LibreOffice), leggi la sezione sottostante intitolata "Installare un pacchetto di lingua".

Quando decomprimerai l'archivio scaricato, noterai che il contenuto è stato decompresso in una sottocartella. Apri il tuo gestore di file e spostati nella cartella che inizia per "LibreOffice_" seguito dal numero di versione e qualche informazione sulla piattaforma.

Questa cartella contiene una sottocartella chiamata "DEBS". Passa alla cartella "DEBS".

Fai clic col pulsante destro del mouse all'interno della cartella e scegli "Apri in terminale". Si aprirà una finestra di terminale. Dalla riga di comando della finestra, digita il seguente comando (per eseguire il comando, ti sarà chiesto di digitare la tua password di amministrazione):

I comandi seguenti installeranno LibreOffice e i pacchetti di integrazione del desktop (puoi anche solo copiarli e incollarli all'interno della schermata del terminale, piuttosto che scriverli):

sudo dpkg -i *.deb

Il processo di installazione è ora completato, e dovresti avere le icone per tutte le applicazioni di LibreOffice nel menu Applicazioni/Ufficio del tuo desktop.

Installazione di LibreOffice su sistemi Linux Fedora, openSUSE, Mandriva, e altri, che utilizzano pacchetti RPM
----------------------------------------------------------------------

Per apprendere come installare un pacchetto di lingua (dopo aver installato la versione inglese US di LibreOffice), leggi la sezione sottostante intitolata "Installare un pacchetto di lingua".

Quando decomprimerai l'archivio scaricato, noterai che il contenuto è stato decompresso in una sottocartella. Apri il tuo gestore di file e spostati nella cartella che inizia per "LibreOffice_" seguito dal numero di versione e qualche informazione sulla piattaforma.

Questa cartella contiene una sottocartella chiamata "RPMS". Spostati nella cartella "RPMS".

Fai clic col pulsante destro del mouse all'interno della cartella e scegli "Apri in terminale". Si aprirà una finestra di terminale. Dalla riga di comando della finestra, digita il seguente comando (per eseguire il comando, ti sarà chiesto di digitare la tua password di amministrazione):

Per i sistemi basati su Fedora: sudo dnf install *.rpm

Per i sistemi basati su Mandriva: sudo urpmi *.rpm

Per gli altri sistemi basati su RPM (openSUSE, ecc): rpm -Uvh *.rpm

Il processo di installazione è ora completato, e dovresti avere le icone per tutte le applicazioni di LibreOffice nel menu Applicazioni/Ufficio del tuo desktop.

In alternativa, per eseguire un'installazione come utente puoi usare lo script 'install', che si trova nella cartella principale di questo archivio. Lo script imposterà LibreOffice in modo da avere un suo proprio profilo per questa installazione, separato dal tuo normale profilo LibreOffice. Tieni presente che questa operazione non installerà le parti per l'integrazione del sistema, quali gli elementi di menu e le registrazioni dei tipi MIME.

Note relative l'integrazione desktop per le distribuzioni Linux non trattate nelle istruzioni di installazione precedenti
----------------------------------------------------------------------

Dovrebbe essere possibile installare facilmente LibreOffice su altre distribuzioni Linux non specificamente definite in queste istruzioni di installazione. Le principali differenze che si potrebbero riscontrare sono nell'integrazione con il desktop.

La cartella RPMS (o DEBS, rispettivamente) contiene anche un pacchetto chiamato libreoffice7.5-freedesktop-menus-7.5.0.1-1.noarch.rpm (o libreoffice7.5-debian-menus_7.5.0.1-1_all.deb, rispettivamente, o simile). Questo pacchetto vale per tutte le distribuzioni Linux che supportano le specifiche/raccomandazioni Freedesktop.org (https://en.wikipedia.org/wiki/Freedesktop.org), ed è fornito per l'installazione sulle altre distribuzioni Linux non contemplate nelle istruzioni menzionate in precedenza.

Installare un pacchetto di lingua
----------------------------------------------------------------------

Scarica il pacchetto di lingua desiderato per la tua piattaforma. È disponibile nella stessa ubicazione dell'archivio di installazione principale. Dal gestore di file Nautilus, estrai l'archivio scaricato all'interno di una cartella (la tua scrivania, per esempio). Assicurati di aver chiuso tutte le applicazioni di LibreOffice, incluso il QuickStart, se avviato.

Spostati nella cartella in cui hai estratto il pacchetto di lingua scaricato.

Ora spostati nella cartella creata durante il processo di estrazione. Per esempio, per il pacchetto di lingua italiana per un sistema a 32-bit basato su Debian/Ubuntu, la cartella si chiamerà LibreOffice_, più qualche informazione di versione, più Linux_x86_langpack-deb_it.

Ora spostati nella cartella che contiene i pacchetti da installare. Nei sistemi basati su Debian/Ubuntu, la cartella sarà DEBS. Nei sistemi Fedora, openSUSE o Mandriva, essa sarà RPMS.

Dal gestore di file Nautilus, fai clic col pulsante destro del mouse nella cartella e scegli il comando "Apri in terminale". Nella finestra di terminale appena aperta esegui il comando per installare il pacchetto di lingua (potrebbe essere richiesta la password di amministrazione per tutti i comandi seguenti):

Per i sistemi basati su Debian/Ubuntu: sudo dpkg -i *.deb

Per i sistemi basati su Fedora: su -c 'dnf install *.rpm'

Per i sistemi basati su Mandriva: sudo urpmi *.rpm

Per gli altri sistemi che usano RPM (openSUSE, ecc.): rpm -Uvh *.rpm

Ora avvia un'applicazione di LibreOffice - Writer, per esempio. Vai al menu Strumenti e scegli Opzioni. Nella finestra di dialogo delle opzioni, fai clic su "Impostazioni della lingua", poi su "Lingue". Fai clic sull'elenco "Interfaccia utente" e seleziona la lingua appena installata. Puoi fare lo stesso per la "Impostazione locale", la "Valuta predefinita" e le "Lingue predefinite per i documenti".

Dopo aver regolato le impostazioni, premi OK. La finestra si chiuderà e apparirà un messaggio informativo che le modifiche saranno applicate solo dopo aver chiuso e riavviato LibreOffice (ricordati di chiudere anche il QuickStart, se avviato).

Al successivo avvio, LibreOffice apparirà nella lingua appena installata.

----------------------------------------------------------------------
Problemi all'avvio del programma
----------------------------------------------------------------------

Le difficoltà durante l'avvio di LibreOffice (per es., le applicazioni si bloccano), così come i problemi di visualizzazione sullo schermo, sono spesso causati dal driver della scheda grafica. Se tali problemi si verificano, aggiorna il driver della tua scheda grafica o prova a utilizzare quello presente nel tuo sistema operativo.

----------------------------------------------------------------------
Touchpad di notebook ALPS/Synaptics in MS Windows
----------------------------------------------------------------------

A causa di un problema con i driver di MS Windows, non è possibile utilizzare la funzione di scorrimento del touchpad ALPS/Synaptics nei documenti di LibreOffice.

Per abilitare lo scorrimento, aggiungi le seguenti righe al file di configurazione "C:\Programmi\Synaptics\SynTP\SynTPEnh.ini" e riavvia il computer:

[LibreOffice]

FC = "SALFRAME"

SF = 0x10000000

SF |= 0x00004000

La posizione del file di configurazione può variare sui diversi sistemi Windows.

----------------------------------------------------------------------
Tasti di scelta rapida
----------------------------------------------------------------------

In LibreOffice si possono utilizzare i tasti di scelta rapida (combinazioni di tasti) che non siano già usati dal sistema operativo. Nel caso in cui una combinazione di tasti di LibreOffice non funzioni come descritto nella sua guida in linea, verifica che essa non sia già assegnata a qualche comando del sistema operativo. È possibile risolvere questi conflitti modificando i tasti di scelta rapida del sistema operativo. In alternativa puoi cambiare quasi tutte le combinazioni di tasti presenti in LibreOffice. Per ulteriori informazioni su questo argomento, fai riferimento alla guida in linea di LibreOffice o alla documentazione del tuo sistema operativo.

----------------------------------------------------------------------
Problemi durante la spedizione di documenti come e-mail da LibreOffice
----------------------------------------------------------------------

Si possono verificare dei problemi (il programma va in crash o si blocca) inviando un documento da 'File - Invia - Documento come e-mail' o 'Documento come allegato PDF'. La causa è rintracciabile nel file di sistema di MS Windows "Mapi" (Messaging Application Programming Interface) che in alcune versioni non funziona correttamente; purtroppo è impossibile identificare con precisione quali siano queste versioni. Per ulteriori informazioni cerca "mapi dll" nella Microsoft Knowledge Base all'indirizzo https://www.microsoft.com

----------------------------------------------------------------------
Avvertenze importanti per l'accessibilità
----------------------------------------------------------------------

Per ulteriori informazioni sulle caratteristiche di accesso facilitato in LibreOffice, consulta https://it.libreoffice.org/supporto/accessibilita/

----------------------------------------------------------------------
Supporto utenti
----------------------------------------------------------------------

La pagina di supporto principale offre varie soluzioni di assistenza per LibreOffice. Il tuo quesito potrebbe avere già ottenuto risposta: controlla il forum della comunità all'indirizzo http://www.documentfoundation.org/nabble/ o ricerca negli archivi della mailing list 'users@it.libreoffice.org' in http://www.libreoffice.org/lists/users/. In alternativa, puoi inviare i tuoi quesiti a users@libreoffice.org. Se vuoi iscriverti alla lista (per ottenere risposte), invia un messaggio vuoto all'indirizzo: users+subscribe@it.libreoffice.org.

Consulta anche la sezione FAQ nel sito web di LibreOffice.

----------------------------------------------------------------------
Segnalazione di errori e problemi
----------------------------------------------------------------------

Attualmente il nostro sistema di segnalazione, tracciamento e risoluzione degli errori è Bugzilla, ospitato in https://bugs.documentfoundation.org/. Invitiamo tutti gli utenti a segnalare gli errori riscontrati nella loro piattaforma specifica. Un sistema di segnalazioni vivace è uno dei contributi più importanti che la comunità degli utenti può dare per lo sviluppo e il miglioramento futuro di LibreOffice.

----------------------------------------------------------------------
Come collaborare
----------------------------------------------------------------------

La comunità di LibreOffice ha bisogno della tua partecipazione attiva per lo sviluppo di questo importante progetto open source.

In quanto utente, sei già una parte importante del processo di sviluppo della suite, ma desidereremmo avessi un ruolo ancora più attivo, con l'obiettivo di diventare contributore a lungo termine della comunità. Puoi contattarci e unirti a noi alla pagina dei contributi del sito web di LibreOffice.

Come iniziare
----------------------------------------------------------------------

Il modo migliore per iniziare a contribuire al progetto è iscriversi a una o più mailing list, seguire per un po' le discussioni e iniziare a leggere gli archivi per prendere confidenza con i numerosi argomenti trattati dalla prima uscita di LibreOffice nel lontano ottobre 2000. Quando sarai pronto, non ti resta altro da fare che mandare un messaggio di presentazione e buttarti nella mischia! Se hai già collaborato ad altri progetti open source, controlla la lista delle cose da fare (To-Do) e scopri se c'è qualcosa che fa per te nel sito web di LibreOffice.

Iscriviti
----------------------------------------------------------------------

Ecco alcune liste di distribuzione a cui ti puoi iscrivere alla pagina https://it.libreoffice.org/supporto/mailing-list/

* News: announce@documentfoundation.org *raccomandata a tutti gli utenti* (traffico basso)
* Lista utenti principale: users@global.libreoffice.org *metodo semplice per seguire le discussioni* (traffico intenso)
* Progetto marketing: marketing@global.libreoffice.org *oltre lo sviluppo* (traffico in incremento)
* Lista generale per gli sviluppatori: libreoffice@lists.freedesktop.org (traffico intenso)

Unirsi a uno o più progetti
----------------------------------------------------------------------

Anche se non hai grande esperienza di progettazione o programmazione di software, puoi dare un importante contributo a questo importante progetto open source. Come?

Ti auguriamo buon lavoro e buon divertimento con il nuovo LibreOffice 7.5 e speriamo di incontrarti presto online.

La comunità di LibreOffice

----------------------------------------------------------------------
Codice sorgente usato / modificato
----------------------------------------------------------------------

Parti con copyright 1998, 1999 James Clark. Parti con copyright 1996, 1998 Netscape Communications Corporation.
