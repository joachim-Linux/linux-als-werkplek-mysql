CREATE SCHEMA IF NOT EXISTS `Ziekenhuis_DB` DEFAULT CHARACTER SET utf8 ;
USE `Ziekenhuis_DB` ;

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Afdeling` (
  `afdelingnaam` varchar(50) NOT NULL,
  PRIMARY KEY (`afdelingnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `AfdelingTeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AfdelingTeam` (
  `teamnaam` varchar(25) NOT NULL,
  `afdeling` varchar(50) NOT NULL,
  PRIMARY KEY (`teamnaam`,`afdeling`),
  KEY `AfdelingTeam_FK` (`afdeling`),
  CONSTRAINT `AfdelingTeam_FK` FOREIGN KEY (`afdeling`) REFERENCES `Afdeling` (`afdelingnaam`),
  CONSTRAINT `AfdelingTeam_FK_1` FOREIGN KEY (`teamnaam`) REFERENCES `Team` (`teamnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Afspraak`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Afspraak` (
  `begindatumtijd` datetime NOT NULL,
  `einddatumtijd` datetime DEFAULT NULL,
  `soortafspraak` varchar(100) DEFAULT NULL,
  `statusafspraak` varchar(100) DEFAULT NULL,
  `arts` int(11) NOT NULL,
  `patient` int(9) NOT NULL,
  PRIMARY KEY (`begindatumtijd`,`arts`,`patient`),
  KEY `Afspraak_FK` (`arts`),
  KEY `Afspraak_FK_1` (`patient`),
  CONSTRAINT `Afspraak_FK` FOREIGN KEY (`arts`) REFERENCES `Arts` (`bigcode`),
  CONSTRAINT `Afspraak_FK_1` FOREIGN KEY (`patient`) REFERENCES `Patient` (`bsn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Arts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Arts` (
  `bigcode` int(11) NOT NULL,
  `voornaam` varchar(45) DEFAULT NULL,
  `tussenvoegsel` varchar(10) DEFAULT NULL,
  `achternaam` varchar(50) DEFAULT NULL,
  `team` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`bigcode`),
  KEY `Arts_FK` (`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `ArtsSpecialisatie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ArtsSpecialisatie` (
  `arts` int(11) NOT NULL,
  `specialisatie` varchar(40) NOT NULL,
  `specialisatieniveau` varchar(25) NOT NULL,
  PRIMARY KEY (`arts`,`specialisatie`,`specialisatieniveau`),
  KEY `ArtsSpecialisatie_FK_1` (`specialisatie`,`specialisatieniveau`),
  CONSTRAINT `ArtsSpecialisatie_FK` FOREIGN KEY (`arts`) REFERENCES `Arts` (`bigcode`),
  CONSTRAINT `ArtsSpecialisatie_FK_1` FOREIGN KEY (`specialisatie`, `specialisatieniveau`) REFERENCES `Specialisatie` (`specialisatienaam`, `specialisatieniveau`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Dossier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Dossier` (
  `dossiernr` bigint(20) NOT NULL AUTO_INCREMENT,
  `patient` int(9) NOT NULL,
  `ziektecasus` varchar(100) DEFAULT NULL,
  `Verantwoordelijke_arts` int(11) NOT NULL,
  PRIMARY KEY (`dossiernr`),
  KEY `Dossier_FK` (`patient`),
  KEY `Dossier_FK_1` (`Verantwoordelijke_arts`),
  CONSTRAINT `Dossier_FK` FOREIGN KEY (`patient`) REFERENCES `Patient` (`bsn`),
  CONSTRAINT `Dossier_FK_1` FOREIGN KEY (`Verantwoordelijke_arts`) REFERENCES `Arts` (`bigcode`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Kamer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Kamer` (
  `kamernr` int(11) NOT NULL,
  `afdeling` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kamernr`),
  KEY `Kamer_FK` (`afdeling`),
  CONSTRAINT `Kamer_FK` FOREIGN KEY (`afdeling`) REFERENCES `Afdeling` (`afdelingnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Opname`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Opname` (
  `opnamedatumtijd` datetime NOT NULL,
  `ontslagdatum` datetime DEFAULT NULL,
  `dossiernr` bigint(20) NOT NULL,
  `kamernr` int(11) DEFAULT NULL,
  `afdeling` varchar(50) NOT NULL,
  PRIMARY KEY (`opnamedatumtijd`,`dossiernr`,`afdeling`),
  KEY `Opname_FK` (`dossiernr`),
  KEY `Opname_FK_1` (`afdeling`),
  KEY `Opname_FK_2` (`kamernr`),
  CONSTRAINT `Opname_FK` FOREIGN KEY (`dossiernr`) REFERENCES `Dossier` (`dossiernr`),
  CONSTRAINT `Opname_FK_1` FOREIGN KEY (`afdeling`) REFERENCES `Afdeling` (`afdelingnaam`),
  CONSTRAINT `Opname_FK_2` FOREIGN KEY (`kamernr`) REFERENCES `Kamer` (`kamernr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Patient` (
  `bsn` int(9) NOT NULL,
  `voornaam` varchar(45) DEFAULT NULL,
  `tussenvoegsel` varchar(10) DEFAULT NULL,
  `achternaam` varchar(50) DEFAULT NULL,
  `geboortedatum` date DEFAULT NULL,
  `geslacht` char(1) DEFAULT NULL,
  `nationaliteit` varchar(60) DEFAULT NULL,
  `woonplaats` varchar(40) DEFAULT NULL,
  `postcode` varchar(6) DEFAULT NULL,
  `huisnr` int(11) DEFAULT NULL,
  `huisnr_toevoeging` varchar(10) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefoonnr` varchar(11) DEFAULT NULL,
  `verzekering` varchar(50) NOT NULL DEFAULT 'niet bekend',
  PRIMARY KEY (`bsn`),
  KEY `Patient_FK` (`verzekering`),
  CONSTRAINT `Patient_FK` FOREIGN KEY (`verzekering`) REFERENCES `Verzekering` (`verzekeringnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Specialisatie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Specialisatie` (
  `specialisatienaam` varchar(40) NOT NULL,
  `specialisatieniveau` varchar(25) NOT NULL,
  PRIMARY KEY (`specialisatienaam`,`specialisatieniveau`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Team` (
  `teamnaam` varchar(25) NOT NULL,
  PRIMARY KEY (`teamnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Teamlidmaatschap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Teamlidmaatschap` (
  `teamnaam` varchar(25) NOT NULL,
  `arts` int(11) NOT NULL,
  PRIMARY KEY (`teamnaam`,`arts`),
  KEY `Teamlidmaatschap_FK` (`arts`),
  CONSTRAINT `Teamlidmaatschap_FK` FOREIGN KEY (`arts`) REFERENCES `Arts` (`bigcode`),
  CONSTRAINT `Teamlidmaatschap_FK_1` FOREIGN KEY (`teamnaam`) REFERENCES `Team` (`teamnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

DROP TABLE IF EXISTS `Verzekering`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Verzekering` (
  `verzekeringnaam` varchar(50) NOT NULL,
  PRIMARY KEY (`verzekeringnaam`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
