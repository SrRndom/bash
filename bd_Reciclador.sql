-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: reciclador_local
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `configuraciones`
--

DROP TABLE IF EXISTS `configuraciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `configuraciones` (
  `id_configuracion` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `valor` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id_configuracion`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `configuraciones`
--

LOCK TABLES `configuraciones` WRITE;
/*!40000 ALTER TABLE `configuraciones` DISABLE KEYS */;
INSERT INTO `configuraciones` VALUES (1,'TOKEN','eyJhbGciOiJIUzI1NiJ9.eyJVc2VyIjoidU5IVUlyWTgiLCJOYW1lIjoiUmVjaWNsYWRvciAyMTAiLCJVVUlEIjoiRDA2NkI4RjgiLCJzdWIiOiIxMSIsImp0aSI6IjYzZjhjMDQyLTE1MjYtNGJmNy04NjQ2LTNlMGY1YWZlNDBjMiIsImlhdCI6MTY2MzEwMDU2MSwiZXhwIjoxNjYzMTAxNDYxfQ.j8OCYfpnYcXeMzx0rX3yAz-SVJT98zp2q5veH6ESvZM'),(2,'TOKEN_COMANDO','eyJhbGciOiJIUzI1NiJ9.eyJVc2VyIjoiNmJmU2ZicTAiLCJOYW1lIjoiUmVjaWNsYWRvciAyMzEiLCJVVUlEIjoiRUI5QjNFQTciLCJzdWIiOiIxNiIsImp0aSI6ImMzNjA1NWUxLWMyNmQtNDE1NS1iZTgxLWM3OGU0MWZmOGMxMSIsImlhdCI6MTY2NDQ3OTc0MiwiZXhwIjoxNjY0NDgwNjQyfQ.WEMQ4Xzk_7TJ-txotnMzgHz3qAqpD01c3a1lPWyU-BE'),(3,'IP','http://localhost:8080/Reciclador-API/'),(4,'EMAIL','T2NrAYXH'),(5,'PASSWORD','rRHYpf9Auw0MKPXX'),(6,'reciclador_UUID','43B1C1A5');
/*!40000 ALTER TABLE `configuraciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contenedor_model`
--

DROP TABLE IF EXISTS `contenedor_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contenedor_model` (
  `id_contenedor_model` int NOT NULL AUTO_INCREMENT,
  `id_reciclador` varchar(50) DEFAULT NULL,
  `id_contenedor` int NOT NULL,
  `porcentaje_llenado` int NOT NULL,
  PRIMARY KEY (`id_contenedor_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contenedor_model`
--

LOCK TABLES `contenedor_model` WRITE;
/*!40000 ALTER TABLE `contenedor_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `contenedor_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `error_model`
--

DROP TABLE IF EXISTS `error_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `error_model` (
  `id_error_model` int NOT NULL AUTO_INCREMENT,
  `id_reciclador` varchar(50) DEFAULT NULL,
  `tipo_error` int NOT NULL,
  PRIMARY KEY (`id_error_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `error_model`
--

LOCK TABLES `error_model` WRITE;
/*!40000 ALTER TABLE `error_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `error_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saldo_model`
--

DROP TABLE IF EXISTS `saldo_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saldo_model` (
  `id_saldo_model` int NOT NULL AUTO_INCREMENT,
  `tarjeta_uuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id_saldo_model`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saldo_model`
--

LOCK TABLES `saldo_model` WRITE;
/*!40000 ALTER TABLE `saldo_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `saldo_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `submovimiento_model`
--

DROP TABLE IF EXISTS `submovimiento_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `submovimiento_model` (
  `id_submovimiento_model` int NOT NULL AUTO_INCREMENT,
  `id_saldo_model` int DEFAULT NULL,
  `reciclador_uuid` varchar(50) DEFAULT NULL,
  `material_id` int NOT NULL,
  `submovimiento_total_kg` float NOT NULL,
  PRIMARY KEY (`id_submovimiento_model`),
  KEY `id_saldo_model` (`id_saldo_model`),
  CONSTRAINT `submovimiento_model_ibfk_1` FOREIGN KEY (`id_saldo_model`) REFERENCES `saldo_model` (`id_saldo_model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `submovimiento_model`
--

LOCK TABLES `submovimiento_model` WRITE;
/*!40000 ALTER TABLE `submovimiento_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `submovimiento_model` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-10-07 15:27:38
