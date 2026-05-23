# Gestione Porto

Progetto web sviluppato con **Django** per la gestione di un sistema portuale.

L’applicazione permette di gestire diverse informazioni legate al porto, come clienti, navi, banchine, magazzini, container, merci, guide, itinerari, prenotazioni e operazioni di stoccaggio.

---

## Requisiti

Per eseguire il progetto sulla propria macchina sono necessari:

- Python 3
- pip
- Git
- MySQL Server
- MySQL Client
- Pycharm o un altro editor
- Un terminale, ad esempio PowerShell, Prompt dei comandi, terminale Linux oppure WSL

---

## 1. Clonare la repository

Aprire il terminale nella cartella in cui si vuole scaricare il progetto ed eseguire:

```bash
git clone https://github.com/MarcoSettembre/gestione_porto.git
```

Entrare nella cartella del progetto:

```bash
cd gestione_porto
```

---

## 2. Creare un ambiente virtuale

È consigliato usare un ambiente virtuale per installare le librerie del progetto senza modificarle a livello globale nel computer.

### Windows

```bash
python -m venv venv
venv\Scripts\activate
```

### macOS / Linux / WSL

```bash
python3 -m venv venv
source venv/bin/activate
```

Quando l’ambiente virtuale è attivo, nel terminale dovrebbe comparire:

```bash
(venv)
```

---

## 3. Installare le dipendenze

Eseguire sul terminale il comando:

```bash
pip install -r requirements.txt
```

---

## 4. Configurare MySQL

Il progetto usa un database MySQL chiamato:

```txt
porto
```

Nel file `porto/settings.py` il database deve essere configurato in questo modo:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'porto',
        'USER': 'django',
        'PASSWORD': 'Django123-',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}
```

---

## 5. Creare il database e l’utente MySQL

Accedere a MySQL come amministratore:

```bash
mysql -u root -p
```

Poi eseguire questi comandi:

```sql
CREATE DATABASE porto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER 'django'@'localhost' IDENTIFIED BY 'Django123-';

GRANT ALL PRIVILEGES ON porto.* TO 'django'@'localhost';

FLUSH PRIVILEGES;
```

Uscire da MySQL:

```sql
EXIT;
```

---

## 6. Importare il dump del database

Nella repository è presente il file:

```txt
porto_dump.sql
```

Questo file contiene la struttura e i dati del database.

Per importarlo, dalla cartella principale del progetto eseguire:

```bash
mysql -u django -p porto < porto_dump.sql
```

Quando viene richiesta la password, inserire:

```txt
Django123-
```

Se l’importazione va a buon fine, il database `porto` conterrà tutte le tabelle necessarie al funzionamento del sito.

---

## 7. Verificare che il dump sia stato importato correttamente

Entrare in MySQL:

```bash
mysql -u django -p
```

Selezionare il database:

```sql
USE porto;
```

Mostrare le tabelle:

```sql
SHOW TABLES;
```

Dovrebbero comparire tabelle come:

```txt
Banchina
Cliente
Container
Guida
Itinerario
Magazzino
Merce
Nave
Prenotazione
Stanza
Stoccaggio
Tappe_itinerario
```

Oltre alle tabelle di Django, come:

```txt
auth_user
auth_group
django_migrations
django_session
django_admin_log
django_content_type
```

Per uscire:

```sql
EXIT;
```

---

## 8. Possibile problema con il DEFINER dei trigger

In alcuni casi, durante l’importazione del dump, MySQL potrebbe dare un errore legato a questa parte:

```sql
DEFINER=`root`@`localhost`
```

Questo può succedere se sulla macchina in cui si importa il database l’utente `root@localhost` non esiste o non ha i permessi corretti.

In quel caso, si può aprire `porto_dump.sql` con Visual Studio Code e rimuovere tutte le occorrenze di:

```sql
/*!50017 DEFINER=`root`@`localhost`*/
```

Dopo aver salvato il file, ripetere l’importazione:

```bash
mysql -u django -p porto < porto_dump.sql
```

---

## 9. Applicare le migrazioni Django

Dopo aver importato il database, eseguire:

```bash
python manage.py makemigrations
python manage.py migrate
```

Questi comandi servono ad aggiornare eventuali tabelle gestite da Django.

---

## 10. Creare un superutente

Per accedere al pannello di amministrazione di Django, creare un superutente:

```bash
python manage.py createsuperuser
```

Verranno richiesti username, email e password.

---

## 11. Avviare il server locale

Per avviare il progetto:

```bash
python manage.py runserver
```

Se tutto è configurato correttamente, il sito sarà disponibile all’indirizzo:

```txt
http://127.0.0.1:8000/
```

Il pannello admin sarà disponibile all’indirizzo:

```txt
http://127.0.0.1:8000/admin/
```


