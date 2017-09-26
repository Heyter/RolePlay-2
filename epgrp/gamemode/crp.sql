/*
Navicat MySQL Data Transfer

Source Server         : Webspace
Source Server Version : 50717
Source Host           : 62.75.253.86:3306
Source Database       : crp

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2017-09-26 23:27:23
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for busstops
-- ----------------------------
DROP TABLE IF EXISTS `busstops`;
CREATE TABLE `busstops` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `cost` int(11) NOT NULL,
  `pos` text NOT NULL,
  `ang` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for cell_positions
-- ----------------------------
DROP TABLE IF EXISTS `cell_positions`;
CREATE TABLE `cell_positions` (
  `map` text NOT NULL,
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for Doors
-- ----------------------------
DROP TABLE IF EXISTS `Doors`;
CREATE TABLE `Doors` (
  `title` text NOT NULL,
  `cost` int(11) NOT NULL,
  `teams` text NOT NULL,
  `position` text NOT NULL,
  `subdoors` text NOT NULL,
  `preview` text NOT NULL,
  `locked` int(11) NOT NULL,
  `map` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for garage
-- ----------------------------
DROP TABLE IF EXISTS `garage`;
CREATE TABLE `garage` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `player_sid` text NOT NULL,
  `carname` text NOT NULL,
  `col_r` int(11) NOT NULL DEFAULT '255',
  `col_g` int(11) NOT NULL DEFAULT '255',
  `col_b` int(11) NOT NULL DEFAULT '255',
  `Skin` int(11) NOT NULL DEFAULT '0',
  `Tunings` text NOT NULL,
  `Fuel` int(11) NOT NULL DEFAULT '100',
  `Health` int(11) NOT NULL DEFAULT '100',
  `car_number` text NOT NULL,
  `Model` text NOT NULL,
  `data` text NOT NULL,
  `purchase_date` int(11) NOT NULL,
  `Armor` int(11) NOT NULL,
  `repair` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orgs_npcs
-- ----------------------------
DROP TABLE IF EXISTS `orgs_npcs`;
CREATE TABLE `orgs_npcs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pos` text NOT NULL,
  `angle` text NOT NULL,
  `map` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orgs_orgs
-- ----------------------------
DROP TABLE IF EXISTS `orgs_orgs`;
CREATE TABLE `orgs_orgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `motd` text NOT NULL,
  `bankbalance` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orgs_players
-- ----------------------------
DROP TABLE IF EXISTS `orgs_players`;
CREATE TABLE `orgs_players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamid` text NOT NULL,
  `name` text NOT NULL,
  `rank` text NOT NULL,
  `orgid` int(11) NOT NULL,
  `lastseen` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for orgs_ranks
-- ----------------------------
DROP TABLE IF EXISTS `orgs_ranks`;
CREATE TABLE `orgs_ranks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `flags` text NOT NULL,
  `orgid` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for players
-- ----------------------------
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `index` int(11) NOT NULL AUTO_INCREMENT,
  `sid` text NOT NULL,
  `rpname` text NOT NULL,
  `cash` int(11) NOT NULL,
  `bank_cash` int(11) NOT NULL,
  `playtime` int(11) NOT NULL,
  `playermodel` text NOT NULL,
  `clan` int(11) NOT NULL,
  `skills` text NOT NULL,
  `skill_points` int(11) NOT NULL DEFAULT '0',
  `bodysize` int(11) NOT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=77 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for premium
-- ----------------------------
DROP TABLE IF EXISTS `premium`;
CREATE TABLE `premium` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sid` text NOT NULL,
  `amount` int(11) NOT NULL,
  `received` int(11) NOT NULL,
  `expires` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
