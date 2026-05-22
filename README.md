Gestione Porto
Progetto web sviluppato con Django per la gestione di un sistema portuale.

L’applicazione permette di gestire diverse informazioni legate al porto, come clienti, navi, banchine, magazzini, container, merci, guide, itinerari, prenotazioni e operazioni di stoccaggio.

---

Requisiti
Per eseguire il progetto sulla propria macchina sono necessari:

Python 3
pip
Git
MySQL Server
MySQL Client
Pycharm o un altro editor
Un terminale, ad esempio PowerShell, Prompt dei comandi, terminale Linux oppure WSL

---

1. Clonare la repository
Aprire il terminale nella cartella in cui si vuole scaricare il progetto ed eseguire:
git clone https://github.com/MarcoSettembre/gestione_porto.git
Entrare nella cartella del progetto:
cd gestione_porto

3. Creare un ambiente virtuale

È consigliato usare un ambiente virtuale per installare le librerie del progetto senza modificarle a livello globale nel computer.

Windows
python -m venv venv
venv\Scripts\activate

macOS / Linux / WSL
python3 -m venv venv
source venv/bin/activate

Quando l’ambiente virtuale è attivo, nel terminale dovrebbe comparire:
(venv)
