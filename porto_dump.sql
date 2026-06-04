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
  CONSTRAINT `Banchina_chk_1` CHECK ((`Lunghezza` > 0)),
  CONSTRAINT `Banchina_chk_2` CHECK (((`Numero` > 0) and (`Settore` > 0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Banchina`
--

LOCK TABLES `Banchina` WRITE;
/*!40000 ALTER TABLE `Banchina` DISABLE KEYS */;
INSERT INTO `Banchina` VALUES (1,1,'Cargo',540),(5,1,'Crociera',740),(5,2,'Crociera',600),(6,10,'Cargo',400.5);
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
INSERT INTO `Cliente` VALUES ('RSSMRA80A01H501U','Mario','Rossi','1970-01-01','0812226565'),('VRDFLC00C05F839I','Felice','Verdi','2000-03-05','0812341222'),('ZZIRCR05S15I391G','Riccardo','Izzo','2005-11-15','(67) 95654-3254');
/*!40000 ALTER TABLE `Cliente` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_codice_fiscale_cliente` BEFORE INSERT ON `Cliente` FOR EACH ROW BEGIN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Guida) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad una guida";
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_codice_fiscale_cliente2` BEFORE UPDATE ON `Cliente` FOR EACH ROW BEGIN
IF NEW.Codice_fiscale <> OLD.Codice_fiscale THEN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Guida) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad una guida";
END IF;
END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
  CONSTRAINT `Container_chk_1` CHECK (((`Dimensione` > 0) and (`Peso` >= 0))),
  CONSTRAINT `Container_chk_2` CHECK (regexp_like(`ID`,_utf8mb4'^[A-Z]{4}[0-9]{7}$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Container`
--

LOCK TABLES `Container` WRITE;
/*!40000 ALTER TABLE `Container` DISABLE KEYS */;
INSERT INTO `Container` VALUES ('MSCU8429154',20,1500,'MSC','9358060'),('TGBU2074930',20,1000,'Textainer','8717647');
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
  `Valutazione` decimal(2,1) NOT NULL,
  `ID_itinerario` int DEFAULT NULL,
  PRIMARY KEY (`Codice_fiscale`),
  UNIQUE KEY `Numero_licensa` (`Numero_licensa`),
  KEY `ID_itinerario` (`ID_itinerario`),
  CONSTRAINT `Guida_ibfk_1` FOREIGN KEY (`ID_itinerario`) REFERENCES `Itinerario` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Guida_chk_1` CHECK ((`Stipendio` > 0)),
  CONSTRAINT `Guida_chk_2` CHECK ((((to_days(`Data_assunzione`) - to_days(`Data_nascita`)) / 365.25) >= 18)),
  CONSTRAINT `Guida_chk_3` CHECK (((`Valutazione` >= 1) and (`Valutazione` <= 5))),
  CONSTRAINT `Guida_chk_4` CHECK ((`Numero_licensa` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Guida`
--

LOCK TABLES `Guida` WRITE;
/*!40000 ALTER TABLE `Guida` DISABLE KEYS */;
INSERT INTO `Guida` VALUES ('BNCGLI88D55H501V','Giulia','Bianchi','1988-04-15',442,2100.00,'2016-03-12',4.6,5),('BNHGLI92L65F205V','Giulia','Bianchi','1992-07-25',2,1500.00,'2023-01-03',4.0,2),('ESPDVD81T05F839W','Davide','Esposito','1981-12-05',57,2600.00,'2006-09-10',5.0,5),('FRRLNE92P60G224S','Elena','Ferrari','1992-09-20',883,1850.00,'2020-06-15',4.2,5),('FRRRCR88P30F205L','Riccardo','Ferrari','1998-09-30',5,1600.00,'2025-02-11',5.0,2),('MRTLCA85E20C351D','Luca','Moretti','1985-05-20',305,2200.00,'2012-11-22',4.5,5),('RCCSFO95E54L219K','Sofia','Ricci','1995-05-14',6,1100.00,'2026-04-02',2.3,2),('RMNFNC00A58H501Y','Francesca','Romano','2000-01-18',4,1800.00,'2024-09-19',3.9,2),('RMNSRA95L48H501Z','Sara','Romano','1995-07-08',991,1700.00,'2022-04-01',3.9,5),('RSSMRC79M10F205A','Marco','Rossi','1979-08-10',119,2450.00,'2009-01-05',4.9,5),('RSSMRC85C12H501Z','Marco','Rossi','1985-03-12',1,1200.00,'2020-10-14',2.7,2),('SPSLSN78S05A662O','Alessandro','Esposito','1978-11-05',3,2000.00,'2021-05-22',4.5,2);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_codice_fiscale_guida` BEFORE INSERT ON `Guida` FOR EACH ROW BEGIN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Cliente) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad un cliente";
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
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_codice_fiscale_guida2` BEFORE UPDATE ON `Guida` FOR EACH ROW BEGIN
IF NEW.Codice_fiscale <> OLD.Codice_fiscale THEN
IF NEW.Codice_fiscale IN (SELECT Codice_fiscale FROM Cliente) THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT="Questo codice fiscale appartiene ad un cliente";
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
  `Nome` varchar(100) NOT NULL,
  `Prezzo` decimal(20,2) NOT NULL,
  PRIMARY KEY (`ID`),
  CONSTRAINT `Itinerario_chk_1` CHECK ((`Data_inizio` <= `Data_fine`)),
  CONSTRAINT `Itinerario_chk_2` CHECK ((`Prezzo` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Itinerario`
--

LOCK TABLES `Itinerario` WRITE;
/*!40000 ALTER TABLE `Itinerario` DISABLE KEYS */;
INSERT INTO `Itinerario` VALUES (2,'2026-05-23','2026-05-30','Mediterraneo Occidentale',450.00),(3,'2026-05-18','2026-05-25','Mediterraneo Orientale',400.00),(5,'2026-05-18','2026-05-27','Europa Occidentale',800.00);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiorna_prenotazioni` AFTER UPDATE ON `Itinerario` FOR EACH ROW BEGIN
IF NEW.Data_inizio <> OLD.Data_inizio OR NEW.Data_fine <> OLD.Data_fine THEN
UPDATE Prenotazione
SET Data_inizio = NEW.Data_inizio, Scadenza = NEW.Data_fine
WHERE IMO IN (SELECT IMO FROM Nave WHERE ID_itinerario = NEW.ID);
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
INSERT INTO `Lingue_guida` VALUES ('BNCGLI88D55H501V','Francese','B2'),('BNCGLI88D55H501V','Inglese','C2'),('BNCGLI88D55H501V','Italiano','Nativa'),('BNHGLI92L65F205V','Inglese','B2'),('BNHGLI92L65F205V','Italiano','Nativa'),('BNHGLI92L65F205V','Spagnolo','C1'),('ESPDVD81T05F839W','Inglese','C2'),('ESPDVD81T05F839W','Italiano','Nativa'),('ESPDVD81T05F839W','Spagnolo','C2'),('FRRLNE92P60G224S','Inglese','B2'),('FRRLNE92P60G224S','Italiano','Nativa'),('FRRLNE92P60G224S','Portoghese','A2'),('FRRRCR88P30F205L','Inglese','C2'),('FRRRCR88P30F205L','Italiano','Nativa'),('FRRRCR88P30F205L','Russo','A2'),('FRRRCR88P30F205L','Spagnolo','C2'),('MRTLCA85E20C351D','Inglese','C1'),('MRTLCA85E20C351D','Italiano','Nativa'),('MRTLCA85E20C351D','Russo','B2'),('RCCSFO95E54L219K','Inglese','B2'),('RCCSFO95E54L219K','Italiano','Nativa'),('RCCSFO95E54L219K','Portoghese','A2'),('RMNFNC00A58H501Y','Francese','B2'),('RMNFNC00A58H501Y','Italiano','Nativa'),('RMNFNC00A58H501Y','Tedesco','B1'),('RMNSRA95L48H501Z','Cinese','A1'),('RMNSRA95L48H501Z','Inglese','B2'),('RMNSRA95L48H501Z','Italiano','Nativa'),('RSSMRC79M10F205A','Italiano','Nativa'),('RSSMRC79M10F205A','Spagnolo','B1'),('RSSMRC79M10F205A','Tedesco','C1'),('RSSMRC85C12H501Z','Inglese','C1'),('RSSMRC85C12H501Z','Italiano','Nativa'),('SPSLSN78S05A662O','Francese','A2'),('SPSLSN78S05A662O','Inglese','C2'),('SPSLSN78S05A662O','Italiano','Nativa'),('SPSLSN78S05A662O','Spagnolo','C1');
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
INSERT INTO `Magazzino` VALUES ('SyncLink','Napoli','Elettronica',5000),('Walmart','Pretoria','Alimentare',4000),('Warehouse','Punta Arenas','Elettronica',6002.15);
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
  CONSTRAINT `Merce_ibfk_1` FOREIGN KEY (`ID_container`) REFERENCES `Container` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Merce_chk_1` CHECK ((`Peso` > 0)),
  CONSTRAINT `Merce_chk_2` CHECK (regexp_like(`SSCC`,_utf8mb4'^[0-9]{18}$'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Merce`
--

LOCK TABLES `Merce` WRITE;
/*!40000 ALTER TABLE `Merce` DISABLE KEYS */;
INSERT INTO `Merce` VALUES ('001234560000481293',1000,'Australia','Elettronica','MSCU8429154'),('006141411234567891',500,'Bangladesh','Abbigliamento','MSCU8429154'),('109876543210987654',1000,'Colombia','Alimentare','TGBU2074930');
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
  `Longitudine` double NOT NULL DEFAULT '0',
  `Latitudine` double NOT NULL DEFAULT '0',
  `Direzione` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`IMO`),
  KEY `Numero_banchina` (`Numero_banchina`,`Settore_banchina`),
  KEY `ID_itinerario` (`ID_itinerario`),
  CONSTRAINT `Nave_ibfk_1` FOREIGN KEY (`Numero_banchina`, `Settore_banchina`) REFERENCES `Banchina` (`Numero`, `Settore`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `Nave_ibfk_2` FOREIGN KEY (`ID_itinerario`) REFERENCES `Itinerario` (`ID`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `Nave_chk_1` CHECK (regexp_like(`IMO`,_utf8mb4'^[0-9]{7}$')),
  CONSTRAINT `Nave_chk_10` CHECK (((`Longitudine` >= -(180)) and (`Longitudine` <= 180))),
  CONSTRAINT `Nave_chk_11` CHECK (((`Direzione` >= 0) and (`Direzione` <= 360))),
  CONSTRAINT `Nave_chk_2` CHECK (((`Altezza` > 0) and (`Lunghezza` > 0) and (`Larghezza` > 0))),
  CONSTRAINT `Nave_chk_3` CHECK ((((`Peso_massimo` is null) or (`Peso_massimo` > 0)) and ((`Capacita` is null) or (`Capacita` > 0)) and (`Peso_occupato` >= 0) and (`Volume_occupato` >= 0))),
  CONSTRAINT `Nave_chk_4` CHECK (((`Capienza` is null) or (`Capienza` > 0))),
  CONSTRAINT `Nave_chk_5` CHECK ((((`Tipo` = _utf8mb4'Crociera') and (`Capienza` is not null)) or ((`Tipo` = _utf8mb4'Cargo') and (`Capienza` is null)))),
  CONSTRAINT `Nave_chk_6` CHECK ((((`Tipo` = _utf8mb4'Cargo') and (`Peso_massimo` is not null) and (`Capacita` is not null)) or ((`Tipo` = _utf8mb4'Crociera') and (`Peso_massimo` is null) and (`Capacita` is null)))),
  CONSTRAINT `Nave_chk_7` CHECK (((`Peso_massimo` is null) or (`Peso_occupato` <= `Peso_massimo`))),
  CONSTRAINT `Nave_chk_8` CHECK (((`Capacita` is null) or (`Volume_occupato` <= `Capacita`))),
  CONSTRAINT `Nave_chk_9` CHECK (((`Latitudine` >= -(90)) and (`Latitudine` <= 90)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nave`
--

LOCK TABLES `Nave` WRITE;
/*!40000 ALTER TABLE `Nave` DISABLE KEYS */;
INSERT INTO `Nave` VALUES ('8717647','Seaven Luck','Panama','TURATE SHIPPING SA',32,114.85,17.92,7477,4906,1000,20,NULL,'Cargo',1,1,NULL,12.24835,45.462,143),('9214513','QING YUN HE','Cina','Cosco Shanghai Ship Management',9.5,179.7,27.6,25645,1900,0,0,NULL,'Cargo',1,1,NULL,139.63838,35.05064,231.7),('9224336','JEANNE IV','Liberia','MSC',19.3,260,32.25,50954,4253,0,0,NULL,'Cargo',6,10,NULL,30.84733,-30.36426,208.7),('9280627','Puccini','Malta','CMA CGM',24.3,277.28,40,73235,5782,0,0,NULL,'Cargo',6,10,NULL,-35.3982,-9.98976,40.9),('9358060','Sea Cargo Express','Malta','SeaCargo AS',7,117,18,3855,118,1500,20,NULL,'Cargo',6,10,NULL,7.67886,63.10859,350.9),('9387085','Magnifica','Panama','MSC',59.6,293.8,32.2,NULL,NULL,0,0,3223,'Crociera',5,1,5,21.03422,55.73234,259.6),('9751511','Norwegian Encore','Bahamas','NCL',66,333.44,48.13,NULL,NULL,0,0,4903,'Crociera',5,1,NULL,-131.86782,55.4524,126),('9781889','Costa Smeralda','Italia','Costa Crociere',65.2,336.8,41.9,NULL,NULL,0,0,6600,'Crociera',NULL,NULL,NULL,11.77261,42.1039,324),('9818709','MV Hondius','Paesi Bassi','Oceanwide Expeditions',5.3,107.6,17.6,NULL,NULL,0,0,176,'Crociera',NULL,NULL,NULL,4.15445,51.95387,131),('9829930','Icon of the Seas','Bahamas','Royal Caribbean',72.4,365.2,65,NULL,NULL,0,0,7600,'Crociera',NULL,NULL,NULL,-78.23933,25.94007,112),('9837420','World Europa','Malta','MSC',68,333,54,NULL,NULL,0,0,6762,'Crociera',NULL,NULL,2,2.17041,41.34189,190),('9930038','Tessa','Liberia','MSC',83.5,400,61.5,241164,24116,0,0,NULL,'Cargo',6,10,NULL,103.61936,1.25417,270);
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_guide_itinerario` BEFORE INSERT ON `Nave` FOR EACH ROW BEGIN
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_itinerario` BEFORE INSERT ON `Nave` FOR EACH ROW BEGIN
IF NEW.Tipo='Cargo' AND NEW.ID_itinerario IS NOT NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Gli itinerari non possono essere assegnati alle navi cargo';
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_tipo_nave_itinerario2` BEFORE UPDATE ON `Nave` FOR EACH ROW BEGIN
IF NEW.Tipo='Cargo' AND NEW.ID_itinerario IS NOT NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Gli itinerario non possono essere assegnati alle navi cargo';
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
IF NOT(NEW.Numero_banchina <=> OLD.Numero_banchina) OR NOT(NEW.Settore_banchina <=> OLD.Settore_banchina) OR NOT(NEW.Lunghezza <=> OLD.Lunghezza) THEN
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
  CONSTRAINT `Prenotazione_ibfk_2` FOREIGN KEY (`Codice_fiscale`) REFERENCES `Cliente` (`Codice_fiscale`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Prenotazione_chk_1` CHECK ((`Data_inizio` <= `Scadenza`))
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Prenotazione`
--

LOCK TABLES `Prenotazione` WRITE;
/*!40000 ALTER TABLE `Prenotazione` DISABLE KEYS */;
INSERT INTO `Prenotazione` VALUES (5,'9837420',1,'VRDFLC00C05F839I','2026-05-23','2026-05-30',1),(6,'9837420',2,'VRDFLC00C05F839I','2026-05-23','2026-05-26',0),(7,'9837420',2,'RSSMRA80A01H501U','2026-05-27','2026-05-30',1);
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
INSERT INTO `Stanza` VALUES ('9837420',1,'Interna','Matrimoniale'),('9837420',2,'Suite','Doppia'),('9837420',3,'Suite','Singola'),('9837420',4,'Interna','Singola'),('9837420',5,'Interna','Doppia'),('9837420',6,'Esterna','Singola'),('9837420',7,'Esterna','Doppia'),('9837420',8,'Esterna','Matrimoniale'),('9837420',9,'Suite','Matrimoniale');
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
INSERT INTO `Stoccaggio` VALUES ('001234560000481293','SyncLink','Napoli'),('109876543210987654','Walmart','Pretoria');
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
INSERT INTO `Tappe_itinerario` VALUES (2,'Barcellona'),(2,'Genova'),(2,'Malta'),(2,'Marsiglia'),(2,'Messina'),(2,'Napoli'),(3,'Catania'),(3,'Malta'),(3,'Mykonos'),(3,'Napoli'),(3,'Santorini'),(5,'Barcellona'),(5,'Bilbao'),(5,'Brest'),(5,'La Coruna'),(5,'La Rochelle'),(5,'Rostock');
/*!40000 ALTER TABLE `Tappe_itinerario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
INSERT INTO `auth_group` VALUES (1,'cliente'),(3,'gestore_attracco_navi'),(2,'gestore_magazzino'),(5,'gestore_navi_cargo'),(4,'gestore_navi_crociera');
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=149 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
INSERT INTO `auth_group_permissions` VALUES (7,1,25),(8,1,26),(9,1,27),(10,1,28),(1,1,32),(3,1,44),(6,1,52),(5,1,60),(11,1,61),(12,1,62),(13,1,63),(2,1,64),(4,1,76),(14,2,36),(19,2,45),(20,2,46),(21,2,47),(22,2,48),(23,2,52),(24,2,56),(15,2,69),(16,2,70),(17,2,71),(18,2,72),(25,3,37),(26,3,38),(27,3,39),(28,3,40),(29,3,50),(30,3,52),(31,4,28),(32,4,29),(33,4,30),(34,4,31),(35,4,32),(36,4,40),(37,4,41),(38,4,42),(39,4,43),(40,4,44),(41,4,49),(42,4,50),(43,4,51),(44,4,52),(45,4,57),(46,4,58),(47,4,59),(48,4,60),(49,4,64),(50,4,65),(51,4,66),(52,4,67),(53,4,68),(54,4,73),(55,4,74),(56,4,75),(57,4,76),(58,5,33),(59,5,34),(60,5,35),(61,5,36),(62,5,40),(64,5,48),(65,5,49),(66,5,50),(67,5,51),(68,5,52),(69,5,53),(70,5,54),(71,5,55),(72,5,56),(63,5,72);
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',3,'add_permission'),(6,'Can change permission',3,'change_permission'),(7,'Can delete permission',3,'delete_permission'),(8,'Can view permission',3,'view_permission'),(9,'Can add group',2,'add_group'),(10,'Can change group',2,'change_group'),(11,'Can delete group',2,'delete_group'),(12,'Can view group',2,'view_group'),(13,'Can add user',4,'add_user'),(14,'Can change user',4,'change_user'),(15,'Can delete user',4,'delete_user'),(16,'Can view user',4,'view_user'),(17,'Can add content type',5,'add_contenttype'),(18,'Can change content type',5,'change_contenttype'),(19,'Can delete content type',5,'delete_contenttype'),(20,'Can view content type',5,'view_contenttype'),(21,'Can add session',6,'add_session'),(22,'Can change session',6,'change_session'),(23,'Can delete session',6,'delete_session'),(24,'Can view session',6,'view_session'),(25,'Can add cliente',8,'add_cliente'),(26,'Can change cliente',8,'change_cliente'),(27,'Can delete cliente',8,'delete_cliente'),(28,'Can view cliente',8,'view_cliente'),(29,'Can add itinerario',11,'add_itinerario'),(30,'Can change itinerario',11,'change_itinerario'),(31,'Can delete itinerario',11,'delete_itinerario'),(32,'Can view itinerario',11,'view_itinerario'),(33,'Can add merce',14,'add_merce'),(34,'Can change merce',14,'change_merce'),(35,'Can delete merce',14,'delete_merce'),(36,'Can view merce',14,'view_merce'),(37,'Can add banchina',7,'add_banchina'),(38,'Can change banchina',7,'change_banchina'),(39,'Can delete banchina',7,'delete_banchina'),(40,'Can view banchina',7,'view_banchina'),(41,'Can add guida',10,'add_guida'),(42,'Can change guida',10,'change_guida'),(43,'Can delete guida',10,'delete_guida'),(44,'Can view guida',10,'view_guida'),(45,'Can add magazzino',13,'add_magazzino'),(46,'Can change magazzino',13,'change_magazzino'),(47,'Can delete magazzino',13,'delete_magazzino'),(48,'Can view magazzino',13,'view_magazzino'),(49,'Can add nave',15,'add_nave'),(50,'Can change nave',15,'change_nave'),(51,'Can delete nave',15,'delete_nave'),(52,'Can view nave',15,'view_nave'),(53,'Can add container',9,'add_container'),(54,'Can change container',9,'change_container'),(55,'Can delete container',9,'delete_container'),(56,'Can view container',9,'view_container'),(57,'Can add stanza',17,'add_stanza'),(58,'Can change stanza',17,'change_stanza'),(59,'Can delete stanza',17,'delete_stanza'),(60,'Can view stanza',17,'view_stanza'),(61,'Can add prenotazione',16,'add_prenotazione'),(62,'Can change prenotazione',16,'change_prenotazione'),(63,'Can delete prenotazione',16,'delete_prenotazione'),(64,'Can view prenotazione',16,'view_prenotazione'),(65,'Can add lingue guida',12,'add_lingueguida'),(66,'Can change lingue guida',12,'change_lingueguida'),(67,'Can delete lingue guida',12,'delete_lingueguida'),(68,'Can view lingue guida',12,'view_lingueguida'),(69,'Can add stoccaggio',18,'add_stoccaggio'),(70,'Can change stoccaggio',18,'change_stoccaggio'),(71,'Can delete stoccaggio',18,'delete_stoccaggio'),(72,'Can view stoccaggio',18,'view_stoccaggio'),(73,'Can add tappe itinerario',19,'add_tappeitinerario'),(74,'Can change tappe itinerario',19,'change_tappeitinerario'),(75,'Can delete tappe itinerario',19,'delete_tappeitinerario'),(76,'Can view tappe itinerario',19,'view_tappeitinerario'),(77,'Can add user nave',23,'add_usernave'),(78,'Can change user nave',23,'change_usernave'),(79,'Can delete user nave',23,'delete_usernave'),(80,'Can view user nave',23,'view_usernave'),(81,'Can add user banchina',20,'add_userbanchina'),(82,'Can change user banchina',20,'change_userbanchina'),(83,'Can delete user banchina',20,'delete_userbanchina'),(84,'Can view user banchina',20,'view_userbanchina'),(85,'Can add user magazzino',22,'add_usermagazzino'),(86,'Can change user magazzino',22,'change_usermagazzino'),(87,'Can delete user magazzino',22,'delete_usermagazzino'),(88,'Can view user magazzino',22,'view_usermagazzino'),(89,'Can add user cliente',21,'add_usercliente'),(90,'Can change user cliente',21,'change_usercliente'),(91,'Can delete user cliente',21,'delete_usercliente'),(92,'Can view user cliente',21,'view_usercliente'),(93,'Can add user itinerario',25,'add_useritinerario'),(94,'Can change user itinerario',25,'change_useritinerario'),(95,'Can delete user itinerario',25,'delete_useritinerario'),(96,'Can view user itinerario',25,'view_useritinerario'),(97,'Can add user guida',24,'add_userguida'),(98,'Can change user guida',24,'change_userguida'),(99,'Can delete user guida',24,'delete_userguida'),(100,'Can view user guida',24,'view_userguida'),(101,'Can add storico prenotazione',26,'add_storicoprenotazione'),(102,'Can change storico prenotazione',26,'change_storicoprenotazione'),(103,'Can delete storico prenotazione',26,'delete_storicoprenotazione'),(104,'Can view storico prenotazione',26,'view_storicoprenotazione'),(105,'Can add tappe prenotazione',27,'add_tappeprenotazione'),(106,'Can change tappe prenotazione',27,'change_tappeprenotazione'),(107,'Can delete tappe prenotazione',27,'delete_tappeprenotazione'),(108,'Can view tappe prenotazione',27,'view_tappeprenotazione'),(109,'Can add crontab',29,'add_crontabschedule'),(110,'Can change crontab',29,'change_crontabschedule'),(111,'Can delete crontab',29,'delete_crontabschedule'),(112,'Can view crontab',29,'view_crontabschedule'),(113,'Can add interval',30,'add_intervalschedule'),(114,'Can change interval',30,'change_intervalschedule'),(115,'Can delete interval',30,'delete_intervalschedule'),(116,'Can view interval',30,'view_intervalschedule'),(117,'Can add periodic task',31,'add_periodictask'),(118,'Can change periodic task',31,'change_periodictask'),(119,'Can delete periodic task',31,'delete_periodictask'),(120,'Can view periodic task',31,'view_periodictask'),(121,'Can add periodic task track',32,'add_periodictasks'),(122,'Can change periodic task track',32,'change_periodictasks'),(123,'Can delete periodic task track',32,'delete_periodictasks'),(124,'Can view periodic task track',32,'view_periodictasks'),(125,'Can add solar event',33,'add_solarschedule'),(126,'Can change solar event',33,'change_solarschedule'),(127,'Can delete solar event',33,'delete_solarschedule'),(128,'Can view solar event',33,'view_solarschedule'),(129,'Can add clocked',28,'add_clockedschedule'),(130,'Can change clocked',28,'change_clockedschedule'),(131,'Can delete clocked',28,'delete_clockedschedule'),(132,'Can view clocked',28,'view_clockedschedule'),(133,'Can add system status',34,'add_systemstatus'),(134,'Can change system status',34,'change_systemstatus'),(135,'Can delete system status',34,'delete_systemstatus'),(136,'Can view system status',34,'view_systemstatus');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$1200000$U6l8hoiRICgSzZS7dpx7Jh$wS0rltNFohn1FtKPTs8I5xwrsJ7AU6sDJrr6DYy5KfM=','2026-04-30 13:47:16.708545',1,'haley','','','',1,1,'2026-04-28 15:24:44.000000'),(3,'pbkdf2_sha256$1200000$56XAyzxjVCCIjKtz9SDS5s$RQBArrypYRTTX/tDD7EAzzuAx7vOoRd8bYF6UwMPeIY=','2026-05-28 08:14:39.794288',1,'admin','','','',1,1,'2026-04-29 13:43:47.800017'),(4,'pbkdf2_sha256$1200000$A7lDVf72Mi0k5FvS0iaNPJ$r+4dv9qQ1s9dNtU8OeLFp0i4jHv2RdZ1RGO33OOzA1o=','2026-05-29 11:22:56.225571',0,'Mario_Rossi','','','',0,1,'2026-04-29 14:14:02.671269'),(5,'pbkdf2_sha256$1200000$wnqnypBmqy4CXBsZ9tgUmK$52fmvp+N9/VsxSYxFxopOVcnw9cCAi31QUl8p0MWiHA=','2026-05-29 11:41:41.943041',0,'Marta_Bianchi','','','',0,1,'2026-04-29 14:17:28.789965'),(6,'pbkdf2_sha256$1200000$Af2KCIBXm5TqucR2pMYGcn$drNb66i3Ip0atDq9lyJV3/U3vBQ9XNWp/akFz7ITW1U=','2026-05-29 11:26:50.566110',0,'Gennaro_Esposito','','','',0,1,'2026-04-29 14:22:49.987699'),(7,'pbkdf2_sha256$1200000$FjDoou6s7jlH4Id48vrFx5$TWstZv1e4n4IOhyrJHO3zeVV/BZaLBu2EMQ2xQKOOC0=','2026-05-29 13:10:46.243940',0,'Sofia_Meis','','','',0,1,'2026-04-29 14:26:49.280535'),(8,'pbkdf2_sha256$1200000$26Ozc33YaSD910G4UJMEOG$7pGE+Wpa3H1oXNp1ScqHHSLucikrZTEAa8FKtrQYwIg=','2026-06-02 10:55:36.521890',0,'Giuseppe_Napolitano','','','',0,1,'2026-04-29 14:29:07.018550'),(9,'pbkdf2_sha256$1200000$nfvNIn8obkamrHjwR2GNgI$b5wthFXBd3462ZYDkvmKPs2zyB5GLjqvc7wRxqCWBuY=','2026-04-30 13:57:41.312527',0,'Riccardo_Izzo','','','',0,1,'2026-04-30 13:57:24.399403'),(10,'pbkdf2_sha256$1200000$3AZxfzTudQNYbHPzT8SPi3$c0rmDecB3mWc0RXWM9gYeCIBjr08uiBFGlFOp1NGqP8=','2026-05-27 07:56:12.022607',0,'Felice_Verdi','','','',0,1,'2026-05-23 08:58:56.435567'),(11,'pbkdf2_sha256$1200000$JmsgXO7mwXk72P3oKJlCL9$VsUwZJOmweIKgpPWUzFKLP84CHWfI74erq0spqgeGmk=','2026-05-26 18:46:02.198856',0,'Antonio_Simonetti','','','',0,1,'2026-05-26 18:32:49.658637'),(12,'pbkdf2_sha256$1200000$DAWfFCR46QPFpmiqOWgUi7$qIac3gIAtEubJ0DIBC6slSTOpYOJlB0wgLmjah9NBd4=','2026-05-26 18:44:31.873268',0,'Giovanni_Riccardi','','','',0,1,'2026-05-26 18:44:23.569881');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
INSERT INTO `auth_user_groups` VALUES (1,4,1),(2,5,2),(3,6,3),(4,7,4),(5,8,5),(7,9,1),(8,10,1),(9,11,4),(10,12,5);
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_systemstatus`
--

DROP TABLE IF EXISTS `core_systemstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_systemstatus` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `last_update` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_systemstatus`
--

LOCK TABLES `core_systemstatus` WRITE;
/*!40000 ALTER TABLE `core_systemstatus` DISABLE KEYS */;
INSERT INTO `core_systemstatus` VALUES (1,'2026-05-29 14:10:13.419993');
/*!40000 ALTER TABLE `core_systemstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_userbanchina`
--

DROP TABLE IF EXISTS `core_userbanchina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_userbanchina` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `numero_banchina` int NOT NULL,
  `settore_banchina` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_userbanchina_user_id_numero_banchina__08d61bb5_uniq` (`user_id`,`numero_banchina`,`settore_banchina`),
  CONSTRAINT `core_userbanchina_user_id_f5d7e901_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_userbanchina`
--

LOCK TABLES `core_userbanchina` WRITE;
/*!40000 ALTER TABLE `core_userbanchina` DISABLE KEYS */;
INSERT INTO `core_userbanchina` VALUES (1,1,1,6),(5,5,1,6),(3,5,2,6),(4,6,10,6),(2,67,420,6);
/*!40000 ALTER TABLE `core_userbanchina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_usercliente`
--

DROP TABLE IF EXISTS `core_usercliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_usercliente` (
  `user_id` int NOT NULL,
  `cliente_id` varchar(16) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `cliente_id` (`cliente_id`),
  CONSTRAINT `core_usercliente_cliente_id_278ff5ff_fk_Cliente_Codice_fiscale` FOREIGN KEY (`cliente_id`) REFERENCES `Cliente` (`Codice_fiscale`),
  CONSTRAINT `core_usercliente_user_id_9a2be87a_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_usercliente`
--

LOCK TABLES `core_usercliente` WRITE;
/*!40000 ALTER TABLE `core_usercliente` DISABLE KEYS */;
INSERT INTO `core_usercliente` VALUES (4,'RSSMRA80A01H501U'),(10,'VRDFLC00C05F839I'),(9,'ZZIRCR05S15I391G');
/*!40000 ALTER TABLE `core_usercliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_userguida`
--

DROP TABLE IF EXISTS `core_userguida`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_userguida` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `guida_id` varchar(16) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_userguida_user_id_guida_id_8e93a372_uniq` (`user_id`,`guida_id`),
  KEY `core_userguida_guida_id_534099e9_fk_Guida_Codice_fiscale` (`guida_id`),
  CONSTRAINT `core_userguida_guida_id_534099e9_fk_Guida_Codice_fiscale` FOREIGN KEY (`guida_id`) REFERENCES `Guida` (`Codice_fiscale`),
  CONSTRAINT `core_userguida_user_id_6ce0ff78_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_userguida`
--

LOCK TABLES `core_userguida` WRITE;
/*!40000 ALTER TABLE `core_userguida` DISABLE KEYS */;
INSERT INTO `core_userguida` VALUES (8,'BNCGLI88D55H501V',7),(2,'BNHGLI92L65F205V',7),(13,'ESPDVD81T05F839W',7),(10,'FRRLNE92P60G224S',7),(6,'FRRRCR88P30F205L',7),(11,'MRTLCA85E20C351D',7),(7,'RCCSFO95E54L219K',7),(5,'RMNFNC00A58H501Y',7),(12,'RMNSRA95L48H501Z',7),(9,'RSSMRC79M10F205A',7),(1,'RSSMRC85C12H501Z',7),(4,'SPSLSN78S05A662O',7);
/*!40000 ALTER TABLE `core_userguida` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_useritinerario`
--

DROP TABLE IF EXISTS `core_useritinerario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_useritinerario` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `itinerario_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_useritinerario_user_id_itinerario_id_54563096_uniq` (`user_id`,`itinerario_id`),
  KEY `core_useritinerario_itinerario_id_1632c716_fk_Itinerario_ID` (`itinerario_id`),
  CONSTRAINT `core_useritinerario_itinerario_id_1632c716_fk_Itinerario_ID` FOREIGN KEY (`itinerario_id`) REFERENCES `Itinerario` (`ID`),
  CONSTRAINT `core_useritinerario_user_id_42d6cd7f_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_useritinerario`
--

LOCK TABLES `core_useritinerario` WRITE;
/*!40000 ALTER TABLE `core_useritinerario` DISABLE KEYS */;
INSERT INTO `core_useritinerario` VALUES (1,2,7),(2,3,7),(4,5,7);
/*!40000 ALTER TABLE `core_useritinerario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_usermagazzino`
--

DROP TABLE IF EXISTS `core_usermagazzino`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_usermagazzino` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nome_magazzino` varchar(100) NOT NULL,
  `localita_magazzino` varchar(100) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `core_usermagazzino_user_id_nome_magazzino_l_6328bec2_uniq` (`user_id`,`nome_magazzino`,`localita_magazzino`),
  CONSTRAINT `core_usermagazzino_user_id_87f7fc84_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_usermagazzino`
--

LOCK TABLES `core_usermagazzino` WRITE;
/*!40000 ALTER TABLE `core_usermagazzino` DISABLE KEYS */;
INSERT INTO `core_usermagazzino` VALUES (1,'SyncLink','Napoli',5),(4,'Walmart','Pretoria',5),(3,'Warehouse','Punta Arenas',5);
/*!40000 ALTER TABLE `core_usermagazzino` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `core_usernave`
--

DROP TABLE IF EXISTS `core_usernave`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `core_usernave` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nave_id` varchar(7) NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `core_usernave`
--

LOCK TABLES `core_usernave` WRITE;
/*!40000 ALTER TABLE `core_usernave` DISABLE KEYS */;
INSERT INTO `core_usernave` VALUES (1,'9837420',7),(3,'8717647',8),(5,'9358060',8),(6,'9387085',7),(7,'9224336',8),(8,'9214513',8),(9,'9280627',8),(12,'9751511',11),(13,'9818709',11),(14,'9930038',12),(16,'9781889',11),(17,'9829930',11);
/*!40000 ALTER TABLE `core_usernave` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2026-04-29 13:46:18.071128','1','cliente',1,'[{\"added\": {}}]',2,3),(2,'2026-04-29 13:47:30.253222','2','gestore_magazzino',1,'[{\"added\": {}}]',2,3),(3,'2026-04-29 13:50:04.945980','3','gestore_attracco_navi',1,'[{\"added\": {}}]',2,3),(4,'2026-04-29 13:52:04.012949','4','gestore_navi_crociera',1,'[{\"added\": {}}]',2,3),(5,'2026-04-29 13:53:04.768528','5','gestore_navi_cargo',1,'[{\"added\": {}}]',2,3),(6,'2026-04-29 14:10:38.949928','2','boh',3,'',4,3),(7,'2026-04-29 14:12:03.734118','1','haley',2,'[{\"changed\": {\"fields\": [\"password\"]}}]',4,3),(8,'2026-04-29 14:12:21.409844','1','haley',2,'[{\"changed\": {\"fields\": [\"Superuser status\"]}}]',4,3),(9,'2026-04-29 14:57:43.249463','6','admin',1,'[{\"added\": {}}]',2,3),(10,'2026-04-29 14:58:27.438948','1','haley',2,'[{\"changed\": {\"fields\": [\"Staff status\", \"Groups\"]}}]',4,3),(11,'2026-04-30 13:47:36.359438','6','admin',3,'',2,1),(12,'2026-05-23 11:13:34.544161','1','every hour',1,'[{\"added\": {}}]',30,3),(13,'2026-05-23 11:13:54.122545','2','Aggiorna navi ogni ora: every hour',1,'[{\"added\": {}}]',31,3);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_clockedschedule`
--

DROP TABLE IF EXISTS `django_celery_beat_clockedschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_clockedschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `clocked_time` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_clockedschedule`
--

LOCK TABLES `django_celery_beat_clockedschedule` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_clockedschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_celery_beat_clockedschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_crontabschedule`
--

DROP TABLE IF EXISTS `django_celery_beat_crontabschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_crontabschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `minute` varchar(240) NOT NULL,
  `hour` varchar(96) NOT NULL,
  `day_of_week` varchar(64) NOT NULL,
  `day_of_month` varchar(124) NOT NULL,
  `month_of_year` varchar(64) NOT NULL,
  `timezone` varchar(63) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_crontabschedule`
--

LOCK TABLES `django_celery_beat_crontabschedule` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_crontabschedule` DISABLE KEYS */;
INSERT INTO `django_celery_beat_crontabschedule` VALUES (1,'0','4','*','*','*','UTC');
/*!40000 ALTER TABLE `django_celery_beat_crontabschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_intervalschedule`
--

DROP TABLE IF EXISTS `django_celery_beat_intervalschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_intervalschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `every` int NOT NULL,
  `period` varchar(24) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_intervalschedule`
--

LOCK TABLES `django_celery_beat_intervalschedule` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_intervalschedule` DISABLE KEYS */;
INSERT INTO `django_celery_beat_intervalschedule` VALUES (1,1,'hours');
/*!40000 ALTER TABLE `django_celery_beat_intervalschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_periodictask`
--

DROP TABLE IF EXISTS `django_celery_beat_periodictask`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_periodictask` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `task` varchar(200) NOT NULL,
  `args` longtext NOT NULL,
  `kwargs` longtext NOT NULL,
  `queue` varchar(200) DEFAULT NULL,
  `exchange` varchar(200) DEFAULT NULL,
  `routing_key` varchar(200) DEFAULT NULL,
  `expires` datetime(6) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `last_run_at` datetime(6) DEFAULT NULL,
  `total_run_count` int unsigned NOT NULL,
  `date_changed` datetime(6) NOT NULL,
  `description` longtext NOT NULL,
  `crontab_id` int DEFAULT NULL,
  `interval_id` int DEFAULT NULL,
  `solar_id` int DEFAULT NULL,
  `one_off` tinyint(1) NOT NULL,
  `start_time` datetime(6) DEFAULT NULL,
  `priority` int unsigned DEFAULT NULL,
  `headers` longtext NOT NULL DEFAULT (_utf8mb4'{}'),
  `clocked_id` int DEFAULT NULL,
  `expire_seconds` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce` (`crontab_id`),
  KEY `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce` (`interval_id`),
  KEY `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce` (`solar_id`),
  KEY `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce` (`clocked_id`),
  CONSTRAINT `django_celery_beat_p_clocked_id_47a69f82_fk_django_ce` FOREIGN KEY (`clocked_id`) REFERENCES `django_celery_beat_clockedschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_crontab_id_d3cba168_fk_django_ce` FOREIGN KEY (`crontab_id`) REFERENCES `django_celery_beat_crontabschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_interval_id_a8ca27da_fk_django_ce` FOREIGN KEY (`interval_id`) REFERENCES `django_celery_beat_intervalschedule` (`id`),
  CONSTRAINT `django_celery_beat_p_solar_id_a87ce72c_fk_django_ce` FOREIGN KEY (`solar_id`) REFERENCES `django_celery_beat_solarschedule` (`id`),
  CONSTRAINT `django_celery_beat_periodictask_chk_1` CHECK ((`total_run_count` >= 0)),
  CONSTRAINT `django_celery_beat_periodictask_chk_2` CHECK ((`priority` >= 0)),
  CONSTRAINT `django_celery_beat_periodictask_chk_3` CHECK ((`expire_seconds` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_periodictask`
--

LOCK TABLES `django_celery_beat_periodictask` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_periodictask` DISABLE KEYS */;
INSERT INTO `django_celery_beat_periodictask` VALUES (1,'celery.backend_cleanup','celery.backend_cleanup','[]','{}',NULL,NULL,NULL,NULL,1,NULL,0,'2026-06-02 10:54:52.703503','',1,NULL,NULL,0,NULL,NULL,'{}',NULL,43200),(2,'Aggiorna navi ogni ora','porto.tasks.aggiorna_posizioni_navi','[]','{}',NULL,NULL,NULL,NULL,1,'2026-06-02 10:54:52.712618',17,'2026-06-02 10:54:52.837037','',NULL,1,NULL,0,NULL,NULL,'{}',NULL,NULL);
/*!40000 ALTER TABLE `django_celery_beat_periodictask` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_periodictasks`
--

DROP TABLE IF EXISTS `django_celery_beat_periodictasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_periodictasks` (
  `ident` smallint NOT NULL,
  `last_update` datetime(6) NOT NULL,
  PRIMARY KEY (`ident`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_periodictasks`
--

LOCK TABLES `django_celery_beat_periodictasks` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_periodictasks` DISABLE KEYS */;
INSERT INTO `django_celery_beat_periodictasks` VALUES (1,'2026-06-02 10:54:52.703913');
/*!40000 ALTER TABLE `django_celery_beat_periodictasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_celery_beat_solarschedule`
--

DROP TABLE IF EXISTS `django_celery_beat_solarschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_celery_beat_solarschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `event` varchar(24) NOT NULL,
  `latitude` decimal(9,6) NOT NULL,
  `longitude` decimal(9,6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq` (`event`,`latitude`,`longitude`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_celery_beat_solarschedule`
--

LOCK TABLES `django_celery_beat_solarschedule` WRITE;
/*!40000 ALTER TABLE `django_celery_beat_solarschedule` DISABLE KEYS */;
/*!40000 ALTER TABLE `django_celery_beat_solarschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(2,'auth','group'),(3,'auth','permission'),(4,'auth','user'),(5,'contenttypes','contenttype'),(7,'core','banchina'),(8,'core','cliente'),(9,'core','container'),(10,'core','guida'),(11,'core','itinerario'),(12,'core','lingueguida'),(13,'core','magazzino'),(14,'core','merce'),(15,'core','nave'),(16,'core','prenotazione'),(17,'core','stanza'),(18,'core','stoccaggio'),(26,'core','storicoprenotazione'),(34,'core','systemstatus'),(19,'core','tappeitinerario'),(27,'core','tappeprenotazione'),(20,'core','userbanchina'),(21,'core','usercliente'),(24,'core','userguida'),(25,'core','useritinerario'),(22,'core','usermagazzino'),(23,'core','usernave'),(28,'django_celery_beat','clockedschedule'),(29,'django_celery_beat','crontabschedule'),(30,'django_celery_beat','intervalschedule'),(31,'django_celery_beat','periodictask'),(32,'django_celery_beat','periodictasks'),(33,'django_celery_beat','solarschedule'),(6,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2026-04-28 14:03:51.577655'),(2,'auth','0001_initial','2026-04-28 14:03:52.113741'),(3,'admin','0001_initial','2026-04-28 14:03:52.230777'),(4,'admin','0002_logentry_remove_auto_add','2026-04-28 14:03:52.237987'),(5,'admin','0003_logentry_add_action_flag_choices','2026-04-28 14:03:52.245839'),(6,'contenttypes','0002_remove_content_type_name','2026-04-28 14:03:52.322094'),(7,'auth','0002_alter_permission_name_max_length','2026-04-28 14:03:52.372661'),(8,'auth','0003_alter_user_email_max_length','2026-04-28 14:03:52.391953'),(9,'auth','0004_alter_user_username_opts','2026-04-28 14:03:52.398284'),(10,'auth','0005_alter_user_last_login_null','2026-04-28 14:03:52.442863'),(11,'auth','0006_require_contenttypes_0002','2026-04-28 14:03:52.446535'),(12,'auth','0007_alter_validators_add_error_messages','2026-04-28 14:03:52.454684'),(13,'auth','0008_alter_user_username_max_length','2026-04-28 14:03:52.503455'),(14,'auth','0009_alter_user_last_name_max_length','2026-04-28 14:03:52.554906'),(15,'auth','0010_alter_group_name_max_length','2026-04-28 14:03:52.571883'),(16,'auth','0011_update_proxy_permissions','2026-04-28 14:03:52.581581'),(17,'auth','0012_alter_user_first_name_max_length','2026-04-28 14:03:52.634150'),(18,'core','0001_initial','2026-04-28 14:03:52.659114'),(19,'sessions','0001_initial','2026-04-28 14:03:52.811732'),(20,'core','0002_usercliente_userbanchina_usermagazzino_usernave','2026-04-30 11:19:19.987839'),(21,'core','0003_alter_userbanchina_unique_together_and_more','2026-04-30 11:19:19.997429'),(22,'core','0003_userbanchina_usermagazzino','2026-05-02 13:30:23.232735'),(23,'core','0002_usercliente_usernave','2026-05-02 14:29:07.229676'),(24,'core','0003_alter_banchina_options_alter_lingueguida_options_and_more','2026-05-02 14:29:07.271667'),(25,'core','0004_alter_nave_options','2026-05-03 11:57:25.514277'),(26,'core','0005_alter_merce_options','2026-05-05 13:33:02.386908'),(27,'core','0006_alter_stoccaggio_options','2026-05-06 15:29:45.119974'),(28,'core','0007_userguida_useritinerario','2026-05-07 15:23:04.827745'),(29,'core','0008_alter_prenotazione_options','2026-05-08 13:42:40.910484'),(30,'core','0009_storicoprenotazione','2026-05-23 08:18:30.388874'),(31,'core','0010_remove_storicoprenotazione_tappe_tappeprenotazione','2026-05-23 08:22:23.178627'),(32,'core','0011_remove_storicoprenotazione_numero_and_more','2026-05-23 08:35:51.217153'),(33,'core','0009_alter_cliente_options_alter_container_options_and_more','2026-05-23 08:45:49.645572'),(34,'django_celery_beat','0001_initial','2026-05-23 10:25:48.078718'),(35,'django_celery_beat','0002_auto_20161118_0346','2026-05-23 10:25:48.164997'),(36,'django_celery_beat','0003_auto_20161209_0049','2026-05-23 10:25:48.187329'),(37,'django_celery_beat','0004_auto_20170221_0000','2026-05-23 10:25:48.191229'),(38,'django_celery_beat','0005_add_solarschedule_events_choices','2026-05-23 10:25:48.194468'),(39,'django_celery_beat','0006_auto_20180322_0932','2026-05-23 10:25:48.267844'),(40,'django_celery_beat','0007_auto_20180521_0826','2026-05-23 10:25:48.356419'),(41,'django_celery_beat','0008_auto_20180914_1922','2026-05-23 10:25:48.373506'),(42,'django_celery_beat','0006_auto_20180210_1226','2026-05-23 10:25:48.385866'),(43,'django_celery_beat','0006_periodictask_priority','2026-05-23 10:25:48.443523'),(44,'django_celery_beat','0009_periodictask_headers','2026-05-23 10:25:48.501341'),(45,'django_celery_beat','0010_auto_20190429_0326','2026-05-23 10:25:48.588521'),(46,'django_celery_beat','0011_auto_20190508_0153','2026-05-23 10:25:48.665968'),(47,'django_celery_beat','0012_periodictask_expire_seconds','2026-05-23 10:25:48.728019'),(48,'django_celery_beat','0013_auto_20200609_0727','2026-05-23 10:25:48.736993'),(49,'django_celery_beat','0014_remove_clockedschedule_enabled','2026-05-23 10:25:48.764290'),(50,'django_celery_beat','0015_edit_solarschedule_events_choices','2026-05-23 10:25:48.768940'),(51,'django_celery_beat','0016_alter_crontabschedule_timezone','2026-05-23 10:25:48.775400'),(52,'django_celery_beat','0017_alter_crontabschedule_month_of_year','2026-05-23 10:25:48.780834'),(53,'django_celery_beat','0018_improve_crontab_helptext','2026-05-23 10:25:48.786068'),(54,'django_celery_beat','0019_alter_periodictasks_options','2026-05-23 10:25:48.790727'),(55,'core','0010_systemstatus','2026-05-23 11:46:16.611063'),(56,'core','0011_alter_systemstatus_table','2026-05-23 12:58:50.213879');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('b044x7aj4bqek0mmr8kjgjb012x84pjo','.eJxVjEEOwiAQRe_C2hCm0gFduvcMZJgBqRpISrsy3l2bdKHb_977LxVoXUpYe5rDJOqsRnX43SLxI9UNyJ3qrWludZmnqDdF77Tra5P0vOzu30GhXr61y2AkR4Ojc-4IFjFDGoBQTgLIYmiI5BFBRJgAk4C1mBx7xizWq_cH4TY4NA:1wS9Ba:vIso8LO4Mz9HkXEU3YtGLsmFf_wZ_chKOHHY08Exp8o','2026-06-10 08:00:18.915638'),('b6a2zlaj1xtq3elcol4bbilgpwt1l5lz','.eJxVjMsOwiAQRf-FtSEFZni4dO83EIahUjU0Ke3K-O_apAvd3nPOfYmYtrXGrZclTizOwonT70YpP0rbAd9Tu80yz21dJpK7Ig_a5XXm8rwc7t9BTb1-a3DKAGVtMQFbYD2yJsPeeIQh-4LshgBFUXaggx0VqKARAykMYCCJ9wfJ0ja9:1wS99l:spdodx8L5PZewZqDLY7ltWF0g9XCpDaeHQxgUIGnhkU','2026-06-10 07:58:25.290734'),('daph71vcyg8lldhgeh1w9j3c5gb7veuq','.eJxVjMsOwiAUBf-FtSFwwZa6dO83EO6jUjWQlHZl_HfbpAvdnpk5bxXTuuS4NpnjxOqizur0u2Gip5Qd8COVe9VUyzJPqHdFH7TpW2V5XQ_37yCnlre6Hz07TCidZRRGhC704IEAafDJOQOIlvymGDaDEwoiJDCCWIDA6vMFGBc5Lw:1wKg28:4rlgECotWhOSSySG8vt-aF1g5o7eTePNspO9MCQFZDY','2026-05-20 17:27:40.900372'),('e2mns62csx0dv6s1ff37ys6rugtdujhq','.eJxVjDsOwjAQRO_iGln2sv5R0nMGa21vcAA5UpxUiLuTSCmgG817M28RaV1qXDvPcSziIrw4_XaJ8pPbDsqD2n2SeWrLPCa5K_KgXd6mwq_r4f4dVOp1W2vrdCbgYA1bhGICwtmn4lEpxZa941ScH9AAMuGWMqEeAmR2GQHF5wvOjjeL:1wNFOv:vkz36IYPFWY-U3Pv4SGkHQcZZ8ZxERYgVCTJn-mpjl4','2026-05-27 19:37:49.770016'),('foxznw7kzmzm6fw68wcelr1r0pcszlc4','.eJxVjMsOwiAUBf-FtSFwwZa6dO83EO6jUjWQlHZl_HfbpAvdnpk5bxXTuuS4NpnjxOqizur0u2Gip5Qd8COVe9VUyzJPqHdFH7TpW2V5XQ_37yCnlre6Hz07TCidZRRGhC704IEAafDJOQOIlvymGDaDEwoiJDCCWIDA6vMFGBc5Lw:1wKg4a:hjZqgjrHixvNEI0V2NM47TZTlw9BT-nvIaAT863vXAk','2026-05-20 17:30:12.611010'),('jjgdiopld8q2rli1xzju09curnmkh1h1','.eJxVjEEOwiAQRe_C2hCm0gFduvcMZJgBqRpISrsy3l2bdKHb_977LxVoXUpYe5rDJOqsRnX43SLxI9UNyJ3qrWludZmnqDdF77Tra5P0vOzu30GhXr61y2AkR4Ojc-4IFjFDGoBQTgLIYmiI5BFBRJgAk4C1mBx7xizWq_cH4TY4NA:1wS9Ca:hGdklWnuNPQ1oiTIjVbk8hJcFjLTXhuIhdHrquOiIc0','2026-06-10 08:01:20.375147'),('jxzneztxexxu5dkreogbd7e3fgt52zj4','.eJxVjMsOwiAQRf-FtSEMDwGX7v0GMjAgVQNJaVfGf7dNutDtPefcNwu4LjWsI89hInZhip1-t4jpmdsO6IHt3nnqbZmnyHeFH3TwW6f8uh7u30HFUbfagS8in4UFh1AsCuW1gELWSBMRvDQepEsaJBRtvE06qigAZUlEm8Y-X7WCNzY:1wLFhU:3nzyOb5WrZU2VuCEYWrihMUa4NXSWTdQ4BVKxQRyLi8','2026-05-22 07:32:44.373167'),('l9fgm26txlqoxsrxydgrs6ax2z6j9hre','e30:1wI6Kj:7A9xvNIL6c4LcudZ5eUj2D4llbEcmWhUKo4MtTgp6M8','2026-05-13 14:56:13.863914'),('m1b9jrdzaw2puxun771nxm2mpep4wcjv','.eJxVjMsOwiAQRf-FtSEMlJdL934DGWCQqoGktCvjv2uTLnR7zzn3xQJuaw3boCXMmZ0ZCHb6HSOmB7Wd5Du2W-ept3WZI98VftDBrz3T83K4fwcVR_3WiMZ5G5UvNoMqxVtN0Uir0TshJDkbJyCHIKPQKZOcQIDJpTgrQSrP3h__fzd9:1wS97c:tGw5Onv_5XzVWoP3jn_2xH3AjKYlLHsR4q44mjrHdLA','2026-06-10 07:56:12.028822'),('olbdr9h4snwlrxet34g1b1zmfyzlcs4z','e30:1wJTeT:mH9_FLNAkISidkfcRxyENKZNAZjm2Qkg09k3GmmIvlg','2026-05-17 10:02:17.961696'),('p3dpdywduzvmqgi1sadc6i8sqdyhrbft','.eJxVjMsOwiAQRf-FtSHDG1y69xvIAKNUDSSlXRn_3TbpQrf3nHPfLOK61LgOmuNU2JlpdvrdEuYntR2UB7Z757m3ZZ4S3xV-0MGvvdDrcrh_BxVH3WoppTEqkBbZJYXKQfDSAlpKCVy2gtINvYdSlCYZrAKPebM8GFAgPPt8Ab78Np8:1wS9Bk:oIBr7yww5lPA-FSkf2WQK377A6Px5yBgyDbBRuDqOQI','2026-06-10 08:00:28.449943'),('sbdbiv2c34erxqv1bt5je22xmdkkhbkn','.eJxVjDsOwyAQBe9CHSFjtHxSps8ZELsLwUmEJWNXVu4eLLlI2pl5bxchbmsJW0tLmFhchRGXX4aRXqkegp-xPmZJc12XCeWRyNM2eZ85vW9n-3dQYit9bRMZhTHToLT1dkSGkdEa5yg6cAgeySmDGlArJq-hB6kjUHrImcXnC-7POAs:1wQjLV:TNttII-Dbohppel13Q-RWrou56yFnKq48ThPv019UI8','2026-06-06 10:12:41.631459'),('y9ibiozm05v1tx7o8n4gur8uavayeo2r','.eJxVjEsOwjAMBe-SNYri9BOHJXvOUNmxQwqolZp2hbg7VOoCtm9m3ssMtK1l2KouwyjmbII5_W5M6aHTDuRO0222aZ7WZWS7K_ag1V5n0eflcP8OCtXyrTm6VoUdihffe8zUBddAiom7HmIiykgASdn1zJkBtUFswYcGRATN-wP2_jhX:1wIjCA:LH8JjGmTDUOB8GCcfAMWamqW4unXaxmis2b_5xGkYcQ','2026-05-15 08:25:58.964166'),('yw3kpyhdbk2c814pxys7ozc7kjef22lk','.eJxVjMsOwiAQRf-FtSHDG1y69xvIAKNUDSSlXRn_3TbpQrf3nHPfLOK61LgOmuNU2JlpdvrdEuYntR2UB7Z757m3ZZ4S3xV-0MGvvdDrcrh_BxVH3WoppTEqkBbZJYXKQfDSAlpKCVy2gtINvYdSlCYZrAKPebM8GFAgPPt8Ab78Np8:1wS922:BjHGpcSBsJA9icMOm9SJ5c03jBamVGp1-c1_u2uTqnI','2026-06-10 07:50:26.695477'),('zua3rvmkgod6b83m7dtxg7ph1k8ekku8','.eJxVjEEOwiAQRe_C2hCm0gFduvcMZJgBqRpISrsy3l2bdKHb_977LxVoXUpYe5rDJOqsRnX43SLxI9UNyJ3qrWludZmnqDdF77Tra5P0vOzu30GhXr61y2AkR4Ojc-4IFjFDGoBQTgLIYmiI5BFBRJgAk4C1mBx7xizWq_cH4TY4NA:1wS94I:eKvqXmYOTmldkMcI6f9AOJhZKPR3X4dcqQlep_e3yq8','2026-06-10 07:52:46.745269');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
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

-- Dump completed on 2026-06-04 11:11:33
