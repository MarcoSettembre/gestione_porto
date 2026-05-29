# Trigger del database `porto`

Totale trigger: **40**

## 1. `controllo_codice_fiscale_cliente`

| Campo | Valore |
|---|---|
| Tabella | `Cliente` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Impedisce di inserire un cliente con un codice fiscale già appartenente a una guida. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_codice_fiscale_cliente` BEFORE INSERT ON `Cliente`
FOR EACH ROW
BEGIN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Guida) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad una guida";
END IF;
END $$
DELIMITER ;
```

## 2. `controllo_codice_fiscale_cliente2`

| Campo | Valore |
|---|---|
| Tabella | `Cliente` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di modificare il codice fiscale di un cliente usando quello già appartenente a una guida. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_codice_fiscale_cliente2` BEFORE UPDATE ON `Cliente`
FOR EACH ROW
BEGIN
IF NEW.Codice_fiscale <> OLD.Codice_fiscale THEN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Guida) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad una guida";
END IF;
END IF;
END $$
DELIMITER ;
```

## 3. `controllo_peso_e_capacita`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che il container entri nella nave in base a peso e capacità disponibili. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_peso_e_capacita` BEFORE INSERT ON `Container`
FOR EACH ROW
BEGIN
    DECLARE peso_max DOUBLE;
    DECLARE peso_occ DOUBLE;
    DECLARE cap_max INT;
    DECLARE volume_occ INT;

    SELECT Peso_massimo, Peso_occupato, Capacita, Volume_occupato
    INTO peso_max, peso_occ, cap_max, volume_occ
    FROM Nave
    WHERE IMO = NEW.IMO;

    IF peso_occ + NEW.Peso > peso_max OR volume_occ + NEW.Dimensione > cap_max THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il container non entra sulla nave selezionata';
    ELSE
        UPDATE Nave
        SET Peso_occupato = Peso_occupato + NEW.Peso,
            Volume_occupato = Volume_occupato + NEW.Dimensione
        WHERE IMO = NEW.IMO;
    END IF;
END $$
DELIMITER ;
```

## 4. `controllo_tipo_nave_container`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Verifica che i container possano essere inseriti solo su navi di tipo Cargo. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_container` BEFORE INSERT ON `Container`
FOR EACH ROW
BEGIN
DECLARE tipo_nave VARCHAR(10);
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE IMO = NEW.IMO;
IF tipo_nave <> 'Cargo' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non trasporta container';
END IF;
END $$
DELIMITER ;
```

## 5. `aggiornamento_peso_e_capacita`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Aggiorna peso e volume occupati della nave quando viene modificato un container. |

```sql
DELIMITER $$
CREATE TRIGGER `aggiornamento_peso_e_capacita` BEFORE UPDATE ON `Container`
FOR EACH ROW
BEGIN 
DECLARE peso_occ DOUBLE; 
DECLARE peso_max DOUBLE; 
DECLARE volume_occ INT; 
DECLARE capacita INT; 
SELECT Peso_occupato, Peso_massimo, Volume_occupato, Capacita 
INTO peso_occ, peso_max, volume_occ, capacita
FROM Nave
WHERE Nave.IMO = NEW.IMO;
IF OLD.IMO = NEW.IMO THEN
IF peso_occ+NEW.Peso-OLD.Peso>peso_max OR volume_occ+NEW.Dimensione-OLD.Dimensione>capacita THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il container non entra sulla nave selezionata';
ELSE
UPDATE Nave
SET Peso_occupato=Peso_occupato+NEW.Peso-OLD.Peso, Volume_occupato=Volume_occupato+NEW.Dimensione-OLD.Dimensione
WHERE Nave.IMO = NEW.IMO;
END IF;
ELSE
IF peso_occ+NEW.Peso>peso_max OR volume_occ+NEW.Dimensione>capacita THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il container non entra sulla nave selezionata';
ELSE
UPDATE Nave
SET Peso_occupato=Peso_occupato+NEW.Peso, Volume_occupato=Volume_occupato+NEW.Dimensione
WHERE Nave.IMO = NEW.IMO;
UPDATE Nave
SET Peso_occupato=Peso_occupato-OLD.Peso, Volume_occupato=Volume_occupato-OLD.Dimensione
WHERE Nave.IMO = OLD.IMO;
END IF;
END IF;
END $$
DELIMITER ;
```

## 6. `controllo_tipo_nave_container2`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla, in caso di modifica, che il container venga assegnato solo a una nave Cargo. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_container2` BEFORE UPDATE ON `Container`
FOR EACH ROW
BEGIN
DECLARE tipo_nave VARCHAR(10);
IF OLD.IMO <> NEW.IMO THEN
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE IMO = NEW.IMO;
IF tipo_nave <> 'Cargo' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non trasporta container';
END IF;
END IF;
END $$
DELIMITER ;
```

## 7. `liberazione_peso_e_capacita`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `DELETE` |
| Timing | `AFTER` |
| Funzione | Libera peso e volume occupati sulla nave quando viene eliminato un container. |

```sql
DELIMITER $$
CREATE TRIGGER `liberazione_peso_e_capacita` AFTER DELETE ON `Container`
FOR EACH ROW
BEGIN
    UPDATE Nave
    SET Peso_occupato = Peso_occupato - OLD.Peso,
        Volume_occupato = Volume_occupato - OLD.Dimensione
    WHERE IMO = OLD.IMO;
END $$
DELIMITER ;
```

## 8. `elimina_merce_non_stoccata`

| Campo | Valore |
|---|---|
| Tabella | `Container` |
| Evento | `DELETE` |
| Timing | `AFTER` |
| Funzione | Elimina le merci collegate al container cancellato se non risultano stoccate in un magazzino. |

```sql
DELIMITER $$
CREATE TRIGGER `elimina_merce_non_stoccata` AFTER DELETE ON `Container`
FOR EACH ROW
BEGIN
    DELETE Merce
    FROM Merce
    LEFT JOIN Stoccaggio ON Merce.SSCC = Stoccaggio.SSCC
    WHERE Merce.ID_container = OLD.ID
      AND Stoccaggio.Nome_magazzino IS NULL;
END $$
DELIMITER ;
```

## 9. `controllo_itinerario_guida`

| Campo | Valore |
|---|---|
| Tabella | `Guida` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Impedisce di inserire più di 6 guide per lo stesso itinerario. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_itinerario_guida` BEFORE INSERT ON `Guida`
FOR EACH ROW
BEGIN
DECLARE numero_guide INT;
SELECT COUNT(Codice_fiscale)
INTO numero_guide
FROM Guida
WHERE ID_itinerario=NEW.ID_itinerario;
IF numero_guide>=6 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Non si possono inserire piu di 6 guide per itinerario';
END IF;
END $$
DELIMITER ;
```

## 10. `controllo_codice_fiscale_guida`

| Campo | Valore |
|---|---|
| Tabella | `Guida` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Impedisce di inserire una guida con un codice fiscale già appartenente a un cliente. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_codice_fiscale_guida` BEFORE INSERT ON `Guida`
FOR EACH ROW
BEGIN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Cliente) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad un cliente";
END IF;
END $$
DELIMITER ;
```

## 11. `controllo_itinerario_guida2`

| Campo | Valore |
|---|---|
| Tabella | `Guida` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di assegnare una guida a un itinerario che ha già 6 guide. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_itinerario_guida2` BEFORE UPDATE ON `Guida`
FOR EACH ROW
BEGIN
DECLARE numero_guide INT;
IF NOT(OLD.ID_itinerario <=> NEW.ID_itinerario) AND NEW.ID_itinerario IS NOT NULL THEN
SELECT COUNT(Codice_fiscale)
INTO numero_guide
FROM Guida
WHERE ID_itinerario=NEW.ID_itinerario;
IF numero_guide>=6 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Non si possono inserire piu di 6 guide per itinerario';
END IF;
END IF;
END $$
DELIMITER ;
```

## 12. `controllo_codice_fiscale_guida2`

| Campo | Valore |
|---|---|
| Tabella | `Guida` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di modificare il codice fiscale di una guida usando quello già appartenente a un cliente. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_codice_fiscale_guida2` BEFORE UPDATE ON `Guida`
FOR EACH ROW
BEGIN
IF NEW.Codice_fiscale <> OLD.Codice_fiscale THEN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Cliente) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad un cliente";
END IF;
END IF;
END $$
DELIMITER ;
```

## 13. `aggiorna_prenotazioni`

| Campo | Valore |
|---|---|
| Tabella | `Itinerario` |
| Evento | `UPDATE` |
| Timing | `AFTER` |
| Funzione | Aggiorna le date delle prenotazioni collegate alle navi dell’itinerario modificato. |

```sql
DELIMITER $$
CREATE TRIGGER `aggiorna_prenotazioni` AFTER UPDATE ON `Itinerario`
FOR EACH ROW
BEGIN
IF NEW.Data_inizio <> OLD.Data_inizio OR NEW.Data_fine <> OLD.Data_fine THEN
UPDATE Prenotazione
SET Data_inizio = NEW.Data_inizio, Scadenza = NEW.Data_fine
WHERE IMO IN (SELECT IMO FROM Nave WHERE ID_itinerario = NEW.ID);
END IF;
END $$
DELIMITER ;
```

## 14. `cancella_prenotazione`

| Campo | Valore |
|---|---|
| Tabella | `Itinerario` |
| Evento | `DELETE` |
| Timing | `BEFORE` |
| Funzione | Cancella le prenotazioni collegate alle navi appartenenti all’itinerario eliminato. |

```sql
DELIMITER $$
CREATE TRIGGER `cancella_prenotazione` BEFORE DELETE ON `Itinerario`
FOR EACH ROW
BEGIN
DELETE Prenotazione
FROM Nave JOIN Prenotazione ON Prenotazione.IMO = Nave.IMO
WHERE Nave.ID_itinerario = OLD.ID;
END $$
DELIMITER ;
```

## 15. `controlla_aggiornamento_tipo_magazzino`

| Campo | Valore |
|---|---|
| Tabella | `Magazzino` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di modificare il tipo di un magazzino se contiene già merci stoccate. |

```sql
DELIMITER $$
CREATE TRIGGER `controlla_aggiornamento_tipo_magazzino` BEFORE UPDATE ON `Magazzino`
FOR EACH ROW
BEGIN
DECLARE numero_riferimenti INT;
IF UPPER(NEW.Tipo) <> UPPER(OLD.Tipo) THEN
SELECT COUNT(Stoccaggio.SSCC)
INTO numero_riferimenti
FROM Stoccaggio
WHERE Stoccaggio.Nome_magazzino = OLD.Nome AND Stoccaggio.Localita_magazzino = OLD.Localita;
IF numero_riferimenti > 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Non risulta consentito modificare il tipo di un magazzino contenente delle merci';
END IF;
END IF;
END $$
DELIMITER ;
```

## 16. `aggiorna_peso_container`

| Campo | Valore |
|---|---|
| Tabella | `Merce` |
| Evento | `INSERT` |
| Timing | `AFTER` |
| Funzione | Aggiorna il peso del container quando viene inserita una nuova merce. |

```sql
DELIMITER $$
CREATE TRIGGER `aggiorna_peso_container` AFTER INSERT ON `Merce`
FOR EACH ROW
BEGIN UPDATE Container SET Container.Peso=Container.Peso+NEW.Peso WHERE Container.ID=NEW.ID_container; END $$
DELIMITER ;
```

## 17. `controllo_aggiornamento_tipo_merce`

| Campo | Valore |
|---|---|
| Tabella | `Merce` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla che il genere della merce sia compatibile con il tipo di magazzino in cui è stoccata. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_aggiornamento_tipo_merce` BEFORE UPDATE ON `Merce`
FOR EACH ROW
BEGIN
DECLARE tipo_magazzino VARCHAR(100);
SELECT Magazzino.Tipo
INTO tipo_magazzino
FROM Stoccaggio JOIN Magazzino ON Stoccaggio.Nome_magazzino=Magazzino.Nome AND Stoccaggio.Localita_magazzino=Magazzino.Localita
WHERE Stoccaggio.SSCC=NEW.SSCC;
IF UPPER(NEW.Genere) <> UPPER(tipo_magazzino) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La merce risulta stoccata in un magazzino di tipo incompatibile';
END IF;
END $$
DELIMITER ;
```

## 18. `controllo_capacita_magazzino3`

| Campo | Valore |
|---|---|
| Tabella | `Merce` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Verifica che il magazzino abbia capacità sufficiente quando viene modificato il peso di una merce. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_capacita_magazzino3` BEFORE UPDATE ON `Merce`
FOR EACH ROW
BEGIN
DECLARE nome VARCHAR(100);
DECLARE localita VARCHAR(100);
DECLARE peso_totale DOUBLE;
DECLARE capacita_magazzino DOUBLE;
IF OLD.Peso <> NEW.Peso THEN
SELECT Nome_magazzino, Localita_magazzino
INTO nome, localita
FROM Stoccaggio
WHERE Stoccaggio.SSCC=NEW.SSCC;
IF nome IS NOT NULL AND localita IS NOT NULL THEN
SELECT COALESCE(SUM(Merce.Peso),0)
INTO peso_totale
FROM Merce JOIN Stoccaggio ON Merce.SSCC = Stoccaggio.SSCC
WHERE Stoccaggio.Nome_magazzino = nome AND Stoccaggio.Localita_magazzino = localita;
SELECT Capacita
INTO capacita_magazzino
FROM Magazzino
WHERE Magazzino.Nome = nome AND Magazzino.Localita = localita;
IF peso_totale + NEW.Peso - OLD.Peso > capacita_magazzino THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il magazzino non ha abbastanza capacita per stoccare questa merce';
END IF;
END IF;
END IF;
END $$
DELIMITER ;
```

## 19. `aggiorna_peso_container2`

| Campo | Valore |
|---|---|
| Tabella | `Merce` |
| Evento | `UPDATE` |
| Timing | `AFTER` |
| Funzione | Aggiorna il peso dei container quando viene modificato il peso o il container associato a una merce. |

```sql
DELIMITER $$
CREATE TRIGGER `aggiorna_peso_container2` AFTER UPDATE ON `Merce`
FOR EACH ROW
BEGIN
    IF NEW.ID_container = OLD.ID_container THEN
        UPDATE Container
        SET Peso = Peso + NEW.Peso - OLD.Peso
        WHERE ID = NEW.ID_container;
    ELSE
        UPDATE Container
        SET Peso = Peso - OLD.Peso
        WHERE ID = OLD.ID_container;

        UPDATE Container
        SET Peso = Peso + NEW.Peso
        WHERE ID = NEW.ID_container;
    END IF;
END $$
DELIMITER ;
```

## 20. `aggiorna_peso_container3`

| Campo | Valore |
|---|---|
| Tabella | `Merce` |
| Evento | `DELETE` |
| Timing | `AFTER` |
| Funzione | Riduce il peso del container quando viene eliminata una merce. |

```sql
DELIMITER $$
CREATE TRIGGER `aggiorna_peso_container3` AFTER DELETE ON `Merce`
FOR EACH ROW
BEGIN UPDATE Container SET Container.Peso=Container.Peso-OLD.Peso WHERE Container.ID=OLD.ID_container; END $$
DELIMITER ;
```

## 21. `controllo_banchina`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che la nave sia compatibile con la banchina e che ci sia abbastanza lunghezza disponibile. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_banchina` BEFORE INSERT ON `Nave`
FOR EACH ROW
BEGIN
DECLARE tipo_banchina VARCHAR(10);
DECLARE lunghezza_banchina DOUBLE;
DECLARE lunghezza_occupata DOUBLE;
SELECT Tipo, Lunghezza
INTO tipo_banchina, lunghezza_banchina
FROM Banchina
WHERE Numero=NEW.Numero_banchina AND Settore=NEW.Settore_banchina;
SELECT COALESCE(SUM(Nave.lunghezza),0)
INTO lunghezza_occupata
FROM Nave
WHERE Numero_banchina=NEW.Numero_banchina AND Settore_banchina=NEW.Settore_banchina;
IF NEW.Tipo <> tipo_banchina THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il tipo di banchina non risulta compatibile con il tipo di nave';
ELSEIF lunghezza_occupata+NEW.lunghezza>lunghezza_banchina THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La banchina non ha abbastanza lunghezza residua per attraccare la nave';
END IF;
END $$
DELIMITER ;
```

## 22. `inizializzazione_contatori_nave`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Inizializza peso e volume occupati a 0 per le navi di tipo Cargo. |

```sql
DELIMITER $$
CREATE TRIGGER `inizializzazione_contatori_nave` BEFORE INSERT ON `Nave`
FOR EACH ROW
BEGIN
IF NEW.Tipo='Cargo' THEN
SET NEW.Peso_occupato=0, NEW.Volume_occupato=0;
END IF;
END $$
DELIMITER ;
```

## 23. `controllo_guide_itinerario`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che una nave da crociera con itinerario abbia esattamente 6 guide associate. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_guide_itinerario` BEFORE INSERT ON `Nave`
FOR EACH ROW
BEGIN
    DECLARE numero_guide INT;

    
    IF NEW.Tipo = 'Crociera' AND NEW.ID_itinerario IS NOT NULL THEN

        SELECT COUNT(Guida.Codice_fiscale)
        INTO numero_guide
        FROM Guida
        WHERE Guida.ID_itinerario = NEW.ID_itinerario;

        IF numero_guide <> 6 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ci devono essere 6 guide per ogni itinerario';
        END IF;

    END IF;

END $$
DELIMITER ;
```

## 24. `controllo_tipo_nave_itinerario`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Impedisce di assegnare un itinerario a una nave Cargo. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_itinerario` BEFORE INSERT ON `Nave`
FOR EACH ROW
BEGIN
IF NEW.Tipo='Cargo' AND NEW.ID_itinerario IS NOT NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Gli itinerari non possono essere assegnati alle navi cargo';
END IF;
END $$
DELIMITER ;
```

## 25. `controllo_banchina2`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla compatibilità e spazio della banchina quando vengono modificati dati della nave. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_banchina2` BEFORE UPDATE ON `Nave`
FOR EACH ROW
BEGIN
DECLARE tipo_banchina VARCHAR(10);
DECLARE lunghezza_banchina DOUBLE;
DECLARE lunghezza_occupata DOUBLE;
IF NEW.Numero_banchina <> OLD.Numero_banchina OR NEW.Settore_banchina <> OLD.Settore_banchina OR NEW.Lunghezza <> OLD.Lunghezza THEN
SELECT Tipo, Lunghezza
INTO tipo_banchina, lunghezza_banchina
FROM Banchina
WHERE Numero=NEW.Numero_banchina AND Settore=NEW.Settore_banchina;
SELECT COALESCE(SUM(Nave.lunghezza),0)
INTO lunghezza_occupata
FROM Nave
WHERE Numero_banchina=NEW.Numero_banchina AND Settore_banchina=NEW.Settore_banchina AND IMO <> OLD.IMO;
IF NEW.Tipo <> tipo_banchina THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il tipo di banchina non risulta compatibile con il tipo di nave';
ELSEIF lunghezza_occupata+NEW.lunghezza>lunghezza_banchina THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La banchina non ha abbastanza lunghezza residua per attraccare la nave';
END IF;
END IF;
END $$
DELIMITER ;
```

## 26. `controllo_guide_itinerario2`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla che, in caso di modifica dell’itinerario, siano presenti 6 guide associate. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_guide_itinerario2` BEFORE UPDATE ON `Nave`
FOR EACH ROW
BEGIN
DECLARE numero_guide INT;
IF NOT(NEW.ID_itinerario <=> OLD.ID_itinerario) AND NEW.ID_itinerario IS NOT NULL THEN
SELECT COUNT(Guida.Codice_fiscale)
INTO numero_guide
FROM Guida 
WHERE ID_itinerario=NEW.ID_itinerario;
IF numero_guide <> 6 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Ci devono essere 6 guide per ogni itinerario';
END IF;
END IF;
END $$
DELIMITER ;
```

## 27. `controllo_tipo_nave_itinerario2`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di assegnare un itinerario a una nave Cargo durante una modifica. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_itinerario2` BEFORE UPDATE ON `Nave`
FOR EACH ROW
BEGIN
IF NEW.Tipo='Cargo' AND NEW.ID_itinerario IS NOT NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Gli itinerario non possono essere assegnati alle navi cargo';
END IF;
END $$
DELIMITER ;
```

## 28. `rimuovi_prenotazioni`

| Campo | Valore |
|---|---|
| Tabella | `Nave` |
| Evento | `UPDATE` |
| Timing | `AFTER` |
| Funzione | Rimuove le prenotazioni quando viene cambiato o rimosso l’itinerario associato alla nave. |

```sql
DELIMITER $$
CREATE TRIGGER `rimuovi_prenotazioni` AFTER UPDATE ON `Nave`
FOR EACH ROW
BEGIN
IF NOT(OLD.ID_itinerario <=> NEW.ID_itinerario) AND OLD.ID_itinerario IS NOT NULL THEN
DELETE 
FROM Prenotazione
WHERE IMO = NEW.IMO;
END IF;
END $$
DELIMITER ;
```

## 29. `controllo_date_prenotazione`

| Campo | Valore |
|---|---|
| Tabella | `Prenotazione` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che le date della prenotazione siano valide e che la stanza non sia già prenotata. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_date_prenotazione` BEFORE INSERT ON `Prenotazione`
FOR EACH ROW
BEGIN
DECLARE inizio DATE;
DECLARE fine DATE;
SELECT Itinerario.Data_inizio, Itinerario.Data_fine
INTO inizio, fine
FROM Nave JOIN Itinerario ON Nave.ID_itinerario = Itinerario.ID
WHERE Nave.IMO=NEW.IMO;
IF NEW.Data_inizio < inizio OR NEW.Scadenza > fine THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Le date non sono valide per l''itinerario prenotato';
ELSEIF EXISTS(
SELECT *
FROM Prenotazione
WHERE IMO=NEW.IMO AND Numero=NEW.Numero AND NOT(NEW.Data_inizio>=Scadenza OR NEW.Scadenza<=Data_inizio)) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La stanza selezionata risulta prenotata per questo intervallo di tempo';
END IF;
END $$
DELIMITER ;
```

## 30. `controllo_itinerario_prenotazione`

| Campo | Valore |
|---|---|
| Tabella | `Prenotazione` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Impedisce di prenotare una stanza su una nave che non ha un itinerario associato. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_itinerario_prenotazione` BEFORE INSERT ON `Prenotazione`
FOR EACH ROW
BEGIN
DECLARE itinerario INT;
SELECT ID_itinerario
INTO itinerario
FROM Nave
WHERE IMO=NEW.IMO;
IF itinerario IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Non risulta possibile prenotare una stanza su una nave senza itinerario";
END IF;
END $$
DELIMITER ;
```

## 31. `controllo_date_prenotazione2`

| Campo | Valore |
|---|---|
| Tabella | `Prenotazione` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla la validità delle date e la disponibilità della stanza quando una prenotazione viene modificata. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_date_prenotazione2` BEFORE UPDATE ON `Prenotazione`
FOR EACH ROW
BEGIN
DECLARE inizio DATE;
DECLARE fine DATE;
IF NEW.Data_inizio < OLD.Data_inizio OR NEW.Scadenza > OLD.Scadenza OR NEW.IMO <> OLD.IMO OR NEW.Numero <> OLD.Numero THEN
SELECT Itinerario.Data_inizio, Itinerario.Data_fine
INTO inizio, fine
FROM Nave JOIN Itinerario ON Nave.ID_itinerario = Itinerario.ID
WHERE Nave.IMO=NEW.IMO;
IF NEW.Data_inizio < inizio OR NEW.Scadenza > fine THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Le date non sono valide per l''itinerario prenotato';
ELSEIF EXISTS(
SELECT *
FROM Prenotazione
WHERE IMO=NEW.IMO AND Numero=NEW.Numero AND NOT(NEW.Data_inizio>=Scadenza OR NEW.Scadenza<=Data_inizio) AND ID <> OLD.ID) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La stanza selezionata risulta prenotata per questo intervallo di tempo';
END IF;
END IF;
END $$
DELIMITER ;
```

## 32. `controllo_itinerario_prenotazione2`

| Campo | Valore |
|---|---|
| Tabella | `Prenotazione` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Impedisce di modificare una prenotazione assegnandola a una nave senza itinerario. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_itinerario_prenotazione2` BEFORE UPDATE ON `Prenotazione`
FOR EACH ROW
BEGIN
DECLARE itinerario INT;
IF NEW.IMO<> OLD.IMO THEN
SELECT ID_itinerario
INTO itinerario
FROM Nave
WHERE IMO=NEW.IMO;
IF itinerario IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Non risulta possibile prenotare una stanza su una nave senza itinerario";
END IF;
END IF;
END $$
DELIMITER ;
```

## 33. `controllo_tipo_nave_stanza`

| Campo | Valore |
|---|---|
| Tabella | `Stanza` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Verifica che le stanze possano essere inserite solo su navi di tipo Crociera. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_stanza` BEFORE INSERT ON `Stanza`
FOR EACH ROW
BEGIN
DECLARE tipo_nave VARCHAR(10);
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE Nave.IMO=NEW.IMO;
IF tipo_nave <> 'Crociera' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non viene suddiviso in stanze';
END IF;
END $$
DELIMITER ;
```

## 34. `controllo_capienza_nave`

| Campo | Valore |
|---|---|
| Tabella | `Stanza` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che la nave abbia capienza sufficiente prima di aggiungere una nuova stanza. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_capienza_nave` BEFORE INSERT ON `Stanza`
FOR EACH ROW
BEGIN
DECLARE capienza_nave INT;
DECLARE numero_stanze_singole INT;
DECLARE numero_stanze_doppie INT;
DECLARE aggiunta INT;
SELECT Capienza
INTO capienza_nave
FROM Nave
WHERE Nave.IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_singole
FROM Stanza
WHERE Tipo = 'Singola' AND IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_doppie
FROM Stanza
WHERE (Tipo = 'Doppia' OR Tipo = 'Matrimoniale') AND IMO = NEW.IMO;
IF NEW.Tipo = 'Singola' THEN
SET aggiunta = 1;
ELSE
SET aggiunta = 2;
END IF;
IF numero_stanze_singole+numero_stanze_doppie*2+aggiunta > capienza_nave THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La nave non ha abbastanza capienza';
END IF;
END $$
DELIMITER ;
```

## 35. `controllo_tipo_nave_stanza2`

| Campo | Valore |
|---|---|
| Tabella | `Stanza` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Verifica, in aggiornamento, che le stanze rimangano associate solo a navi di tipo Crociera. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_tipo_nave_stanza2` BEFORE UPDATE ON `Stanza`
FOR EACH ROW
BEGIN
DECLARE tipo_nave VARCHAR(10);
IF NEW.IMO <> OLD.IMO THEN
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE Nave.IMO=NEW.IMO;
IF tipo_nave <> 'Crociera' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non viene suddiviso in stanze';
END IF;
END IF;
END $$
DELIMITER ;
```

## 36. `controllo_capienza_nave2`

| Campo | Valore |
|---|---|
| Tabella | `Stanza` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla la capienza della nave quando viene modificato il tipo o la nave associata a una stanza. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_capienza_nave2` BEFORE UPDATE ON `Stanza`
FOR EACH ROW
BEGIN
DECLARE capienza_nave INT;
DECLARE numero_stanze_singole INT;
DECLARE numero_stanze_doppie INT;
DECLARE aggiunta INT;
IF NEW.IMO <> OLD.IMO THEN
SELECT Capienza
INTO capienza_nave
FROM Nave
WHERE Nave.IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_singole
FROM Stanza
WHERE Tipo = 'Singola' AND IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_doppie
FROM Stanza
WHERE (Tipo = 'Doppia' OR Tipo = 'Matrimoniale') AND IMO = NEW.IMO;
IF NEW.Tipo = 'Singola' THEN
SET aggiunta = 1;
ELSE
SET aggiunta = 2;
END IF;
IF numero_stanze_singole+numero_stanze_doppie*2+aggiunta > capienza_nave THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La nave non ha abbastanza capienza';
END IF;
ELSEIF NEW.Tipo <> OLD.Tipo AND OLD.Tipo = 'Singola' THEN
SELECT Capienza
INTO capienza_nave
FROM Nave
WHERE Nave.IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_singole
FROM Stanza
WHERE Tipo = 'Singola' AND IMO = NEW.IMO;
SELECT COUNT(*)
INTO numero_stanze_doppie
FROM Stanza
WHERE (Tipo = 'Doppia' OR Tipo = 'Matrimoniale') AND IMO = NEW.IMO;
IF numero_stanze_singole + numero_stanze_doppie*2 + 1 > capienza_nave THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La nave non ha abbastanza capienza';
END IF;
END IF;
END $$
DELIMITER ;
```

## 37. `controlla_tipo_merce_e_magazzino`

| Campo | Valore |
|---|---|
| Tabella | `Stoccaggio` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che una merce venga stoccata solo in un magazzino compatibile con il suo genere. |

```sql
DELIMITER $$
CREATE TRIGGER `controlla_tipo_merce_e_magazzino` BEFORE INSERT ON `Stoccaggio`
FOR EACH ROW
BEGIN
    DECLARE tipo_merce VARCHAR(100);
    DECLARE tipo_magazzino VARCHAR(100);

    SELECT Genere
    INTO tipo_merce
    FROM Merce
    WHERE Merce.SSCC = NEW.SSCC;

    SELECT Tipo
    INTO tipo_magazzino
    FROM Magazzino
    WHERE Magazzino.Nome = NEW.Nome_magazzino
      AND Magazzino.Localita = NEW.Localita_magazzino;

    IF UPPER(tipo_merce) <> UPPER(tipo_magazzino) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il magazzino selezionato non stocca questo tipo di merce';
    END IF;
END $$
DELIMITER ;
```

## 38. `controllo_capacita_magazzino`

| Campo | Valore |
|---|---|
| Tabella | `Stoccaggio` |
| Evento | `INSERT` |
| Timing | `BEFORE` |
| Funzione | Controlla che il magazzino abbia capacità sufficiente prima di stoccare una merce. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_capacita_magazzino` BEFORE INSERT ON `Stoccaggio`
FOR EACH ROW
BEGIN
DECLARE peso_totale DOUBLE;
DECLARE nuovo_peso DOUBLE;
DECLARE capacita_magazzino DOUBLE;
SELECT COALESCE(SUM(Merce.Peso),0)
INTO peso_totale
FROM Merce JOIN Stoccaggio ON Merce.SSCC = Stoccaggio.SSCC
WHERE Stoccaggio.Nome_magazzino = NEW.Nome_magazzino AND Stoccaggio.Localita_magazzino = NEW.Localita_magazzino;
SELECT Merce.Peso
INTO nuovo_peso
FROM Merce
WHERE Merce.SSCC=NEW.SSCC;
SELECT Capacita
INTO capacita_magazzino
FROM Magazzino
WHERE Magazzino.Nome=NEW.Nome_magazzino AND Magazzino.Localita=NEW.Localita_magazzino;
IF peso_totale+nuovo_peso > capacita_magazzino THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il magazzino non ha abbastanza capacita per stoccare questa merce';
END IF;
END $$
DELIMITER ;
```

## 39. `controlla_tipo_merce_e_magazzino2`

| Campo | Valore |
|---|---|
| Tabella | `Stoccaggio` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla, in aggiornamento, che la merce resti associata a un magazzino compatibile. |

```sql
DELIMITER $$
CREATE TRIGGER `controlla_tipo_merce_e_magazzino2` BEFORE UPDATE ON `Stoccaggio`
FOR EACH ROW
BEGIN
DECLARE tipo_merce VARCHAR(100);
DECLARE tipo_magazzino VARCHAR(100);
SELECT Genere INTO tipo_merce
FROM Merce
WHERE Merce.SSCC=NEW.SSCC;
SELECT Tipo INTO tipo_magazzino
FROM Magazzino
WHERE NEW.Nome_magazzino=Magazzino.Nome AND NEW.Localita_magazzino=Magazzino.Localita;
IF UPPER(tipo_merce) <> UPPER(tipo_magazzino) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Il magazzino selezionato non stocca questo tipo di merce';
END IF;
END $$
DELIMITER ;
```

## 40. `controllo_capacita_magazzino2`

| Campo | Valore |
|---|---|
| Tabella | `Stoccaggio` |
| Evento | `UPDATE` |
| Timing | `BEFORE` |
| Funzione | Controlla la capacità del magazzino quando viene modificato uno stoccaggio. |

```sql
DELIMITER $$
CREATE TRIGGER `controllo_capacita_magazzino2` BEFORE UPDATE ON `Stoccaggio`
FOR EACH ROW
BEGIN
    DECLARE peso_totale DOUBLE;
    DECLARE nuovo_peso DOUBLE;
    DECLARE capacita_magazzino DOUBLE;

    SELECT Merce.Peso
    INTO nuovo_peso
    FROM Merce
    WHERE Merce.SSCC = NEW.SSCC;

    SELECT COALESCE(SUM(Merce.Peso),0)
    INTO peso_totale
    FROM Merce
    JOIN Stoccaggio ON Merce.SSCC = Stoccaggio.SSCC
    WHERE Stoccaggio.Nome_magazzino = NEW.Nome_magazzino
      AND Stoccaggio.Localita_magazzino = NEW.Localita_magazzino
      AND Merce.SSCC <> OLD.SSCC;

    SELECT Capacita
    INTO capacita_magazzino
    FROM Magazzino
    WHERE Magazzino.Nome = NEW.Nome_magazzino
      AND Magazzino.Localita = NEW.Localita_magazzino;

    IF peso_totale + nuovo_peso > capacita_magazzino THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il magazzino non ha abbastanza capacita per stoccare questa merce';
    END IF;
END $$
DELIMITER ;
```
