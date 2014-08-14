-- phpMyAdmin SQL Dump
-- version 3.5.2
-- http://www.phpmyadmin.net
--
-- Host: internal-db.s29434.gridserver.com
-- Generation Time: May 05, 2014 at 11:15 PM
-- Server version: 5.1.26-rc-5.1.26rc-log
-- PHP Version: 5.3.27

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `db29434_jobsge`
--

-- --------------------------------------------------------

--
-- Table structure for table `adboxes`
--

DROP TABLE IF EXISTS `adboxes`;
CREATE TABLE IF NOT EXISTS `adboxes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `disabled` tinyint(4) NOT NULL DEFAULT '0',
  `priority` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `text` varchar(1000) CHARACTER SET utf8 NOT NULL,
  `text_en` varchar(1000) NOT NULL,
  `dt1` datetime NOT NULL,
  `dt2` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `disabled` (`disabled`,`priority`,`client_id`,`text`(255))
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `adboxes_conf`
--

DROP TABLE IF EXISTS `adboxes_conf`;
CREATE TABLE IF NOT EXISTS `adboxes_conf` (
  `name` varchar(200) NOT NULL,
  `value` varchar(200) NOT NULL,
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `announcement`
--

DROP TABLE IF EXISTS `announcement`;
CREATE TABLE IF NOT EXISTS `announcement` (
  `Status` tinyint(1) NOT NULL DEFAULT '0',
  `Global` tinyint(1) NOT NULL DEFAULT '0',
  `Announcement` text CHARACTER SET latin1,
  `Announcement_ge` text CHARACTER SET latin1 NOT NULL,
  `Publish` date NOT NULL DEFAULT '0000-00-00',
  `Deadline` date NOT NULL DEFAULT '9999-12-31',
  `RecordTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY `Status` (`Status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 MAX_ROWS=1;

-- --------------------------------------------------------

--
-- Table structure for table `blog`
--

DROP TABLE IF EXISTS `blog`;
CREATE TABLE IF NOT EXISTS `blog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL DEFAULT '0000-00-00',
  `img` varchar(64) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `title_ge` varchar(255) NOT NULL DEFAULT '',
  `description` text NOT NULL,
  `description_ge` text NOT NULL,
  `text` text NOT NULL,
  `text_ge` text NOT NULL,
  `attachment` varchar(64) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ge` varchar(1000) NOT NULL,
  `name_en` varchar(255) NOT NULL,
  `sort` int(11) NOT NULL,
  `codename` varchar(35) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sort` (`sort`,`name_ge`(255)),
  KEY `sort_2` (`sort`,`name_en`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `categories_for_vacancies`
--

DROP TABLE IF EXISTS `categories_for_vacancies`;
CREATE TABLE IF NOT EXISTS `categories_for_vacancies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL,
  `vacancy_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_id_2` (`category_id`,`vacancy_id`),
  KEY `category_id` (`category_id`,`vacancy_id`),
  KEY `vacancy_id` (`vacancy_id`,`category_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5258 ;

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
CREATE TABLE IF NOT EXISTS `clients` (
  `client_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_url` varchar(128) NOT NULL DEFAULT '',
  `display_name_en` varchar(255) NOT NULL DEFAULT '',
  `display_name_ge` varchar(255) NOT NULL DEFAULT '',
  `full_name_en` varchar(255) NOT NULL DEFAULT '',
  `full_name_ge` varchar(255) NOT NULL DEFAULT '',
  `p_address_en` varchar(255) NOT NULL DEFAULT '',
  `p_address_ge` varchar(255) NOT NULL DEFAULT '',
  `j_address_en` varchar(255) NOT NULL DEFAULT '',
  `j_address_ge` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(128) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `website` varchar(128) NOT NULL DEFAULT '',
  `contact_person` text NOT NULL,
  `logo` varchar(255) NOT NULL DEFAULT '',
  `logoicon` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `logo_big` varchar(100) NOT NULL,
  `text_en` text NOT NULL,
  `text_ge` text NOT NULL,
  `att1` varchar(255) NOT NULL DEFAULT '',
  `att2` varchar(255) NOT NULL DEFAULT '',
  `att3` varchar(255) NOT NULL DEFAULT '',
  `att4` varchar(255) NOT NULL DEFAULT '',
  `att5` varchar(255) NOT NULL DEFAULT '',
  `att1_ge` varchar(255) NOT NULL DEFAULT '',
  `att2_ge` varchar(255) NOT NULL DEFAULT '',
  `att3_ge` varchar(255) NOT NULL DEFAULT '',
  `att4_ge` varchar(255) NOT NULL DEFAULT '',
  `att5_ge` varchar(255) NOT NULL DEFAULT '',
  `att1_en` varchar(255) NOT NULL DEFAULT '',
  `att2_en` varchar(255) NOT NULL DEFAULT '',
  `att3_en` varchar(255) NOT NULL DEFAULT '',
  `att4_en` varchar(255) NOT NULL DEFAULT '',
  `att5_en` varchar(255) NOT NULL DEFAULT '',
  `notes` text NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `searchindex` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`client_id`),
  UNIQUE KEY `domain` (`client_url`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5536 ;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
CREATE TABLE IF NOT EXISTS `contacts` (
  `contact_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `customer_id` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `position` varchar(64) NOT NULL DEFAULT '',
  `phone` varchar(128) NOT NULL DEFAULT '',
  `mobile` varchar(64) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `notes` text NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

DROP TABLE IF EXISTS `content`;
CREATE TABLE IF NOT EXISTS `content` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `lang` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `status` (`status`,`lang`,`key`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=24 ;

-- --------------------------------------------------------

--
-- Table structure for table `faq`
--

DROP TABLE IF EXISTS `faq`;
CREATE TABLE IF NOT EXISTS `faq` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `Question` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Question_ge` varchar(255) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Answer` text CHARACTER SET latin1 NOT NULL,
  `Answer_ge` text CHARACTER SET latin1 NOT NULL,
  `Published` date NOT NULL DEFAULT '0000-00-00',
  `RecordTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=30 ;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
CREATE TABLE IF NOT EXISTS `favorites` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL DEFAULT '',
  `stars` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=169401 ;

-- --------------------------------------------------------

--
-- Table structure for table `img2`
--

DROP TABLE IF EXISTS `img2`;
CREATE TABLE IF NOT EXISTS `img2` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `swf` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `url` varchar(255) NOT NULL DEFAULT '',
  `today` int(10) unsigned NOT NULL DEFAULT '0',
  `daily` int(10) unsigned NOT NULL DEFAULT '0',
  `impressions` int(10) unsigned NOT NULL DEFAULT '0',
  `total` int(10) unsigned NOT NULL DEFAULT '0',
  `regular` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `default` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `start` date NOT NULL DEFAULT '0000-00-00',
  `end` date NOT NULL DEFAULT '0000-00-00',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `today` (`today`,`daily`,`impressions`,`total`,`default`,`status`,`start`,`end`,`regular`,`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=175 ;

-- --------------------------------------------------------

--
-- Table structure for table `img2_stats`
--

DROP TABLE IF EXISTS `img2_stats`;
CREATE TABLE IF NOT EXISTS `img2_stats` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `day` date NOT NULL DEFAULT '0000-00-00',
  `img2_id` int(10) unsigned NOT NULL DEFAULT '0',
  `impressions` int(10) unsigned NOT NULL DEFAULT '0',
  `clicks` int(10) unsigned NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `day` (`day`,`img2_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=127001074 ;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL DEFAULT '0',
  `client_url` varchar(128) NOT NULL DEFAULT '',
  `anonymous` char(1) NOT NULL DEFAULT '0',
  `vip3` char(1) CHARACTER SET latin1 NOT NULL DEFAULT '9',
  `vip` tinyint(4) NOT NULL,
  `category` char(1) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `reg` char(1) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `logo` char(1) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `logoicon` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `url` varchar(128) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `salary` char(1) CHARACTER SET latin1 NOT NULL DEFAULT '0',
  `eng_text` char(1) NOT NULL DEFAULT '0',
  `geo_text` char(1) NOT NULL DEFAULT '0',
  `cat_law` char(1) NOT NULL DEFAULT '0',
  `cat_finance` char(1) NOT NULL DEFAULT '0',
  `cat_admin` char(1) NOT NULL DEFAULT '0',
  `cat_it` char(1) NOT NULL DEFAULT '0',
  `cat_technical` char(1) NOT NULL DEFAULT '0',
  `cat_prmarketing` char(1) NOT NULL DEFAULT '0',
  `cat_sales` char(1) NOT NULL DEFAULT '0',
  `cat_healthcare` char(1) NOT NULL DEFAULT '0',
  `cat_other` char(1) NOT NULL DEFAULT '0',
  `Title` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Title_ge` varchar(192) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Employer` varchar(64) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `Employer_ge` varchar(192) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `location` varchar(255) NOT NULL DEFAULT '',
  `location_ge` varchar(255) NOT NULL DEFAULT '',
  `DutyStation` varchar(64) CHARACTER SET latin1 DEFAULT '',
  `Published` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `Updated` date NOT NULL DEFAULT '0000-00-00',
  `Deadline` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `AttachedFile` varchar(128) CHARACTER SET latin1 DEFAULT '',
  `JobText` text CHARACTER SET latin1 NOT NULL,
  `JobText_ge` longtext CHARACTER SET latin1 NOT NULL,
  `notes` text NOT NULL,
  `searchindex` longtext CHARACTER SET latin1 NOT NULL,
  `hits` int(8) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `RecordTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `location_idz` varchar(500) NOT NULL DEFAULT '',
  `invoice_sent` tinyint(4) NOT NULL,
  `invoice_sent_date` date NOT NULL,
  `money_paid` tinyint(4) NOT NULL,
  `money_paid_date` date NOT NULL,
  `mailing_list_idz` varchar(500) NOT NULL,
  `sent_to_mailing_lists` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Title` (`Title`,`Employer`,`Published`,`RecordTime`),
  KEY `logo` (`logo`),
  KEY `Title_ge` (`Title_ge`),
  KEY `Employer_ge` (`Employer_ge`),
  KEY `hits` (`hits`),
  KEY `status` (`status`),
  KEY `type` (`type`),
  KEY `salary` (`salary`),
  KEY `cat_law` (`cat_law`,`cat_finance`,`cat_admin`,`cat_it`,`cat_technical`,`cat_prmarketing`,`cat_sales`,`cat_healthcare`,`cat_other`),
  KEY `eng_text` (`eng_text`,`geo_text`),
  KEY `client_id` (`client_id`),
  KEY `Published` (`Published`,`category`,`geo_text`),
  KEY `Published_2` (`Published`,`category`,`eng_text`),
  KEY `Published_3` (`Published`,`category`,`cat_law`),
  KEY `Published_4` (`Published`,`category`,`cat_finance`),
  KEY `Published_5` (`Published`,`category`,`cat_admin`),
  KEY `Published_6` (`Published`,`category`,`cat_it`),
  KEY `Published_7` (`Published`,`category`,`cat_technical`),
  KEY `Published_8` (`Published`,`category`,`cat_technical`),
  KEY `Published8` (`Published`,`category`,`cat_prmarketing`),
  KEY `Published9` (`Published`,`category`,`cat_sales`),
  KEY `Published10` (`Published`,`category`,`cat_healthcare`),
  KEY `Published11` (`Published`,`category`,`cat_other`),
  KEY `Published12` (`Published`,`Deadline`,`category`,`eng_text`),
  KEY `Published13` (`Published`,`Deadline`,`category`,`geo_text`),
  KEY `Published14` (`Published`,`Deadline`,`category`,`cat_law`),
  KEY `Published15` (`Published`,`Deadline`,`category`,`cat_finance`),
  KEY `Published16` (`Published`,`Deadline`,`category`,`cat_admin`),
  KEY `Published17` (`Published`,`Deadline`,`category`,`cat_it`),
  KEY `Published18` (`Published`,`Deadline`,`category`,`cat_technical`),
  KEY `Published19` (`Published`,`Deadline`,`category`,`cat_prmarketing`),
  KEY `Published20` (`Published`,`Deadline`,`category`,`cat_sales`),
  KEY `Published21` (`Published`,`Deadline`,`category`,`cat_healthcare`),
  KEY `Published22` (`Published`,`Deadline`,`category`,`cat_other`),
  KEY `invoice_sent` (`invoice_sent`,`invoice_sent_date`,`money_paid`),
  KEY `vip_2` (`vip`,`Deadline`,`category`,`Published`),
  KEY `status_2` (`status`,`sent_to_mailing_lists`,`Published`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=73407 ;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ge` varchar(500) NOT NULL,
  `name_en` varchar(500) NOT NULL,
  `priority` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `name_ge` (`name_ge`),
  KEY `name_en` (`name_en`),
  KEY `priority` (`priority`,`name_ge`),
  KEY `priority_2` (`priority`,`name_en`),
  KEY `name_ge_2` (`name_ge`,`priority`),
  KEY `name_en_2` (`name_en`,`priority`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
CREATE TABLE IF NOT EXISTS `log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip` varchar(16) NOT NULL DEFAULT '',
  `uri` varchar(255) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `mailing_lists`
--

DROP TABLE IF EXISTS `mailing_lists`;
CREATE TABLE IF NOT EXISTS `mailing_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_ge` varchar(255) NOT NULL,
  `name_en` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `parent_id` int(11) NOT NULL,
  `category_idz` varchar(500) NOT NULL,
  `location_idz` varchar(500) NOT NULL,
  `cat_idz` varchar(500) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=48 ;

-- --------------------------------------------------------

--
-- Table structure for table `mailing_lists_actions`
--

DROP TABLE IF EXISTS `mailing_lists_actions`;
CREATE TABLE IF NOT EXISTS `mailing_lists_actions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ip` varchar(30) NOT NULL,
  `browser` varchar(255) NOT NULL,
  `action` varchar(30) NOT NULL,
  `email` varchar(100) NOT NULL,
  `mailing_lists_id` int(11) NOT NULL,
  `done` tinyint(4) NOT NULL,
  `done_dt` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
CREATE TABLE IF NOT EXISTS `resources` (
  `id` int(8) NOT NULL AUTO_INCREMENT,
  `Title` varchar(255) NOT NULL DEFAULT '',
  `ResourceText` text NOT NULL,
  `Link` varchar(255) NOT NULL DEFAULT '',
  `Published` date NOT NULL DEFAULT '0000-00-00',
  `RecordTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `subscription`
--

DROP TABLE IF EXISTS `subscription`;
CREATE TABLE IF NOT EXISTS `subscription` (
  `subscribe` text NOT NULL,
  `unsubscribe` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(24) NOT NULL DEFAULT '',
  `password` varchar(16) NOT NULL DEFAULT '',
  `permission` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `fullname` varchar(128) NOT NULL DEFAULT '',
  `email` varchar(128) NOT NULL DEFAULT '',
  `phone` varchar(128) NOT NULL DEFAULT '',
  `reference` varchar(128) NOT NULL DEFAULT '',
  `comments` text NOT NULL,
  `lastupdated` varchar(24) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `username` (`username`,`password`,`permission`,`status`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=19 ;

-- --------------------------------------------------------

--
-- Table structure for table `validation`
--

DROP TABLE IF EXISTS `validation`;
CREATE TABLE IF NOT EXISTS `validation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(64) NOT NULL DEFAULT '',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `action` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `email` varchar(128) NOT NULL DEFAULT '',
  `datetime` date NOT NULL DEFAULT '0000-00-00',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mailing_lists_ids` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hash` (`hash`,`status`,`datetime`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31409 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
