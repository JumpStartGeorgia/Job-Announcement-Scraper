-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.35-0ubuntu0.13.10.2 - (Ubuntu)
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             8.0.0.4396
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for job_announcements
CREATE DATABASE IF NOT EXISTS `job_announcements` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `job_announcements`;


-- Dumping structure for table job_announcements.jobs
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source` varchar(255) NOT NULL,
  `job_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `provided_by` varchar(255) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `deadline` varchar(255) DEFAULT NULL,
  `salary` varchar(255) DEFAULT NULL,
  `num_positions` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `job_type` varchar(255) DEFAULT NULL,
  `probation_period` varchar(255) DEFAULT NULL,
  `contact_address` varchar(255) DEFAULT NULL,
  `contact_phone` varchar(255) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `job_description` text,
  `additional_requirements` text,
  `additional_info` text,
  `qualifications_degree` varchar(255) DEFAULT NULL,
  `qualifications_experience` varchar(255) DEFAULT NULL,
  `qualifications_profession` varchar(255) DEFAULT NULL,
  `qualifications_age` varchar(255) DEFAULT NULL,
  `qualifications_knowledge_legal_acts` text,
  KEY `Index 1` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table job_announcements.knowledge_computers
CREATE TABLE IF NOT EXISTS `knowledge_computers` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `jobs_id` int(10) NOT NULL DEFAULT '0',
  `program` varchar(255) DEFAULT NULL,
  `knowledge` varchar(255) DEFAULT NULL,
  KEY `Index 1` (`id`),
  KEY `Index 2` (`jobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.


-- Dumping structure for table job_announcements.knowledge_languages
CREATE TABLE IF NOT EXISTS `knowledge_languages` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `jobs_id` int(10) NOT NULL DEFAULT '0',
  `language` varchar(255) DEFAULT NULL,
  `writing` varchar(255) DEFAULT NULL,
  `reading` varchar(255) DEFAULT NULL,
  KEY `Index 1` (`id`),
  KEY `Index 2` (`jobs_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
