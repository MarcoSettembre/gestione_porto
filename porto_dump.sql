-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: porto
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Banchina`
--

DROP TABLE IF EXISTS `Banchina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Banchina` (
  `Numero` int NOT NULL,
  `Settore` int NOT NULL,
  `Tipo` enum('Cargo','Crociera') NOT NULL,
  `Lunghezza` double NOT NULL,
  PRIMARY KEY (`Numero`,`Settore`),
  CONSTRAINT `Banchina_chk_1` CHECK ((`Lunghezza` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Banchina`
--

LOCK TABLES `Banchina` WRITE;
/*!40000 ALTER TABLE `Banchina` DISABLE KEYS */;
/*!40000 ALTER TABLE `Banchina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Cliente`
--

DROP TABLE IF EXISTS `Cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Cliente` (
  `Codice_fiscale` char(16) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Cognome` varchar(100) NOT NULL,
  `Data_nascita` date NOT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Codice_fiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Cliente`
--

LOCK TABLES `Cliente` WRITE;
/*!40000 ALTER TABLE `Cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `Cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Container`
--

DROP TABLE IF EXISTS `Container`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Container` (
  `ID` char(11) NOT NULL,
  `Dimensione` int NOT NULL,
  `Peso` double NOT NULL,
  `Marchio` varchar(100) NOT NULL,
  `IMO` char(7) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `IMO` (`IMO`),
  CONSTRAINT `Container_ibfk_1` FOREIGN KEY (`IMO`) REFERENCES `Nave` (`IMO`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Container_chk_1` CHECK (((`Dimensione` > 0) and (`Peso` > 0))),
  CONSTRAINT `Container_chk_2` CHECK (regexp_like(`ID`,_utf8mb4'^[A-Z]{4}[0-9]{7}$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Container`
--

LOCK TABLES `Container` WRITE;
/*!40000 ALTER TABLE `Container` DISABLE KEYS */;
/*!40000 ALTER TABLE `Container` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_peso_e_capacita` BEFORE INSERT ON `Container` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_container` BEFORE INSERT ON `Container` FOR EACH ROW BEGIN
DECLARE tipo_nave VARCHAR(10);
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE IMO = NEW.IMO;
IF tipo_nave <> 'Cargo' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non trasporta container';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiornamento_peso_e_capacita` BEFORE UPDATE ON `Container` FOR EACH ROW BEGIN 
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_container2` BEFORE UPDATE ON `Container` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `liberazione_peso_e_capacita` AFTER DELETE ON `Container` FOR EACH ROW BEGIN
    UPDATE Nave
    SET Peso_occupato = Peso_occupato - OLD.Peso,
        Volume_occupato = Volume_occupato - OLD.Dimensione
    WHERE IMO = OLD.IMO;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `elimina_merce_non_stoccata` AFTER DELETE ON `Container` FOR EACH ROW BEGIN
    DELETE Merce
    FROM Merce
    LEFT JOIN Stoccaggio ON Merce.SSCC = Stoccaggio.SSCC
    WHERE Merce.ID_container = OLD.ID
      AND Stoccaggio.Nome_magazzino IS NULL;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Guida`
--

DROP TABLE IF EXISTS `Guida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Guida` (
  `Codice_fiscale` char(16) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Cognome` varchar(100) NOT NULL,
  `Data_nascita` date NOT NULL,
  `Numero_licensa` int NOT NULL,
  `Stipendio` decimal(20,2) NOT NULL,
  `Data_assunzione` date NOT NULL,
  `Valutazione` double NOT NULL,
  `ID_itinerario` int DEFAULT NULL,
  PRIMARY KEY (`Codice_fiscale`),
  UNIQUE KEY `Numero_licensa` (`Numero_licensa`),
  KEY `ID_itinerario` (`ID_itinerario`),
  CONSTRAINT `Guida_ibfk_1` FOREIGN KEY (`ID_itinerario`) REFERENCES `Itinerario` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Guida_chk_1` CHECK ((`Stipendio` > 0)),
  CONSTRAINT `Guida_chk_2` CHECK ((((to_days(`Data_assunzione`) - to_days(`Data_nascita`)) / 365.25) >= 18)),
  CONSTRAINT `Guida_chk_3` CHECK (((`Valutazione` >= 1) and (`Valutazione` <= 5)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Guida`
--

LOCK TABLES `Guida` WRITE;
/*!40000 ALTER TABLE `Guida` DISABLE KEYS */;
/*!40000 ALTER TABLE `Guida` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_itinerario_guida` BEFORE INSERT ON `Guida` FOR EACH ROW BEGIN
DECLARE numero_guide INT;
SELECT COUNT(Codice_fiscale)
INTO numero_guide
FROM Guida
WHERE ID_itinerario=NEW.ID_itinerario;
IF numero_guide>=6 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Non si possono inserire piu di 6 guide per itinerario';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_itinerario_guida2` BEFORE UPDATE ON `Guida` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Itinerario`
--

DROP TABLE IF EXISTS `Itinerario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Itinerario` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Data_inizio` date NOT NULL,
  `Data_fine` date NOT NULL,
  `Nome` varchar(100) DEFAULT NULL,
  `Prezzo` decimal(20,2) NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `Itinerario_chk_1` CHECK ((`Data_inizio` <= `Data_fine`)),
  CONSTRAINT `Itinerario_chk_2` CHECK ((`Prezzo` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Itinerario`
--

LOCK TABLES `Itinerario` WRITE;
/*!40000 ALTER TABLE `Itinerario` DISABLE KEYS */;
/*!40000 ALTER TABLE `Itinerario` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cancella_prenotazione` BEFORE DELETE ON `Itinerario` FOR EACH ROW BEGIN
DELETE Prenotazione
FROM Nave JOIN Prenotazione ON Prenotazione.IMO = Nave.IMO
WHERE Nave.ID_itinerario = OLD.ID;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Lingue_guida`
--

DROP TABLE IF EXISTS `Lingue_guida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Lingue_guida` (
  `Codice_fiscale` char(16) NOT NULL,
  `Lingua` varchar(50) NOT NULL,
  `Livello` enum('A1','A2','B1','B2','C1','C2','Nativa') NOT NULL,
  PRIMARY KEY (`Codice_fiscale`,`Lingua`),
  CONSTRAINT `Lingue_guida_ibfk_1` FOREIGN KEY (`Codice_fiscale`) REFERENCES `Guida` (`Codice_fiscale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Lingue_guida`
--

LOCK TABLES `Lingue_guida` WRITE;
/*!40000 ALTER TABLE `Lingue_guida` DISABLE KEYS */;
/*!40000 ALTER TABLE `Lingue_guida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Magazzino`
--

DROP TABLE IF EXISTS `Magazzino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Magazzino` (
  `Nome` varchar(100) NOT NULL,
  `Localita` varchar(100) NOT NULL,
  `Tipo` varchar(100) NOT NULL,
  `Capacita` double NOT NULL,
  PRIMARY KEY (`Nome`,`Localita`),
  CONSTRAINT `Magazzino_chk_1` CHECK ((`Capacita` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Magazzino`
--

LOCK TABLES `Magazzino` WRITE;
/*!40000 ALTER TABLE `Magazzino` DISABLE KEYS */;
/*!40000 ALTER TABLE `Magazzino` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controlla_aggiornamento_tipo_magazzino` BEFORE UPDATE ON `Magazzino` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Merce`
--

DROP TABLE IF EXISTS `Merce`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Merce` (
  `SSCC` char(18) NOT NULL,
  `Peso` double NOT NULL,
  `Paese` varchar(50) NOT NULL,
  `Genere` varchar(100) NOT NULL,
  `ID_container` char(11) DEFAULT NULL,
  PRIMARY KEY (`SSCC`),
  KEY `ID_container` (`ID_container`),
  CONSTRAINT `Merce_chk_1` CHECK ((`Peso` > 0)),
  CONSTRAINT `Merce_chk_2` CHECK (regexp_like(`SSCC`,_utf8mb4'^[0-9]{18}$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Merce`
--

LOCK TABLES `Merce` WRITE;
/*!40000 ALTER TABLE `Merce` DISABLE KEYS */;
/*!40000 ALTER TABLE `Merce` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiorna_peso_container` AFTER INSERT ON `Merce` FOR EACH ROW BEGIN UPDATE Container SET Container.Peso=Container.Peso+NEW.Peso WHERE Container.ID=NEW.ID_container; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_aggiornamento_tipo_merce` BEFORE UPDATE ON `Merce` FOR EACH ROW BEGIN
DECLARE tipo_magazzino VARCHAR(100);
SELECT Magazzino.Tipo
INTO tipo_magazzino
FROM Stoccaggio JOIN Magazzino ON Stoccaggio.Nome_magazzino=Magazzino.Nome AND Stoccaggio.Localita_magazzino=Magazzino.Localita
WHERE Stoccaggio.SSCC=NEW.SSCC;
IF UPPER(NEW.Genere) <> UPPER(tipo_magazzino) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='La merce risulta stoccata in un magazzino di tipo incompatibile';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_capacita_magazzino3` BEFORE UPDATE ON `Merce` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiorna_peso_container2` AFTER UPDATE ON `Merce` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiorna_peso_container3` AFTER DELETE ON `Merce` FOR EACH ROW BEGIN UPDATE Container SET Container.Peso=Container.Peso-OLD.Peso WHERE Container.ID=OLD.ID_container; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Nave`
--

DROP TABLE IF EXISTS `Nave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nave` (
  `IMO` char(7) NOT NULL,
  `Nome` varchar(100) NOT NULL,
  `Nazionalita` varchar(100) NOT NULL,
  `Compagnia` varchar(100) NOT NULL,
  `Altezza` double NOT NULL,
  `Lunghezza` double NOT NULL,
  `Larghezza` double NOT NULL,
  `Peso_massimo` double DEFAULT NULL,
  `Capacita` int DEFAULT NULL,
  `Peso_occupato` double DEFAULT '0',
  `Volume_occupato` int DEFAULT '0',
  `Capienza` int DEFAULT NULL,
  `Tipo` enum('Cargo','Crociera') NOT NULL,
  `Numero_banchina` int DEFAULT NULL,
  `Settore_banchina` int DEFAULT NULL,
  `ID_itinerario` int DEFAULT NULL,
  PRIMARY KEY (`IMO`),
  KEY `Numero_banchina` (`Numero_banchina`,`Settore_banchina`),
  KEY `ID_itinerario` (`ID_itinerario`),
  CONSTRAINT `Nave_ibfk_1` FOREIGN KEY (`Numero_banchina`, `Settore_banchina`) REFERENCES `Banchina` (`Numero`, `Settore`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Nave_ibfk_2` FOREIGN KEY (`ID_itinerario`) REFERENCES `Itinerario` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Nave_chk_1` CHECK (regexp_like(`IMO`,_utf8mb4'^[0-9]{7}$')),
  CONSTRAINT `Nave_chk_2` CHECK (((`Altezza` > 0) and (`Lunghezza` > 0) and (`Larghezza` > 0))),
  CONSTRAINT `Nave_chk_3` CHECK ((((`Peso_massimo` is null) or (`Peso_massimo` > 0)) and ((`Capacita` is null) or (`Capacita` > 0)) and (`Peso_occupato` >= 0) and (`Volume_occupato` >= 0))),
  CONSTRAINT `Nave_chk_4` CHECK (((`Capienza` is null) or (`Capienza` > 0))),
  CONSTRAINT `Nave_chk_5` CHECK ((((`Tipo` = _utf8mb4'Crociera') and (`Capienza` is not null)) or ((`Tipo` = _utf8mb4'Cargo') and (`Capienza` is null)))),
  CONSTRAINT `Nave_chk_6` CHECK ((((`Tipo` = _utf8mb4'Cargo') and (`Peso_massimo` is not null) and (`Capacita` is not null)) or ((`Tipo` = _utf8mb4'Crociera') and (`Peso_massimo` is null) and (`Capacita` is null)))),
  CONSTRAINT `Nave_chk_7` CHECK (((`Peso_massimo` is null) or (`Peso_occupato` <= `Peso_massimo`))),
  CONSTRAINT `Nave_chk_8` CHECK (((`Capacita` is null) or (`Volume_occupato` <= `Capacita`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nave`
--

LOCK TABLES `Nave` WRITE;
/*!40000 ALTER TABLE `Nave` DISABLE KEYS */;
/*!40000 ALTER TABLE `Nave` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_banchina` BEFORE INSERT ON `Nave` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_guide_itinerario` BEFORE INSERT ON `Nave` FOR EACH ROW BEGIN
DECLARE numero_guide INT;
IF NEW.Tipo='Crociera' AND ID_itinerario IS NOT NULL THEN
SELECT COUNT(Guida.Codice_fiscale)
INTO numero_guide
FROM Guida 
WHERE ID_itinerario=NEW.ID_itinerario;
IF numero_guide <> 6 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Ci devono essere 6 guide per ogni itinerario';
END IF;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `inizializzazione_contatori_nave` BEFORE INSERT ON `Nave` FOR EACH ROW BEGIN
IF NEW.Tipo='Cargo' THEN
SET NEW.Peso_occupato=0, NEW.Volume_occupato=0;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_banchina2` BEFORE UPDATE ON `Nave` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_guide_itinerario2` BEFORE UPDATE ON `Nave` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `cambiamento_itinerario_nave` BEFORE UPDATE ON `Nave` FOR EACH ROW BEGIN
IF NOT(OLD.ID_itinerario <=> NEW.ID_itinerario) AND OLD.ID_itinerario IS NOT NULL THEN
IF EXISTS(SELECT 1 FROM Prenotazione WHERE IMO=OLD.IMO) THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Ci sono ancora prenotazioni associate a questo itinerario";
END IF;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Prenotazione`
--

DROP TABLE IF EXISTS `Prenotazione`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Prenotazione` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `IMO` char(7) NOT NULL,
  `Numero` int NOT NULL,
  `Codice_fiscale` char(16) NOT NULL,
  `Data_inizio` date NOT NULL,
  `Scadenza` date NOT NULL,
  `Servizio_guida` tinyint(1) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IMO` (`IMO`,`Numero`),
  KEY `Codice_fiscale` (`Codice_fiscale`),
  CONSTRAINT `Prenotazione_ibfk_1` FOREIGN KEY (`IMO`, `Numero`) REFERENCES `Stanza` (`IMO`, `Numero`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Prenotazione_ibfk_2` FOREIGN KEY (`Codice_fiscale`) REFERENCES `Cliente` (`Codice_fiscale`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prenotazione`
--

LOCK TABLES `Prenotazione` WRITE;
/*!40000 ALTER TABLE `Prenotazione` DISABLE KEYS */;
/*!40000 ALTER TABLE `Prenotazione` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_date_prenotazione` BEFORE INSERT ON `Prenotazione` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_itinerario_prenotazione` BEFORE INSERT ON `Prenotazione` FOR EACH ROW BEGIN
DECLARE itinerario INT;
SELECT ID_itinerario
INTO itinerario
FROM Nave
WHERE IMO=NEW.IMO;
IF itinerario IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Non risulta possibile prenotare una stanza su una nave senza itinerario";
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_date_prenotazione2` BEFORE UPDATE ON `Prenotazione` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_itinerario_prenotazione2` BEFORE UPDATE ON `Prenotazione` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Stanza`
--

DROP TABLE IF EXISTS `Stanza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stanza` (
  `IMO` char(7) NOT NULL,
  `Numero` int NOT NULL,
  `Classe` enum('Interna','Esterna','Suite') NOT NULL,
  `Tipo` enum('Singola','Doppia','Matrimoniale') NOT NULL,
  PRIMARY KEY (`IMO`,`Numero`),
  CONSTRAINT `Stanza_ibfk_1` FOREIGN KEY (`IMO`) REFERENCES `Nave` (`IMO`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Stanza_chk_1` CHECK ((`Numero` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stanza`
--

LOCK TABLES `Stanza` WRITE;
/*!40000 ALTER TABLE `Stanza` DISABLE KEYS */;
/*!40000 ALTER TABLE `Stanza` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_stanza` BEFORE INSERT ON `Stanza` FOR EACH ROW BEGIN
DECLARE tipo_nave VARCHAR(10);
SELECT Tipo
INTO tipo_nave
FROM Nave
WHERE Nave.IMO=NEW.IMO;
IF tipo_nave <> 'Crociera' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Questo tipo di nave non viene suddiviso in stanze';
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_capienza_nave` BEFORE INSERT ON `Stanza` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_stanza2` BEFORE UPDATE ON `Stanza` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_capienza_nave2` BEFORE UPDATE ON `Stanza` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Stoccaggio`
--

DROP TABLE IF EXISTS `Stoccaggio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Stoccaggio` (
  `SSCC` char(18) NOT NULL,
  `Nome_magazzino` varchar(100) NOT NULL,
  `Localita_magazzino` varchar(100) NOT NULL,
  PRIMARY KEY (`SSCC`),
  KEY `Nome_magazzino` (`Nome_magazzino`,`Localita_magazzino`),
  CONSTRAINT `Stoccaggio_ibfk_1` FOREIGN KEY (`Nome_magazzino`, `Localita_magazzino`) REFERENCES `Magazzino` (`Nome`, `Localita`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Stoccaggio_ibfk_2` FOREIGN KEY (`SSCC`) REFERENCES `Merce` (`SSCC`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Stoccaggio`
--

LOCK TABLES `Stoccaggio` WRITE;
/*!40000 ALTER TABLE `Stoccaggio` DISABLE KEYS */;
/*!40000 ALTER TABLE `Stoccaggio` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controlla_tipo_merce_e_magazzino` BEFORE INSERT ON `Stoccaggio` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_capacita_magazzino` BEFORE INSERT ON `Stoccaggio` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controlla_tipo_merce_e_magazzino2` BEFORE UPDATE ON `Stoccaggio` FOR EACH ROW BEGIN DECLARE tipo_merce VARCHAR(100); DECLARE tipo_magazzino VARCHAR(100); SELECT Genere INTO tipo_merce FROM Merce WHERE Merce.SSCC=NEW.SSCC; SELECT Tipo INTO tipo_magazzino FROM Magazzino WHERE NEW.Nome_magazzino=Magazzino.Nome AND NEW.Localita_magazzino=Magazzino.Localita; IF UPPER(tipo_merce) <> UPPER(tipo_magazzino) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Il magazzino selezionato non stocca questo tipo di merce'; END IF; END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_capacita_magazzino2` BEFORE UPDATE ON `Stoccaggio` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Tappe_itinerario`
--

DROP TABLE IF EXISTS `Tappe_itinerario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tappe_itinerario` (
  `ID_itinerario` int NOT NULL,
  `Tappa` varchar(100) NOT NULL,
  PRIMARY KEY (`ID_itinerario`,`Tappa`),
  CONSTRAINT `Tappe_itinerario_ibfk_1` FOREIGN KEY (`ID_itinerario`) REFERENCES `Itinerario` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tappe_itinerario`
--

LOCK TABLES `Tappe_itinerario` WRITE;
/*!40000 ALTER TABLE `Tappe_itinerario` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tappe_itinerario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_clienti_attualmente_a_bordo`
--

DROP TABLE IF EXISTS `v_clienti_attualmente_a_bordo`;
/*!50001 DROP VIEW IF EXISTS `v_clienti_attualmente_a_bordo`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_clienti_attualmente_a_bordo` AS SELECT 
 1 AS `Codice_fiscale`,
 1 AS `Nome_cliente`,
 1 AS `IMO`,
 1 AS `Nome_nave`,
 1 AS `Numero_stanza`,
 1 AS `Classe_stanza`,
 1 AS `Tipo_stanza`,
 1 AS `Data_inizio_prenotazione`,
 1 AS `Scadenza_prenotazione`,
 1 AS `Servizio_guida`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_container_su_nave`
--

DROP TABLE IF EXISTS `v_container_su_nave`;
/*!50001 DROP VIEW IF EXISTS `v_container_su_nave`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_container_su_nave` AS SELECT 
 1 AS `IMO`,
 1 AS `Nome`,
 1 AS `Numero_container`,
 1 AS `Peso_occupato`,
 1 AS `Volume_occupato`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_guide_per_itinerario`
--

DROP TABLE IF EXISTS `v_guide_per_itinerario`;
/*!50001 DROP VIEW IF EXISTS `v_guide_per_itinerario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_guide_per_itinerario` AS SELECT 
 1 AS `ID`,
 1 AS `Nome_itinerario`,
 1 AS `Data_inizio`,
 1 AS `Data_fine`,
 1 AS `Nome_guida`,
 1 AS `Valutazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_itinerari_attivi`
--

DROP TABLE IF EXISTS `v_itinerari_attivi`;
/*!50001 DROP VIEW IF EXISTS `v_itinerari_attivi`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_itinerari_attivi` AS SELECT 
 1 AS `ID`,
 1 AS `Nome`,
 1 AS `Data_inizio`,
 1 AS `Data_fine`,
 1 AS `Prezzo`,
 1 AS `Numero_navi`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_lingue_guida_livello`
--

DROP TABLE IF EXISTS `v_lingue_guida_livello`;
/*!50001 DROP VIEW IF EXISTS `v_lingue_guida_livello`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_lingue_guida_livello` AS SELECT 
 1 AS `Codice_fiscale`,
 1 AS `Lingua`,
 1 AS `Livello`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_merci_in_container`
--

DROP TABLE IF EXISTS `v_merci_in_container`;
/*!50001 DROP VIEW IF EXISTS `v_merci_in_container`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_merci_in_container` AS SELECT 
 1 AS `ID`,
 1 AS `IMO`,
 1 AS `Dimensione`,
 1 AS `Peso`,
 1 AS `Numero_merci`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_merci_in_magazzino`
--

DROP TABLE IF EXISTS `v_merci_in_magazzino`;
/*!50001 DROP VIEW IF EXISTS `v_merci_in_magazzino`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_merci_in_magazzino` AS SELECT 
 1 AS `Nome`,
 1 AS `Localita`,
 1 AS `Tipo`,
 1 AS `Capacita`,
 1 AS `Peso_totale_stoccato`,
 1 AS `Capacita_residua`,
 1 AS `Numero_merci`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_merci_per_genere`
--

DROP TABLE IF EXISTS `v_merci_per_genere`;
/*!50001 DROP VIEW IF EXISTS `v_merci_per_genere`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_merci_per_genere` AS SELECT 
 1 AS `Genere`,
 1 AS `Peso_medio`,
 1 AS `Numero_merci`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_merci_per_paese`
--

DROP TABLE IF EXISTS `v_merci_per_paese`;
/*!50001 DROP VIEW IF EXISTS `v_merci_per_paese`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_merci_per_paese` AS SELECT 
 1 AS `Paese`,
 1 AS `Peso_medio`,
 1 AS `Numero_merci`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_merci_su_nave`
--

DROP TABLE IF EXISTS `v_merci_su_nave`;
/*!50001 DROP VIEW IF EXISTS `v_merci_su_nave`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_merci_su_nave` AS SELECT 
 1 AS `IMO`,
 1 AS `Nome`,
 1 AS `Peso_occupato`,
 1 AS `Volume_occupato`,
 1 AS `Numero_merci`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_navi_in_porto`
--

DROP TABLE IF EXISTS `v_navi_in_porto`;
/*!50001 DROP VIEW IF EXISTS `v_navi_in_porto`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_navi_in_porto` AS SELECT 
 1 AS `IMO`,
 1 AS `Nome`,
 1 AS `Nazionalita`,
 1 AS `Compagnia`,
 1 AS `Altezza`,
 1 AS `Lunghezza`,
 1 AS `Larghezza`,
 1 AS `Peso_massimo`,
 1 AS `Capacita`,
 1 AS `Peso_occupato`,
 1 AS `Volume_occupato`,
 1 AS `Capienza`,
 1 AS `Tipo`,
 1 AS `Numero_banchina`,
 1 AS `Settore_banchina`,
 1 AS `ID_itinerario`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_numero_tappe_itinerari`
--

DROP TABLE IF EXISTS `v_numero_tappe_itinerari`;
/*!50001 DROP VIEW IF EXISTS `v_numero_tappe_itinerari`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_numero_tappe_itinerari` AS SELECT 
 1 AS `ID`,
 1 AS `Nome`,
 1 AS `Data_inizio`,
 1 AS `Data_fine`,
 1 AS `Prezzo`,
 1 AS `Numero_Tappe`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_occupazione_camere`
--

DROP TABLE IF EXISTS `v_occupazione_camere`;
/*!50001 DROP VIEW IF EXISTS `v_occupazione_camere`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_occupazione_camere` AS SELECT 
 1 AS `IMO`,
 1 AS `Nome`,
 1 AS `Capienza`,
 1 AS `Posti_occupati`,
 1 AS `Posti_liberi`,
 1 AS `Percentuale_occupazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_occupazione_camere_con_vuote`
--

DROP TABLE IF EXISTS `v_occupazione_camere_con_vuote`;
/*!50001 DROP VIEW IF EXISTS `v_occupazione_camere_con_vuote`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_occupazione_camere_con_vuote` AS SELECT 
 1 AS `IMO`,
 1 AS `Nome`,
 1 AS `Capienza`,
 1 AS `Posti_occupati`,
 1 AS `Posti_liberi`,
 1 AS `Percentuale_occupazione`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_prenotazioni_attive`
--

DROP TABLE IF EXISTS `v_prenotazioni_attive`;
/*!50001 DROP VIEW IF EXISTS `v_prenotazioni_attive`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_prenotazioni_attive` AS SELECT 
 1 AS `ID`,
 1 AS `Codice_fiscale`,
 1 AS `Nominativo_cliente`,
 1 AS `IMO`,
 1 AS `Numero`,
 1 AS `Data_inizio`,
 1 AS `Scadenza`,
 1 AS `Servizio_guida`,
 1 AS `Nome_itinerario`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_stanze_libere`
--

DROP TABLE IF EXISTS `v_stanze_libere`;
/*!50001 DROP VIEW IF EXISTS `v_stanze_libere`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_stanze_libere` AS SELECT 
 1 AS `IMO`,
 1 AS `Numero`,
 1 AS `Classe`,
 1 AS `Tipo`,
 1 AS `Nome_nave`,
 1 AS `ID_itinerario`,
 1 AS `Nome_itinerario`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_statistiche_clienti_per_compagnia`
--

DROP TABLE IF EXISTS `v_statistiche_clienti_per_compagnia`;
/*!50001 DROP VIEW IF EXISTS `v_statistiche_clienti_per_compagnia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_statistiche_clienti_per_compagnia` AS SELECT 
 1 AS `Compagnia`,
 1 AS `Numero_clienti`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_statistiche_complete_per_compagnia`
--

DROP TABLE IF EXISTS `v_statistiche_complete_per_compagnia`;
/*!50001 DROP VIEW IF EXISTS `v_statistiche_complete_per_compagnia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_statistiche_complete_per_compagnia` AS SELECT 
 1 AS `Compagnia`,
 1 AS `Numero_navi`,
 1 AS `Numero_navi_da_crociera`,
 1 AS `Occupazione_media`,
 1 AS `Numero_clienti`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_statistiche_navi_per_compagnia`
--

DROP TABLE IF EXISTS `v_statistiche_navi_per_compagnia`;
/*!50001 DROP VIEW IF EXISTS `v_statistiche_navi_per_compagnia`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_statistiche_navi_per_compagnia` AS SELECT 
 1 AS `Compagnia`,
 1 AS `Numero_navi`,
 1 AS `Numero_navi_da_crociera`,
 1 AS `Occupazione_media`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_stato_banchina`
--

DROP TABLE IF EXISTS `v_stato_banchina`;
/*!50001 DROP VIEW IF EXISTS `v_stato_banchina`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_stato_banchina` AS SELECT 
 1 AS `Numero`,
 1 AS `Settore`,
 1 AS `Tipo`,
 1 AS `Lunghezza_totale`,
 1 AS `Lunghezza_occupata`,
 1 AS `Lunghezza_residua`,
 1 AS `Numero_navi`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_valutazione_media_per_itinerario`
--

DROP TABLE IF EXISTS `v_valutazione_media_per_itinerario`;
/*!50001 DROP VIEW IF EXISTS `v_valutazione_media_per_itinerario`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_valutazione_media_per_itinerario` AS SELECT 
 1 AS `ID`,
 1 AS `Nome`,
 1 AS `Valutazione_media`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_clienti_attualmente_a_bordo`
--

/*!50001 DROP VIEW IF EXISTS `v_clienti_attualmente_a_bordo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_clienti_attualmente_a_bordo` AS select `C`.`Codice_fiscale` AS `Codice_fiscale`,concat(`C`.`Nome`,' ',`C`.`Cognome`) AS `Nome_cliente`,`N`.`IMO` AS `IMO`,`N`.`Nome` AS `Nome_nave`,`S`.`Numero` AS `Numero_stanza`,`S`.`Classe` AS `Classe_stanza`,`S`.`Tipo` AS `Tipo_stanza`,`P`.`Data_inizio` AS `Data_inizio_prenotazione`,`P`.`Scadenza` AS `Scadenza_prenotazione`,`P`.`Servizio_guida` AS `Servizio_guida` from (((`Cliente` `C` join `Prenotazione` `P` on((`C`.`Codice_fiscale` = `P`.`Codice_fiscale`))) join `Stanza` `S` on(((`P`.`IMO` = `S`.`IMO`) and (`P`.`Numero` = `S`.`Numero`)))) join `Nave` `N` on((`S`.`IMO` = `N`.`IMO`))) where ((`P`.`Data_inizio` <= curdate()) and (`P`.`Scadenza` >= curdate())) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_container_su_nave`
--

/*!50001 DROP VIEW IF EXISTS `v_container_su_nave`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_container_su_nave` AS select `N`.`IMO` AS `IMO`,`N`.`Nome` AS `Nome`,count(`C`.`ID`) AS `Numero_container`,`N`.`Peso_occupato` AS `Peso_occupato`,`N`.`Volume_occupato` AS `Volume_occupato` from (`Nave` `N` left join `Container` `C` on((`N`.`IMO` = `C`.`IMO`))) where (`N`.`Tipo` = 'Cargo') group by `N`.`IMO`,`N`.`Nome`,`N`.`Peso_occupato`,`N`.`Volume_occupato` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_guide_per_itinerario`
--

/*!50001 DROP VIEW IF EXISTS `v_guide_per_itinerario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_guide_per_itinerario` AS select `I`.`ID` AS `ID`,`I`.`Nome` AS `Nome_itinerario`,`I`.`Data_inizio` AS `Data_inizio`,`I`.`Data_fine` AS `Data_fine`,concat(`G`.`Nome`,' ',`G`.`Cognome`) AS `Nome_guida`,`G`.`Valutazione` AS `Valutazione` from (`Itinerario` `I` join `Guida` `G` on((`I`.`ID` = `G`.`ID_itinerario`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_itinerari_attivi`
--

/*!50001 DROP VIEW IF EXISTS `v_itinerari_attivi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_itinerari_attivi` AS select `I`.`ID` AS `ID`,`I`.`Nome` AS `Nome`,`I`.`Data_inizio` AS `Data_inizio`,`I`.`Data_fine` AS `Data_fine`,`I`.`Prezzo` AS `Prezzo`,count(`N`.`IMO`) AS `Numero_navi` from (`Itinerario` `I` join `Nave` `N` on((`I`.`ID` = `N`.`ID_itinerario`))) where ((`I`.`Data_inizio` <= curdate()) and (`I`.`Data_fine` >= curdate())) group by `I`.`ID`,`I`.`Nome`,`I`.`Data_inizio`,`I`.`Data_fine`,`I`.`Prezzo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_lingue_guida_livello`
--

/*!50001 DROP VIEW IF EXISTS `v_lingue_guida_livello`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_lingue_guida_livello` AS select `Lingue_guida`.`Codice_fiscale` AS `Codice_fiscale`,`Lingue_guida`.`Lingua` AS `Lingua`,`Lingue_guida`.`Livello` AS `Livello` from `Lingue_guida` order by `Lingue_guida`.`Codice_fiscale`,`Lingue_guida`.`Livello` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_merci_in_container`
--

/*!50001 DROP VIEW IF EXISTS `v_merci_in_container`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_merci_in_container` AS select `C`.`ID` AS `ID`,`C`.`IMO` AS `IMO`,`C`.`Dimensione` AS `Dimensione`,`C`.`Peso` AS `Peso`,count(`M`.`SSCC`) AS `Numero_merci` from (`Container` `C` left join `Merce` `M` on((`C`.`ID` = `M`.`ID_container`))) group by `C`.`ID`,`C`.`IMO`,`C`.`Dimensione`,`C`.`Peso` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_merci_in_magazzino`
--

/*!50001 DROP VIEW IF EXISTS `v_merci_in_magazzino`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_merci_in_magazzino` AS select `Ma`.`Nome` AS `Nome`,`Ma`.`Localita` AS `Localita`,`Ma`.`Tipo` AS `Tipo`,`Ma`.`Capacita` AS `Capacita`,coalesce(sum(`Me`.`Peso`),0) AS `Peso_totale_stoccato`,(`Ma`.`Capacita` - coalesce(sum(`Me`.`Peso`),0)) AS `Capacita_residua`,count(`Me`.`SSCC`) AS `Numero_merci` from ((`Magazzino` `Ma` left join `Stoccaggio` `S` on(((`Ma`.`Nome` = `S`.`Nome_magazzino`) and (`Ma`.`Localita` = `S`.`Localita_magazzino`)))) left join `Merce` `Me` on((`S`.`SSCC` = `Me`.`SSCC`))) group by `Ma`.`Nome`,`Ma`.`Localita`,`Ma`.`Tipo`,`Ma`.`Capacita` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_merci_per_genere`
--

/*!50001 DROP VIEW IF EXISTS `v_merci_per_genere`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_merci_per_genere` AS select `Merce`.`Genere` AS `Genere`,avg(`Merce`.`Peso`) AS `Peso_medio`,count(`Merce`.`SSCC`) AS `Numero_merci` from `Merce` group by `Merce`.`Genere` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_merci_per_paese`
--

/*!50001 DROP VIEW IF EXISTS `v_merci_per_paese`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_merci_per_paese` AS select `Merce`.`Paese` AS `Paese`,avg(`Merce`.`Peso`) AS `Peso_medio`,count(`Merce`.`SSCC`) AS `Numero_merci` from `Merce` group by `Merce`.`Paese` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_merci_su_nave`
--

/*!50001 DROP VIEW IF EXISTS `v_merci_su_nave`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_merci_su_nave` AS select `N`.`IMO` AS `IMO`,`N`.`Nome` AS `Nome`,`N`.`Peso_occupato` AS `Peso_occupato`,`N`.`Volume_occupato` AS `Volume_occupato`,coalesce(sum(`v_merci_in_container`.`Numero_merci`),0) AS `Numero_merci` from (`Nave` `N` left join `v_merci_in_container` on((`N`.`IMO` = `v_merci_in_container`.`IMO`))) where (`N`.`Tipo` = 'Cargo') group by `N`.`IMO`,`N`.`Nome`,`N`.`Peso_occupato`,`N`.`Volume_occupato` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_navi_in_porto`
--

/*!50001 DROP VIEW IF EXISTS `v_navi_in_porto`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_navi_in_porto` AS select `Nave`.`IMO` AS `IMO`,`Nave`.`Nome` AS `Nome`,`Nave`.`Nazionalita` AS `Nazionalita`,`Nave`.`Compagnia` AS `Compagnia`,`Nave`.`Altezza` AS `Altezza`,`Nave`.`Lunghezza` AS `Lunghezza`,`Nave`.`Larghezza` AS `Larghezza`,`Nave`.`Peso_massimo` AS `Peso_massimo`,`Nave`.`Capacita` AS `Capacita`,`Nave`.`Peso_occupato` AS `Peso_occupato`,`Nave`.`Volume_occupato` AS `Volume_occupato`,`Nave`.`Capienza` AS `Capienza`,`Nave`.`Tipo` AS `Tipo`,`Nave`.`Numero_banchina` AS `Numero_banchina`,`Nave`.`Settore_banchina` AS `Settore_banchina`,`Nave`.`ID_itinerario` AS `ID_itinerario` from `Nave` where ((`Nave`.`Numero_banchina` is not null) and (`Nave`.`Settore_banchina` is not null)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_numero_tappe_itinerari`
--

/*!50001 DROP VIEW IF EXISTS `v_numero_tappe_itinerari`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_numero_tappe_itinerari` AS select `I`.`ID` AS `ID`,`I`.`Nome` AS `Nome`,`I`.`Data_inizio` AS `Data_inizio`,`I`.`Data_fine` AS `Data_fine`,`I`.`Prezzo` AS `Prezzo`,count(`TI`.`Tappa`) AS `Numero_Tappe` from (`Tappe_itinerario` `TI` join `Itinerario` `I` on((`TI`.`ID_itinerario` = `I`.`ID`))) group by `I`.`ID`,`I`.`Nome`,`I`.`Data_inizio`,`I`.`Data_fine`,`I`.`Prezzo` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_occupazione_camere`
--

/*!50001 DROP VIEW IF EXISTS `v_occupazione_camere`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_occupazione_camere` AS select `N`.`IMO` AS `IMO`,`N`.`Nome` AS `Nome`,`N`.`Capienza` AS `Capienza`,sum((case when ((`S`.`Tipo` = 'Doppia') or (`S`.`Tipo` = 'Matrimoniale')) then 2 when (`S`.`Tipo` = 'Singola') then 1 else 0 end)) AS `Posti_occupati`,(`N`.`Capienza` - sum((case when ((`S`.`Tipo` = 'Doppia') or (`S`.`Tipo` = 'Matrimoniale')) then 2 when (`S`.`Tipo` = 'Singola') then 1 else 0 end))) AS `Posti_liberi`,((sum((case when ((`S`.`Tipo` = 'Doppia') or (`S`.`Tipo` = 'Matrimoniale')) then 2 when (`S`.`Tipo` = 'Singola') then 1 else 0 end)) * 100.0) / `N`.`Capienza`) AS `Percentuale_occupazione` from ((`Nave` `N` join `Stanza` `S` on((`N`.`IMO` = `S`.`IMO`))) join `Prenotazione` `P` on(((`P`.`IMO` = `S`.`IMO`) and (`P`.`Numero` = `S`.`Numero`)))) where ((`P`.`Data_inizio` <= curdate()) and (`P`.`Scadenza` >= curdate())) group by `N`.`IMO`,`N`.`Nome`,`N`.`Capienza` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_occupazione_camere_con_vuote`
--

/*!50001 DROP VIEW IF EXISTS `v_occupazione_camere_con_vuote`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_occupazione_camere_con_vuote` AS select `N`.`IMO` AS `IMO`,`N`.`Nome` AS `Nome`,`N`.`Capienza` AS `Capienza`,coalesce(`v_occupazione_camere`.`Posti_occupati`,0) AS `Posti_occupati`,coalesce(`v_occupazione_camere`.`Posti_liberi`,`N`.`Capienza`) AS `Posti_liberi`,coalesce(`v_occupazione_camere`.`Percentuale_occupazione`,0) AS `Percentuale_occupazione` from (`Nave` `N` left join `v_occupazione_camere` on((`N`.`IMO` = `v_occupazione_camere`.`IMO`))) where (`N`.`Tipo` = 'Crociera') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_prenotazioni_attive`
--

/*!50001 DROP VIEW IF EXISTS `v_prenotazioni_attive`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_prenotazioni_attive` AS select `P`.`ID` AS `ID`,`P`.`Codice_fiscale` AS `Codice_fiscale`,concat(`C`.`Nome`,' ',`C`.`Cognome`) AS `Nominativo_cliente`,`P`.`IMO` AS `IMO`,`P`.`Numero` AS `Numero`,`P`.`Data_inizio` AS `Data_inizio`,`P`.`Scadenza` AS `Scadenza`,`P`.`Servizio_guida` AS `Servizio_guida`,`I`.`Nome` AS `Nome_itinerario` from (((`Prenotazione` `P` join `Cliente` `C` on((`P`.`Codice_fiscale` = `C`.`Codice_fiscale`))) join `Nave` `N` on((`P`.`IMO` = `N`.`IMO`))) join `Itinerario` `I` on((`N`.`ID_itinerario` = `I`.`ID`))) where (`P`.`Scadenza` >= curdate()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_stanze_libere`
--

/*!50001 DROP VIEW IF EXISTS `v_stanze_libere`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_stanze_libere` AS select `S`.`IMO` AS `IMO`,`S`.`Numero` AS `Numero`,`S`.`Classe` AS `Classe`,`S`.`Tipo` AS `Tipo`,`N`.`Nome` AS `Nome_nave`,`I`.`ID` AS `ID_itinerario`,`I`.`Nome` AS `Nome_itinerario` from ((`Stanza` `S` join `Nave` `N` on((`S`.`IMO` = `N`.`IMO`))) left join `Itinerario` `I` on((`N`.`ID_itinerario` = `I`.`ID`))) where exists(select 1 from `Prenotazione` where ((`Prenotazione`.`IMO` = `S`.`IMO`) and (`Prenotazione`.`Numero` = `S`.`Numero`) and (`Prenotazione`.`Data_inizio` <= curdate()) and (`Prenotazione`.`Scadenza` >= curdate()))) is false */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_statistiche_clienti_per_compagnia`
--

/*!50001 DROP VIEW IF EXISTS `v_statistiche_clienti_per_compagnia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_statistiche_clienti_per_compagnia` AS select `N`.`Compagnia` AS `Compagnia`,count(distinct `P`.`Codice_fiscale`) AS `Numero_clienti` from (`Nave` `N` left join `Prenotazione` `P` on((`N`.`IMO` = `P`.`IMO`))) group by `N`.`Compagnia` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_statistiche_complete_per_compagnia`
--

/*!50001 DROP VIEW IF EXISTS `v_statistiche_complete_per_compagnia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_statistiche_complete_per_compagnia` AS select `N`.`Compagnia` AS `Compagnia`,`N`.`Numero_navi` AS `Numero_navi`,`N`.`Numero_navi_da_crociera` AS `Numero_navi_da_crociera`,`N`.`Occupazione_media` AS `Occupazione_media`,`C`.`Numero_clienti` AS `Numero_clienti` from (`v_statistiche_navi_per_compagnia` `N` join `v_statistiche_clienti_per_compagnia` `C` on((`N`.`Compagnia` = `C`.`Compagnia`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_statistiche_navi_per_compagnia`
--

/*!50001 DROP VIEW IF EXISTS `v_statistiche_navi_per_compagnia`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_statistiche_navi_per_compagnia` AS select `N`.`Compagnia` AS `Compagnia`,count(`N`.`IMO`) AS `Numero_navi`,count((case when (`N`.`Tipo` = 'Crociera') then 1 end)) AS `Numero_navi_da_crociera`,coalesce(avg(`V`.`Percentuale_occupazione`),0) AS `Occupazione_media` from (`Nave` `N` left join `v_occupazione_camere_con_vuote` `V` on((`N`.`IMO` = `V`.`IMO`))) group by `N`.`Compagnia` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_stato_banchina`
--

/*!50001 DROP VIEW IF EXISTS `v_stato_banchina`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_stato_banchina` AS select `B`.`Numero` AS `Numero`,`B`.`Settore` AS `Settore`,`B`.`Tipo` AS `Tipo`,`B`.`Lunghezza` AS `Lunghezza_totale`,coalesce(sum(`N`.`Lunghezza`),0) AS `Lunghezza_occupata`,(`B`.`Lunghezza` - coalesce(sum(`N`.`Lunghezza`),0)) AS `Lunghezza_residua`,count(`N`.`IMO`) AS `Numero_navi` from (`Banchina` `B` left join `Nave` `N` on(((`N`.`Numero_banchina` = `B`.`Numero`) and (`N`.`Settore_banchina` = `B`.`Settore`)))) group by `B`.`Numero`,`B`.`Settore`,`B`.`Tipo`,`B`.`Lunghezza` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_valutazione_media_per_itinerario`
--

/*!50001 DROP VIEW IF EXISTS `v_valutazione_media_per_itinerario`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_valutazione_media_per_itinerario` AS select `I`.`ID` AS `ID`,`I`.`Nome` AS `Nome`,avg(`G`.`Valutazione`) AS `Valutazione_media` from (`Itinerario` `I` join `Guida` `G` on((`I`.`ID` = `G`.`ID_itinerario`))) group by `I`.`ID`,`I`.`Nome` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-28 11:44:10
