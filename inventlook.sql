-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: inventlook
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(50) NOT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `nombre_categoria` (`nombre_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (41,'Aceites'),(27,'Aguas'),(9,'carnes'),(21,'Cerdo'),(32,'Cocina'),(17,'Condimentos'),(35,'Cuidado Capilar'),(30,'Desechables'),(22,'Embutidos'),(16,'Endulzantes'),(19,'Enlatados'),(11,'Frutas'),(29,'Gaseosas'),(1,'Granos'),(15,'Harinas'),(34,'Higiene'),(31,'Hogar'),(25,'Huevos'),(28,'Jugos'),(24,'Lacteos'),(33,'Limpieza'),(36,'Mascotas'),(38,'Mecatos'),(13,'Pastas'),(23,'Pescados'),(20,'Pollo'),(18,'Salsas'),(26,'Verduras');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codigo_recuperacion`
--

DROP TABLE IF EXISTS `codigo_recuperacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codigo_recuperacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `correo` varchar(150) COLLATE utf8mb4_spanish_ci NOT NULL,
  `codigo` varchar(10) COLLATE utf8mb4_spanish_ci NOT NULL,
  `fecha_expiracion` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_correo_codigo` (`correo`,`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codigo_recuperacion`
--

LOCK TABLES `codigo_recuperacion` WRITE;
/*!40000 ALTER TABLE `codigo_recuperacion` DISABLE KEYS */;
INSERT INTO `codigo_recuperacion` VALUES (1,'noireliteofficial@gmail.com','088442','2026-09-02 16:15:49',1),(2,'noireliteofficial@gmail.com','427383','2026-09-14 15:25:01',0);
/*!40000 ALTER TABLE `codigo_recuperacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientos`
--

DROP TABLE IF EXISTS `movimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientos` (
  `id_movimiento` int NOT NULL AUTO_INCREMENT,
  `tipo_movimiento` varchar(20) COLLATE utf8mb4_spanish_ci NOT NULL,
  `cantidad` int NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `observacion` varchar(255) COLLATE utf8mb4_spanish_ci DEFAULT NULL,
  `id_producto` int DEFAULT NULL,
  `id_usuario` int NOT NULL,
  `nombre_producto` varchar(100) COLLATE utf8mb4_spanish_ci NOT NULL,
  PRIMARY KEY (`id_movimiento`),
  KEY `idx_tipo` (`tipo_movimiento`),
  KEY `idx_fecha` (`fecha_hora`),
  KEY `idx_producto` (`id_producto`),
  KEY `idx_usuario` (`id_usuario`),
  CONSTRAINT `fk_movimientos_producto` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id_producto`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `movimientos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientos`
--

LOCK TABLES `movimientos` WRITE;
/*!40000 ALTER TABLE `movimientos` DISABLE KEYS */;
INSERT INTO `movimientos` VALUES (52,'AJUSTE',4,'2026-09-14 14:16:07','Se aumentó el stock en 4 unidades',25,3,'frijol 500g'),(53,'AJUSTE',1,'2026-09-14 14:16:14','Se disminuyó el stock en 1 unidades',21,3,'Coca-cola 3L'),(54,'ENTRADA',1896,'2026-09-16 15:32:11','Producto agregado al inventario',NULL,3,'arroz casanare, 500g'),(55,'ENTRADA',1896,'2026-09-16 15:32:25','Producto agregado al inventario',NULL,3,'arroz casanare 500g'),(56,'SALIDA',1896,'2026-09-16 15:33:41','Producto eliminado del inventario',NULL,3,'arroz casanare, 500g'),(57,'ENTRADA',0,'2026-09-16 15:38:06','Producto agregado al inventario',NULL,3,'66'),(58,'SALIDA',0,'2026-09-16 15:38:28','Producto eliminado del inventario',NULL,3,'66'),(59,'SALIDA',1896,'2026-09-16 15:38:32','Producto eliminado del inventario',NULL,3,'arroz casanare 500g'),(60,'ENTRADA',1599,'2026-09-16 15:53:04','Producto agregado al inventario',31,3,'bigcola 1L'),(61,'AJUSTE',199,'2026-09-16 15:53:58','Se disminuyó el stock en 199 unidades',31,3,'bigcola 1L'),(62,'AJUSTE',33,'2026-09-17 18:11:24','Se aumento el stock en 33 unidades',20,3,'Arroz diana 500g'),(63,'AJUSTE',24,'2026-09-18 14:31:24','Se aumento el stock en 24 unidades',21,3,'Coca-cola 3L'),(64,'AJUSTE',168,'2026-09-18 14:31:44','Se aumento el stock en 168 unidades',25,3,'frijol 500g'),(65,'AJUSTE',168,'2026-09-18 14:31:54','Se aumento el stock en 168 unidades',31,3,'bigcola 1L'),(66,'AJUSTE',56,'2026-09-18 14:32:04','Se aumento el stock en 56 unidades',21,3,'Coca-cola 3L'),(67,'AJUSTE',1,'2026-09-18 14:53:52','Se aumento el stock en 1 unidades',25,9,'frijol 500g'),(68,'AJUSTE',24,'2026-09-18 14:54:07','Se aumento el stock en 24 unidades',20,9,'Arroz diana 500g');
/*!40000 ALTER TABLE `movimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `producto`
--

DROP TABLE IF EXISTS `producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `producto` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `id_categoria` int DEFAULT NULL,
  `id_usuario` int DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `cantidad` int NOT NULL DEFAULT '0',
  `estado` varchar(20) NOT NULL DEFAULT 'Óptimo',
  `proveedor` varchar(100) DEFAULT NULL,
  `actual` int NOT NULL DEFAULT '0',
  `bodega` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_producto`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `id_usuario` (`id_usuario`),
  KEY `fk_nueva_sin_conflicto` (`id_categoria`),
  CONSTRAINT `fk_nueva_sin_conflicto` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE SET NULL,
  CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `producto`
--

LOCK TABLES `producto` WRITE;
/*!40000 ALTER TABLE `producto` DISABLE KEYS */;
INSERT INTO `producto` VALUES (20,'001','Arroz diana 500g',1,3,3200.00,23,'Optimo','Molinos Diana',34,23),(21,'002','Coca-cola 3L',29,3,10000.00,22,'Optimo','Coca-cola Colombia',56,24),(25,'003','frijol 500g',1,3,3000.00,16,'Optimo','granos yopal',24,145),(31,'004','bigcola 1L',29,3,3500.00,1400,'Optimo','surtivicola',123,45);
/*!40000 ALTER TABLE `producto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `correo` varchar(150) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `rol` varchar(20) NOT NULL DEFAULT 'EMPLEADO',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `correo` (`correo`),
  UNIQUE KEY `uk_telefono` (`telefono`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (3,'Santos Achagua','noireliteofficial@gmail.com','10296644910','3108320965','2026-09-02 19:07:14','ADMINISTRADOR',1),(9,'Daniel Puin','daniel@gmail.com','1234567890','3108320987','2026-09-17 23:09:56','EMPLEADO',1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-19 11:55:14
