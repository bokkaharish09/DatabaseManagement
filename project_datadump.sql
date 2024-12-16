-- MySQL dump 10.13  Distrib 5.7.24, for osx11.1 (x86_64)
--
-- Host: localhost    Database: AcuCRM
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `AcuCRM`
--

/*!40000 DROP DATABASE IF EXISTS `AcuCRM`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `AcuCRM` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `AcuCRM`;

--
-- Table structure for table `BusinessCustomer`
--

DROP TABLE IF EXISTS `BusinessCustomer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `BusinessCustomer` (
  `customerID` int NOT NULL,
  `companyName` varchar(100) NOT NULL,
  `industryID` int DEFAULT NULL,
  `annualRevenue` int DEFAULT NULL,
  `corpOfficeAddress` varchar(200) NOT NULL,
  `corpOfficeZipCode` int NOT NULL,
  PRIMARY KEY (`customerID`),
  KEY `industryID` (`industryID`),
  CONSTRAINT `businesscustomer_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `businesscustomer_ibfk_2` FOREIGN KEY (`industryID`) REFERENCES `IndustryType` (`industryID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BusinessCustomer`
--

LOCK TABLES `BusinessCustomer` WRITE;
/*!40000 ALTER TABLE `BusinessCustomer` DISABLE KEYS */;
INSERT INTO `BusinessCustomer` VALUES (2,'TechCorp',1,5000000,'101 Tech Blvd, Austin',73301),(4,'RetailWorld',3,3000000,'202 Commerce Way, Atlanta',30301);
/*!40000 ALTER TABLE `BusinessCustomer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ContactMethod`
--

DROP TABLE IF EXISTS `ContactMethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ContactMethod` (
  `contactMethodID` int NOT NULL AUTO_INCREMENT,
  `contactMethod` varchar(50) NOT NULL,
  `sourceID` int DEFAULT NULL,
  `contactPhnNo` char(10) DEFAULT NULL,
  `contactEmail` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`contactMethodID`),
  KEY `sourceID` (`sourceID`),
  CONSTRAINT `contactmethod_ibfk_1` FOREIGN KEY (`sourceID`) REFERENCES `SalesSource` (`sourceID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ContactMethod`
--

LOCK TABLES `ContactMethod` WRITE;
/*!40000 ALTER TABLE `ContactMethod` DISABLE KEYS */;
INSERT INTO `ContactMethod` VALUES (1,'Email',1,NULL,'abc@sharkninja.com'),(2,'Phone',2,'8573357249',NULL),(3,'Phone',3,'8574358629',NULL),(4,'Email',4,NULL,'xyz@tesla.com'),(5,'Phone',5,'3357468459',NULL);
/*!40000 ALTER TABLE `ContactMethod` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Customer` (
  `customerID` int NOT NULL,
  `customerType` enum('Individual','Business') NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` char(10) NOT NULL,
  `ticketID` int DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  KEY `ticketID` (`ticketID`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`ticketID`) REFERENCES `SupportTicket` (`ticketID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,'Individual','john.doe@example.com','1234567890',3),(2,'Business','companyA@example.com','9876543210',5),(3,'Individual','jane.smith@example.com','1112223333',2),(4,'Business','companyB@example.com','4445556666',1),(5,'Individual','mark.jones@example.com','7778889999',4);
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GiftSet`
--

DROP TABLE IF EXISTS `GiftSet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GiftSet` (
  `giftSetID` int NOT NULL AUTO_INCREMENT,
  `giftSetName` varchar(100) NOT NULL,
  `price` float NOT NULL,
  `productID` int DEFAULT NULL,
  PRIMARY KEY (`giftSetID`),
  KEY `productID` (`productID`),
  CONSTRAINT `giftset_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `Product` (`productID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GiftSet`
--

LOCK TABLES `GiftSet` WRITE;
/*!40000 ALTER TABLE `GiftSet` DISABLE KEYS */;
INSERT INTO `GiftSet` VALUES (1,'OWALA Back-to-School Bundle',39.99,4),(2,'OWALA Ultimate Hydration Kit',59.99,1),(3,'OWALA Fitness Pack',44.99,3),(4,'OWALA Traveler’s Bundle',69.99,7),(5,'OWALA Essentials Pack',19.99,5),(6,'OWALA Holiday Gift Set',64.99,8),(7,'OWALA Replacement Pack',12.99,6);
/*!40000 ALTER TABLE `GiftSet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IndividualCustomer`
--

DROP TABLE IF EXISTS `IndividualCustomer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IndividualCustomer` (
  `customerID` int NOT NULL,
  `customerName` varchar(20) NOT NULL,
  `age` int DEFAULT NULL,
  `streetName` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `zipCode` int NOT NULL,
  PRIMARY KEY (`customerID`),
  CONSTRAINT `individualcustomer_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IndividualCustomer`
--

LOCK TABLES `IndividualCustomer` WRITE;
/*!40000 ALTER TABLE `IndividualCustomer` DISABLE KEYS */;
INSERT INTO `IndividualCustomer` VALUES (1,'Sophia Bennett',30,'123 Elm Street','New York','NY',10001),(3,'Liam Harper',25,'456 Maple Avenue','San Francisco','CA',94102),(5,'Isabella Mitchell',40,'789 Oak Drive','Chicago','IL',60603);
/*!40000 ALTER TABLE `IndividualCustomer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `IndustryType`
--

DROP TABLE IF EXISTS `IndustryType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `IndustryType` (
  `industryID` int NOT NULL,
  `industryName` varchar(50) NOT NULL,
  PRIMARY KEY (`industryID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `IndustryType`
--

LOCK TABLES `IndustryType` WRITE;
/*!40000 ALTER TABLE `IndustryType` DISABLE KEYS */;
INSERT INTO `IndustryType` VALUES (1,'Technology'),(2,'Healthcare'),(3,'Retail'),(4,'Finance'),(5,'Education'),(6,'Real Estate'),(7,'Manufacturing'),(8,'Logistics'),(9,'Energy'),(10,'Entertainment');
/*!40000 ALTER TABLE `IndustryType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Interaction`
--

DROP TABLE IF EXISTS `Interaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Interaction` (
  `interactionID` int NOT NULL AUTO_INCREMENT,
  `dateOfInteraction` date NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `representativeID` int DEFAULT NULL,
  `notes` text NOT NULL,
  `status` enum('ACTIVE','INACTIVE','PENDING','ARCHIEVED') DEFAULT NULL,
  `customerFeedback` text,
  `customerRating` int DEFAULT NULL,
  `ticketID` int DEFAULT NULL,
  PRIMARY KEY (`interactionID`),
  KEY `representativeID` (`representativeID`),
  KEY `ticketID` (`ticketID`),
  CONSTRAINT `interaction_ibfk_1` FOREIGN KEY (`representativeID`) REFERENCES `SupportTeam` (`employeeID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `interaction_ibfk_2` FOREIGN KEY (`ticketID`) REFERENCES `SupportTicket` (`ticketID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Interaction`
--

LOCK TABLES `Interaction` WRITE;
/*!40000 ALTER TABLE `Interaction` DISABLE KEYS */;
INSERT INTO `Interaction` VALUES (1,'2024-11-01','Follow-up',1,'Customer satisfied with service.','ACTIVE','Great experience!',5,1),(2,'2024-11-05','Resolution',2,'Issue resolved quickly.','ACTIVE','Good resolution time.',4,2);
/*!40000 ALTER TABLE `Interaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Items`
--

DROP TABLE IF EXISTS `Items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Items` (
  `itemID` int NOT NULL AUTO_INCREMENT,
  `orderID` int NOT NULL,
  `productID` int NOT NULL,
  `quantity` int NOT NULL,
  `cartValue` float DEFAULT NULL,
  PRIMARY KEY (`itemID`),
  KEY `orderID` (`orderID`),
  KEY `productID` (`productID`),
  CONSTRAINT `items_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `items_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Product` (`productID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Items`
--

LOCK TABLES `Items` WRITE;
/*!40000 ALTER TABLE `Items` DISABLE KEYS */;
/*!40000 ALTER TABLE `Items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MarketingCampaign`
--

DROP TABLE IF EXISTS `MarketingCampaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MarketingCampaign` (
  `campaignID` int NOT NULL AUTO_INCREMENT,
  `campaignName` varchar(100) NOT NULL,
  `startDt` date NOT NULL,
  `endDt` date NOT NULL,
  `campaignType` varchar(50) NOT NULL,
  `estimatedRevenuePotential` int DEFAULT NULL,
  PRIMARY KEY (`campaignID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MarketingCampaign`
--

LOCK TABLES `MarketingCampaign` WRITE;
/*!40000 ALTER TABLE `MarketingCampaign` DISABLE KEYS */;
INSERT INTO `MarketingCampaign` VALUES (1,'Holiday Special','2024-11-01','2024-12-31','Seasonal',100000),(2,'Back to School','2024-08-01','2024-09-15','Seasonal',50000),(3,'Black Friday','2024-11-24','2024-11-28','Promotion',200000),(4,'Christmas','2024-12-24','2024-12-31','Seasonal',200000);
/*!40000 ALTER TABLE `MarketingCampaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Orders` (
  `orderID` int NOT NULL,
  `orderDate` date NOT NULL,
  `shipDate` date DEFAULT NULL,
  `status` enum('ACTIVE','INACTIVE','PENDING','ARCHIVED') NOT NULL,
  `totalAmount` float NOT NULL,
  `shippingAddress` varchar(200) NOT NULL,
  `shippingZipCode` int DEFAULT NULL,
  `paymentMethod` varchar(50) DEFAULT NULL,
  `customerID` int DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `customerID` (`customerID`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,'2024-10-01','2024-10-05','ACTIVE',749.99,'123 Elm St, Springfield',12345,'Credit Card',1),(2,'2024-10-10','2024-10-15','ACTIVE',319.99,'456 Oak St, Springfield',12346,'PayPal',2);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Product`
--

DROP TABLE IF EXISTS `Product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Product` (
  `productID` int NOT NULL,
  `productName` varchar(100) NOT NULL,
  `SKU` int NOT NULL,
  `categoryID` int NOT NULL,
  `basePrice` float NOT NULL,
  `isSeasonal` tinyint(1) NOT NULL,
  `isAvailable` tinyint(1) NOT NULL,
  `giftingOption` tinyint(1) NOT NULL,
  PRIMARY KEY (`productID`),
  UNIQUE KEY `productName` (`productName`),
  KEY `categoryID` (`categoryID`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`categoryID`) REFERENCES `ProductCategory` (`categoryID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Product`
--

LOCK TABLES `Product` WRITE;
/*!40000 ALTER TABLE `Product` DISABLE KEYS */;
INSERT INTO `Product` VALUES (1,'OWALA FreeSip Insulated Bottle 24oz',1001,1,29.99,0,1,1),(2,'OWALA Twist Plastic Bottle 22oz',1002,2,14.99,0,1,1),(3,'OWALA Flip Stainless Steel Bottle 32oz',1003,3,39.99,0,1,1),(4,'OWALA Kids Sip Bottle 12oz',1004,4,19.99,1,1,1),(5,'OWALA Carry Loop Accessory',1005,5,4.99,0,1,0),(6,'OWALA Straw Lid Replacement',1006,5,5.99,0,1,0),(7,'OWALA FreeSip Insulated Bottle 40oz',1007,1,34.99,0,1,1),(8,'OWALA Flip Stainless Steel Bottle 18oz',1008,3,24.99,1,1,1);
/*!40000 ALTER TABLE `Product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductCategory`
--

DROP TABLE IF EXISTS `ProductCategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductCategory` (
  `categoryID` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(50) NOT NULL,
  PRIMARY KEY (`categoryID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductCategory`
--

LOCK TABLES `ProductCategory` WRITE;
/*!40000 ALTER TABLE `ProductCategory` DISABLE KEYS */;
INSERT INTO `ProductCategory` VALUES (1,'Insulated Bottles'),(2,'Plastic Bottles'),(3,'Stainless Steel Bottles'),(4,'Kids Bottles'),(5,'Accessories');
/*!40000 ALTER TABLE `ProductCategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ProductPromotion`
--

DROP TABLE IF EXISTS `ProductPromotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ProductPromotion` (
  `promoID` int NOT NULL,
  `productID` int NOT NULL,
  `startDt` date NOT NULL,
  `endDt` date NOT NULL,
  `discountRate` float DEFAULT NULL,
  PRIMARY KEY (`promoID`,`productID`),
  KEY `productID` (`productID`),
  CONSTRAINT `productpromotion_ibfk_1` FOREIGN KEY (`promoID`) REFERENCES `Promotion` (`promoID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `productpromotion_ibfk_2` FOREIGN KEY (`productID`) REFERENCES `Product` (`productID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ProductPromotion`
--

LOCK TABLES `ProductPromotion` WRITE;
/*!40000 ALTER TABLE `ProductPromotion` DISABLE KEYS */;
INSERT INTO `ProductPromotion` VALUES (1,1,'2024-11-01','2024-12-31',15),(2,2,'2024-11-15','2024-12-15',20);
/*!40000 ALTER TABLE `ProductPromotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Promotion`
--

DROP TABLE IF EXISTS `Promotion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Promotion` (
  `promoID` int NOT NULL,
  `promoName` varchar(50) NOT NULL,
  `discountRate` float NOT NULL,
  PRIMARY KEY (`promoID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Promotion`
--

LOCK TABLES `Promotion` WRITE;
/*!40000 ALTER TABLE `Promotion` DISABLE KEYS */;
INSERT INTO `Promotion` VALUES (1,'Holiday Sale',15),(2,'Clearance Discount',20);
/*!40000 ALTER TABLE `Promotion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Sales`
--

DROP TABLE IF EXISTS `Sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Sales` (
  `salesID` int NOT NULL AUTO_INCREMENT,
  `customerID` int NOT NULL,
  `sourceID` int NOT NULL,
  `dateLeadCreated` date NOT NULL,
  `contactMethodID` int DEFAULT NULL,
  `revenuePotential` int DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `conversionRate` float DEFAULT NULL,
  `campaignID` int DEFAULT NULL,
  PRIMARY KEY (`salesID`),
  KEY `customerID` (`customerID`),
  KEY `sourceID` (`sourceID`),
  KEY `contactMethodID` (`contactMethodID`),
  KEY `campaignID` (`campaignID`),
  CONSTRAINT `sales_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sales_ibfk_2` FOREIGN KEY (`sourceID`) REFERENCES `SalesSource` (`sourceID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sales_ibfk_3` FOREIGN KEY (`contactMethodID`) REFERENCES `ContactMethod` (`contactMethodID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `sales_ibfk_4` FOREIGN KEY (`campaignID`) REFERENCES `MarketingCampaign` (`campaignID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Sales`
--

LOCK TABLES `Sales` WRITE;
/*!40000 ALTER TABLE `Sales` DISABLE KEYS */;
INSERT INTO `Sales` VALUES (1,1,1,'2024-10-05',1,5000,'Won',0.85,1),(2,2,2,'2024-10-10',2,3000,'Lost',0.45,2),(3,3,3,'2024-11-15',3,7000,'Pending',0.6,1);
/*!40000 ALTER TABLE `Sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SalesSource`
--

DROP TABLE IF EXISTS `SalesSource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SalesSource` (
  `sourceID` int NOT NULL AUTO_INCREMENT,
  `sourceOrigin` varchar(50) NOT NULL,
  `sourceName` varchar(100) NOT NULL,
  PRIMARY KEY (`sourceID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SalesSource`
--

LOCK TABLES `SalesSource` WRITE;
/*!40000 ALTER TABLE `SalesSource` DISABLE KEYS */;
INSERT INTO `SalesSource` VALUES (1,'Website','Shark Ninja'),(2,'Referral','Sienna Harris'),(3,'Social Media','Aditi Putrevu'),(4,'Email Campaign','Tesla'),(5,'In-Person','Harish Bokka');
/*!40000 ALTER TABLE `SalesSource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SupportTeam`
--

DROP TABLE IF EXISTS `SupportTeam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SupportTeam` (
  `employeeID` int NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SupportTeam`
--

LOCK TABLES `SupportTeam` WRITE;
/*!40000 ALTER TABLE `SupportTeam` DISABLE KEYS */;
INSERT INTO `SupportTeam` VALUES (1,'Alice','Johnson','johnson.alice@acucrm.com'),(2,'Bob','Smith','smith.bob@acucrm.com'),(3,'Charlie','Davis','davis.charlie@acucrm.com');
/*!40000 ALTER TABLE `SupportTeam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SupportTicket`
--

DROP TABLE IF EXISTS `SupportTicket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SupportTicket` (
  `ticketID` int NOT NULL AUTO_INCREMENT,
  `issueDesc` text NOT NULL,
  `status` enum('Open','In Progress','Resolved','Closed') NOT NULL,
  `creationDt` date NOT NULL,
  `resolveDt` date DEFAULT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') DEFAULT NULL,
  PRIMARY KEY (`ticketID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SupportTicket`
--

LOCK TABLES `SupportTicket` WRITE;
/*!40000 ALTER TABLE `SupportTicket` DISABLE KEYS */;
INSERT INTO `SupportTicket` VALUES (1,'Issue with product delivery','Open','2024-10-01',NULL,'HIGH'),(2,'Billing error','Resolved','2024-09-15','2024-09-20','MEDIUM'),(3,'Technical glitch on website','In Progress','2024-10-10',NULL,'URGENT'),(4,'Refund request','Closed','2024-08-05',NULL,'LOW'),(5,'Account access issue','Resolved','2024-10-15','2024-10-18','HIGH');
/*!40000 ALTER TABLE `SupportTicket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'AcuCRM'
--

--
-- Dumping routines for database 'AcuCRM'
--
/*!50003 DROP FUNCTION IF EXISTS `GetCustomerProfile` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCustomerProfile`(customerID INT) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE profile TEXT;

    SELECT CONCAT('Customer Info: ', c.customerID, ', ', c.email, ', ', c.phone, 
                  ' | Orders: ', COALESCE(GROUP_CONCAT(DISTINCT o.orderID), 'None'), 
                  ' | Tickets: ', COALESCE(GROUP_CONCAT(DISTINCT t.ticketID), 'None'), 
                  ' | Interactions: ', COALESCE(GROUP_CONCAT(DISTINCT i.interactionID), 'None'))
    INTO profile
    FROM Customer c
    LEFT JOIN Orders o ON c.customerID = o.customerID
    LEFT JOIN SupportTicket t ON  t.ticketID = c.ticketID
    LEFT JOIN Interaction i ON t.ticketID = i.ticketID
    WHERE c.customerID = customerID
    GROUP BY c.customerID, c.email, c.phone; -- Added GROUP BY

    RETURN profile;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `GetTicketDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `GetTicketDetails`(ticketID INT) RETURNS varchar(500) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
    DECLARE ticketDetails VARCHAR(500);

    SELECT 
        CONCAT(
            'Ticket ID: ', ticketID, 
            ', Issue: ', COALESCE(issueDesc, 'N/A'), 
            ', Status: ', COALESCE(status, 'N/A'), 
            ', Priority: ', COALESCE(priority, 'N/A'), 
            ', Created On: ', COALESCE(creationDt, 'N/A'), 
            ', Resolved On: ', COALESCE(resolveDt, 'N/A')
        )
    INTO ticketDetails
    FROM SupportTicket
    WHERE SupportTicket.ticketID = ticketID;

    RETURN COALESCE(ticketDetails, 'No ticket found with the given ID');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CampaignPerformanceDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CampaignPerformanceDetails`(IN campaignID INT)
BEGIN
    DECLARE totalRevenue FLOAT DEFAULT 0;
    DECLARE totalLeads INT DEFAULT 0;
    DECLARE totalPurchases INT DEFAULT 0;
    DECLARE conversionRate FLOAT DEFAULT 0;
    DECLARE usersPurchased TEXT DEFAULT NULL;
    DECLARE salesDetails TEXT DEFAULT NULL;

    SELECT 
        COALESCE(SUM(s.revenuePotential), 0), 
        COALESCE(COUNT(s.salesID), 0)
    INTO 
        totalRevenue, 
        totalLeads
    FROM Sales s
    WHERE s.campaignID = campaignID;

    SELECT 
        COALESCE(COUNT(s.salesID), 0)
    INTO 
        totalPurchases
    FROM Sales s
    WHERE s.campaignID = campaignID AND s.status = 'Closed';

    IF totalLeads > 0 THEN
        SET conversionRate = (totalPurchases / totalLeads) * 100;
    ELSE
        SET conversionRate = 0;
    END IF;

    SELECT 
        GROUP_CONCAT(DISTINCT c.email ORDER BY c.email SEPARATOR ', ')
    INTO 
        usersPurchased
    FROM Sales s
    JOIN Customer c ON s.customerID = c.customerID
    WHERE s.campaignID = campaignID AND s.status = 'Closed';

    SELECT 
        GROUP_CONCAT(CONCAT('SaleID: ', s.salesID, ' Revenue: $', s.revenuePotential) SEPARATOR '; ')
    INTO 
        salesDetails
    FROM Sales s
    WHERE s.campaignID = campaignID;

    SELECT 
        campaignID AS `Campaign ID`,
        totalRevenue AS `Total Revenue`,
        totalLeads AS `Total Leads`,
        totalPurchases AS `Total Purchases`,
        CONCAT(ROUND(conversionRate, 2), '%') AS `Conversion Rate`,
        IFNULL(usersPurchased, 'None') AS `Users Purchased`,
        IFNULL(salesDetails, 'No sales data available') AS `Sales Details`;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateGiftSet` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateGiftSet`(
    IN p_giftSetName VARCHAR(100),
    IN p_productIDs TEXT,
    IN p_discountPercentage FLOAT
)
BEGIN
    DECLARE totalPrice FLOAT DEFAULT 0;
    DECLARE discountedPrice FLOAT;
    DECLARE finished INT DEFAULT 0;
    DECLARE currentProductID INT;
    DECLARE currentPrice FLOAT;
    DECLARE newGiftSetID INT;

    DECLARE productCursor CURSOR FOR 
        SELECT productID, basePrice 
        FROM Product
        WHERE FIND_IN_SET(productID, p_productIDs) > 0 AND isAvailable = TRUE;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN productCursor;

    read_loop: LOOP
        FETCH productCursor INTO currentProductID, currentPrice;
        IF finished THEN
            LEAVE read_loop;
        END IF;

        SET totalPrice = totalPrice + currentPrice;
    END LOOP;

    CLOSE productCursor;

    SET discountedPrice = totalPrice * (1 - p_discountPercentage / 100);

    INSERT INTO GiftSet (giftSetName, price)
    VALUES (p_giftSetName, discountedPrice);

    SET newGiftSetID = LAST_INSERT_ID();

    OPEN productCursor;

    read_loop: LOOP
        FETCH productCursor INTO currentProductID, currentPrice;
        IF finished THEN
            LEAVE read_loop;
        END IF;

        INSERT INTO GiftSet (giftSetID, productID)
        VALUES (newGiftSetID, currentProductID);
    END LOOP;

    CLOSE productCursor;
    SELECT newGiftSetID AS giftSetID, p_giftSetName AS giftSetName, discountedPrice AS finalPrice;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-04 23:04:28
