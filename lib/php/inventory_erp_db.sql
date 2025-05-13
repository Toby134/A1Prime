-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 13, 2025 at 04:27 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `inventory_erp_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `branch`
--

CREATE TABLE `branch` (
  `Bra_No` varchar(10) NOT NULL DEFAULT '',
  `Bra_Name` varchar(50) DEFAULT NULL,
  `Bra_Name2` varchar(6) DEFAULT NULL,
  `Bra_Addr` varchar(150) DEFAULT NULL,
  `Bra_Tel` varchar(50) DEFAULT NULL,
  `Bra_Mgr` varchar(10) DEFAULT NULL,
  `Bra_Visor` varchar(10) DEFAULT NULL,
  `Bra_IT` varchar(10) DEFAULT NULL,
  `Bra_TIN` varchar(20) DEFAULT NULL,
  `Bra_Email` varchar(150) DEFAULT NULL,
  `IsVatable` enum('1','0') DEFAULT '0',
  `tmpBCode` char(3) DEFAULT NULL,
  `IsInventoryLock` enum('0','1') DEFAULT '0',
  `IsActive` enum('0','1') DEFAULT '0',
  `IsReport` enum('0','1') DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `branch`
--

INSERT INTO `branch` (`Bra_No`, `Bra_Name`, `Bra_Name2`, `Bra_Addr`, `Bra_Tel`, `Bra_Mgr`, `Bra_Visor`, `Bra_IT`, `Bra_TIN`, `Bra_Email`, `IsVatable`, `tmpBCode`, `IsInventoryLock`, `IsActive`, `IsReport`) VALUES
('GX-000', '3GX MAIN', 'MAIN', 'ELIAS ANGELES ST. DINAGA NAGA CITY', '', '', '', '', '', NULL, '1', '000', '0', '1', '1'),
('GX-003', '3GX LEGASPI', 'LEGZ', 'PUROK 2, OROSITE, LEGAZPI CITY', '', '', '', '', '', NULL, '1', '004', '0', '1', '1'),
('GX-004', '3GX TABACO', 'TABA', 'RIOSA ST', '', '', '', '', '', NULL, '1', '008', '0', '1', '1'),
('GX-016', '3GX DAET', 'DAET', 'PASIG, DAET, CAMARINES NORTE', '', '', '', '', '', NULL, '0', NULL, '0', '1', '0'),
('GX-019', '3GX SORSOGON', 'SORS', 'MAOGMA BLDG., SORSOGON CITY', '', '', '', '', '', NULL, '0', NULL, '0', '1', '0');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `ID` int(10) UNSIGNED NOT NULL,
  `Item_No` varchar(11) NOT NULL DEFAULT '',
  `Cat_No` int(10) UNSIGNED DEFAULT NULL,
  `Item_Desc` varchar(255) DEFAULT NULL,
  `Item_Desc_Label` varchar(30) DEFAULT NULL,
  `Brand` varchar(30) DEFAULT NULL,
  `Model` varchar(30) DEFAULT NULL,
  `Cost` decimal(8,2) UNSIGNED ZEROFILL DEFAULT 000000.00,
  `IsCostPrice` enum('1','0') DEFAULT '0',
  `Item_Price` decimal(10,2) DEFAULT 0.00,
  `IsPriceList` enum('0','1') DEFAULT '1',
  `Qty` double(9,0) DEFAULT 0,
  `QtyAsset` double DEFAULT 0,
  `Unit_Meas` varchar(10) DEFAULT NULL,
  `Color` varchar(20) DEFAULT NULL,
  `Size` varchar(20) DEFAULT NULL,
  `Weight` int(9) UNSIGNED ZEROFILL DEFAULT 000000000,
  `Weight_Unit` varchar(10) DEFAULT NULL,
  `Spec_Feat` varchar(1000) DEFAULT NULL,
  `Item_Pics` varchar(200) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  `Upcode` varchar(30) DEFAULT NULL,
  `Barcode` varchar(30) DEFAULT NULL,
  `Serialized` char(1) DEFAULT NULL,
  `Assembly` char(1) DEFAULT NULL,
  `Taxable` char(1) DEFAULT NULL,
  `Last_Inv_Date` datetime DEFAULT NULL,
  `Freight_Cost` decimal(8,2) UNSIGNED ZEROFILL DEFAULT 000000.00,
  `Last_Order_Date` datetime DEFAULT NULL,
  `Expect_Del` datetime DEFAULT NULL,
  `Qty_Last_Order` int(9) UNSIGNED ZEROFILL DEFAULT 000000000,
  `ReOrder_Pt` int(9) UNSIGNED ZEROFILL DEFAULT 000000000,
  `Last_Cost_Supp` decimal(8,2) UNSIGNED ZEROFILL DEFAULT NULL,
  `Min_Price` decimal(8,2) UNSIGNED ZEROFILL DEFAULT NULL,
  `Max_Price` decimal(8,2) UNSIGNED ZEROFILL DEFAULT 000000.00,
  `Qty_Order` int(9) UNSIGNED ZEROFILL DEFAULT NULL,
  `Warranty` int(11) DEFAULT 0,
  `Active` char(1) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL,
  `LastDate_Update` datetime DEFAULT NULL,
  `IsBoutique` enum('1','0') DEFAULT '0',
  `IsFixAsset` enum('1','0') DEFAULT '0',
  `IsRegularItem` enum('1','0') DEFAULT '1',
  `IsAssetItem` enum('1','0') DEFAULT '0',
  `IsTechnoCardRedeem` enum('0','1') DEFAULT '0',
  `Cat_No_Asset` int(11) DEFAULT NULL,
  `IsReprice` enum('1','0') DEFAULT '0',
  `IsOrder` enum('1','0') DEFAULT '0',
  `IsLoadSIM` enum('1','0') DEFAULT '0',
  `IsPrintWarranty` enum('1','0') DEFAULT '0',
  `Item_Pix` blob DEFAULT NULL,
  `Item_Pix_Filename` varchar(150) DEFAULT NULL,
  `Item_Pix2_Filename` varchar(150) DEFAULT NULL,
  `Item_Icon` varchar(150) DEFAULT 'no_icon.ico',
  `ItemTempID` int(11) DEFAULT NULL,
  `ReferRebatePercent` double DEFAULT 0,
  `CreatedBy` varchar(10) DEFAULT NULL,
  `DateCreated` datetime DEFAULT NULL,
  `ModifiedBy` varchar(10) DEFAULT NULL,
  `DateModified` datetime DEFAULT NULL,
  `BullGuardPromo` enum('0','1','2') DEFAULT '0' COMMENT '0-Not in promo;1-Selected item promo;2-Buy1Take1',
  `IsPackage` enum('0','1') DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`ID`, `Item_No`, `Cat_No`, `Item_Desc`, `Item_Desc_Label`, `Brand`, `Model`, `Cost`, `IsCostPrice`, `Item_Price`, `IsPriceList`, `Qty`, `QtyAsset`, `Unit_Meas`, `Color`, `Size`, `Weight`, `Weight_Unit`, `Spec_Feat`, `Item_Pics`, `Location`, `Upcode`, `Barcode`, `Serialized`, `Assembly`, `Taxable`, `Last_Inv_Date`, `Freight_Cost`, `Last_Order_Date`, `Expect_Del`, `Qty_Last_Order`, `ReOrder_Pt`, `Last_Cost_Supp`, `Min_Price`, `Max_Price`, `Qty_Order`, `Warranty`, `Active`, `LastDate_Update`, `IsBoutique`, `IsFixAsset`, `IsRegularItem`, `IsAssetItem`, `IsTechnoCardRedeem`, `Cat_No_Asset`, `IsReprice`, `IsOrder`, `IsLoadSIM`, `IsPrintWarranty`, `Item_Pix`, `Item_Pix_Filename`, `Item_Pix2_Filename`, `Item_Icon`, `ItemTempID`, `ReferRebatePercent`, `CreatedBy`, `DateCreated`, `ModifiedBy`, `DateModified`, `BullGuardPromo`, `IsPackage`) VALUES
(1, '00001', 1, '3X3 RCA CORD ORDINARY', '3X3 RCA CORD ORDINA', '', '', 000020.00, '0', 30.00, '1', 80, 0, 'PC(S)', '', '', 000000000, '', '', '', '', '', '3760000000017', 'N', 'N', 'N', '2015-08-13 00:00:00', 000000.00, '2021-03-27 00:00:00', '2016-01-13 00:00:00', 000000100, 000000000, NULL, 000025.00, 000000.00, 000000000, 0, 'Y', '2021-04-14 10:24:17', '0', '0', '1', '1', '0', 3, '1', '0', '0', '0', NULL, 'part2.JPG', '', 'no_icon.ico', 5052, 2, NULL, NULL, 'melvin', '2021-04-14 10:24:34', '0', '0'),
(2, '00002', 1005461, 'PANEL METER LION  SO-52 AC 300V', 'PANEL METER LION  S', 'none', '', 000170.00, '0', 250.00, '1', 0, 0, '', '', '', 000000000, '', '', '', '', '', '3760000000024', 'N', 'N', 'N', '2015-09-04 00:00:00', 000000.00, '2015-05-19 00:00:00', '2008-02-28 00:00:00', 000000010, 000000000, NULL, 000230.00, 000000.00, 000000000, 0, 'Y', '2017-11-28 11:06:12', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, 'qty.JPG', '', 'no_icon.ico', 5052, 2, NULL, NULL, 'melvin', '2017-11-28 11:05:49', '0', '0'),
(3, '00003', 25, 'CRT SOCKET FOR  SONY 06-9Y30', NULL, '', NULL, 000045.00, '0', 85.00, '1', -2, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2013-01-30 00:00:00', 000000.00, '2008-05-16 00:00:00', '2008-05-16 00:00:00', 000000000, 000000000, NULL, 000045.00, 000000.00, 000000000, 0, 'Y', '2014-04-29 11:06:00', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, NULL, NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(4, '00005', 1005461, 'WOODSCREW SMALL', NULL, '', '', 000000.00, '0', 0.00, '1', -16, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2008-05-20 00:00:00', 000000.00, '2010-04-24 00:00:00', '2008-05-20 00:00:00', 000000100, 000000000, NULL, 000000.00, 000000.00, 000000000, 0, 'N', '2015-08-14 14:10:21', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '00005-woodscrewsmall.jpg', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(5, '00006', 1005461, 'WOODSCREW LARGE', 'WOODSCREW LARGE', '', '', 000000.00, '0', 1.00, '1', 130, 0, '', '', '', 000000000, '', '', '', '', '', '3760000000062', 'N', 'N', 'N', '2011-01-18 00:00:00', 000000.00, '2010-02-19 00:00:00', '2008-05-20 00:00:00', 000000005, 000000000, NULL, 000000.00, 000000.00, 000000000, 0, 'Y', '2018-05-20 16:21:08', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '', '', 'no_icon.ico', 5052, 2, NULL, NULL, 'jeramy', '2018-05-20 16:20:56', '0', '0'),
(6, '0001', 6238, 'KPC139ZEN 1/3\" COLOR IR CAMERA (35 LED) HIGH RESOLUTION', NULL, 'GTECH', NULL, 001666.00, '0', 4950.00, '1', 122, 0, 'PC(S)', 'Silver', '', 000000000, NULL, 'HI-RESOLUTION / 35 L', '', '', '', NULL, 'N', 'N', 'N', '2018-08-24 00:00:00', 000000.00, '2013-10-03 00:00:00', '2013-08-08 00:00:00', 000000015, 000000000, NULL, 001666.00, 000000.00, 000000000, 12, 'Y', '2014-02-11 15:59:54', '0', '0', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, '6238.jpg', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(7, '00014', 6212, 'APOLLO 500VA UPS', NULL, '', NULL, 001350.00, '0', 1980.00, '1', 0, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2006-11-01 00:00:00', 000000.00, '2010-01-05 00:00:00', '2006-11-01 00:00:00', 000000003, 000000000, NULL, 001350.00, 000000.00, 000000000, 0, 'Y', '2014-05-19 13:44:03', '0', '1', '1', '1', '0', 3, '1', '0', '0', '0', NULL, '', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(8, '0002', 6238, '1/3\" COLOR IR DOME (21 LED) HIGH RESOLUTION BLACK BASE (KPC-133ZEN)', '1/3\" COLOR IR DOME', '', '', 004000.00, '0', 4850.00, '1', -18, 0, '', '', '', 000000000, NULL, '', '', '', '', '3760000000024', 'N', 'N', 'N', '2018-08-24 00:00:00', 000000.00, '2013-02-22 00:00:00', '2011-10-22 00:00:00', 000000006, 000000000, NULL, 004600.00, 000000.00, 000000000, 0, 'Y', '2018-12-26 13:40:31', '0', '1', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '', '', 'no_icon.ico', 5052, 2, NULL, NULL, 'melvin', '2018-12-26 13:40:48', '0', '0'),
(9, '00022', 6234, 'MIC HOLDER SLIDE TYPE', NULL, '', '', 000022.00, '0', 40.00, '1', 30, 0, 'PCS', '', '', 000000000, NULL, '', '', '', '', NULL, 'N', 'N', 'N', '2015-09-04 00:00:00', 000000.00, '2014-02-15 00:00:00', '2014-02-17 00:00:00', 000000010, 000000000, NULL, 000035.00, 000000.00, 000000000, 0, 'Y', '2015-08-14 15:02:41', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(10, '00027', 1, 'TELEPHONE CORD 5M', NULL, '', NULL, 000015.00, '0', 48.00, '1', -10, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2006-09-11 00:00:00', 000000.00, '2015-01-17 00:00:00', '2009-11-28 00:00:00', 000000015, 000000000, NULL, 000030.00, 000035.00, 000000000, 0, 'Y', '2012-04-17 16:59:05', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, NULL, NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(11, '00028', 1005470, 'EXPLOIT 6\" COMBINATION PLIERS', NULL, '', '', 000110.00, '0', 0.00, '1', 0, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2010-06-09 00:00:00', 000000.00, '2007-08-12 00:00:00', '2007-08-12 00:00:00', 000000000, 000000000, NULL, 000110.00, 000000.00, 000000000, 0, 'Y', '2016-09-19 10:12:16', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, 'melvin', '2016-09-19 10:12:22', '0', '0'),
(12, '00029', 1005461, 'MEIKO MLN-8\" LONG NOSE PLIER', NULL, '', '', 000160.00, '0', 0.00, '1', 0, 0, '', '', '', 000000000, '', '', '', '', '', NULL, 'N', 'N', 'N', '2015-09-04 00:00:00', 000000.00, '2007-08-12 00:00:00', '2007-08-12 00:00:00', 000000000, 000000000, NULL, 000160.00, 000000.00, 000000000, 0, 'Y', '2015-08-14 15:30:47', '0', '0', '1', '0', '0', NULL, '1', '0', '0', '0', NULL, '', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(13, '0003', 6238, 'GXT-ED500-B 1/3\" 500TVL EFFIO DOME CAMERA', NULL, '', NULL, 001300.00, '0', 1980.00, '1', -5, 0, '', '', '', 000000000, NULL, '', '', '', '', NULL, 'N', 'N', 'N', '2015-08-13 00:00:00', 000000.00, '2016-09-29 00:00:00', '2013-10-10 00:00:00', 000000002, 000000000, NULL, 001400.00, 000000.00, 000000000, 0, 'Y', '2014-01-23 16:30:59', '0', '1', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, '', NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(14, '00030', 6234, 'METAL RUBBER INDUSTRIAL (METER)', 'METAL RUBBER INDUST', '', '', 000000.00, '0', 85.00, '1', -20, 0, '', '', '', 000000000, NULL, '', '', '', '', '3760000000307', 'N', 'N', 'N', '2013-08-15 00:00:00', 000000.00, '2013-08-15 00:00:00', '2013-08-15 00:00:00', 000000000, 000000000, NULL, 000000.00, 000000.00, 000000000, 0, 'Y', '2019-07-07 09:19:59', '0', '1', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, '', '', 'no_icon.ico', 5052, 2, NULL, NULL, 'jeramy', '2019-07-07 09:19:48', '0', '0'),
(15, '0004', 6238, '1/3\" COLOR HIGH RESOLUTION DOME CAMERA', NULL, '', NULL, 002000.00, '0', 3250.00, '1', 0, 0, '', '', '', 000000000, NULL, '', '', '', '', NULL, 'N', 'N', 'N', '2009-12-24 00:00:00', 000000.00, '2010-03-29 00:00:00', '2010-03-10 00:00:00', 000000002, 000000000, NULL, 002000.00, 000000.00, 000000000, 0, 'Y', '2009-12-24 00:12:48', '0', '1', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, NULL, NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(16, '0005', 6238, '1/3\" COLOR (21 LED) HIGH RESOLUTION IR CAMERA', NULL, '', NULL, 004200.00, '0', 5200.00, '1', 0, 0, '', '', '', 000000000, NULL, '', '', '', '', NULL, 'N', 'N', 'N', '2009-12-24 00:00:00', 000000.00, '2009-12-24 00:00:00', '2009-12-24 00:00:00', 000000000, 000000000, NULL, 004200.00, 000000.00, 000000000, 0, 'Y', '2009-12-24 00:14:45', '0', '1', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, NULL, NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0'),
(17, '0006', 6238, '1/3\" COLOR IR DOME CAMERA', NULL, '', NULL, 003400.00, '0', 4500.00, '1', 0, 0, '', '', '', 000000000, NULL, '', '', '', '', NULL, 'N', 'N', 'N', '2009-12-24 00:00:00', 000000.00, '2009-12-24 00:00:00', '2009-12-24 00:00:00', 000000000, 000000000, NULL, 004500.00, 000000.00, 000000000, 0, 'Y', '2012-02-10 17:20:15', '0', '1', '1', '0', '0', NULL, '0', '0', '0', '0', NULL, NULL, NULL, 'no_icon.ico', 5052, 2, NULL, NULL, NULL, NULL, '0', '0');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_branch`
--

CREATE TABLE `inventory_branch` (
  `Bra_No` varchar(10) DEFAULT '',
  `Item_No` varchar(11) DEFAULT '',
  `Item_Pix_FileName` varchar(255) DEFAULT NULL,
  `Bra_Qty` double(9,0) DEFAULT 0,
  `Bra_Qty_Asset` double DEFAULT 0,
  `Cost` double DEFAULT 0,
  `Price` double DEFAULT 0,
  `LastDate_Update` datetime DEFAULT NULL,
  `ID` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `inventory_branch`
--

INSERT INTO `inventory_branch` (`Bra_No`, `Item_No`, `Item_Pix_FileName`, `Bra_Qty`, `Bra_Qty_Asset`, `Cost`, `Price`, `LastDate_Update`, `ID`) VALUES
('GX-000', '00001', NULL, 15, 0, 20, 30, '2023-01-15 10:00:00', 1509549),
('GX-003', '00001', NULL, 20, 0, 20, 30, '2023-01-16 11:00:00', 1509550),
('GX-004', '00001', NULL, 25, 0, 20, 30, '2023-01-17 12:00:00', 1509551),
('GX-016', '00001', NULL, 10, 0, 20, 30, '2023-01-18 13:00:00', 1509552),
('GX-019', '00001', NULL, 10, 0, 20, 30, '2023-01-19 14:00:00', 1509553),
('GX-000', '00002', NULL, 0, 0, 170, 250, '2023-02-10 09:00:00', 1509554),
('GX-003', '00002', NULL, 2, 0, 170, 250, '2023-02-11 10:00:00', 1509555),
('GX-004', '00002', NULL, 1, 0, 170, 250, '2023-02-12 11:00:00', 1509556),
('GX-016', '00002', NULL, 0, 0, 170, 250, '2023-02-13 12:00:00', 1509557),
('GX-019', '00002', NULL, 0, 0, 170, 250, '2023-02-14 13:00:00', 1509558),
('GX-000', '00006', NULL, 30, 0, 0, 1, '2023-03-05 08:00:00', 1509559),
('GX-003', '00006', NULL, 40, 0, 0, 1, '2023-03-06 09:00:00', 1509560),
('GX-004', '00006', NULL, 25, 0, 0, 1, '2023-03-07 10:00:00', 1509561),
('GX-016', '00006', NULL, 20, 0, 0, 1, '2023-03-08 11:00:00', 1509562),
('GX-019', '00006', NULL, 15, 0, 0, 1, '2023-03-09 12:00:00', 1509563),
('GX-000', '0001', NULL, 10, 0, 1666, 4950, '2023-04-20 14:00:00', 1509564),
('GX-003', '0001', NULL, 15, 0, 1666, 4950, '2023-04-21 15:00:00', 1509565),
('GX-004', '0001', NULL, 20, 0, 1666, 4950, '2023-04-22 16:00:00', 1509566),
('GX-016', '0001', NULL, 25, 0, 1666, 4950, '2023-04-23 17:00:00', 1509567),
('GX-019', '0001', NULL, 52, 0, 1666, 4950, '2023-04-24 18:00:00', 1509568),
('GX-000', '00022', NULL, 5, 0, 22, 40, '2023-05-10 10:30:00', 1509569),
('GX-003', '00022', NULL, 8, 0, 22, 40, '2023-05-11 11:30:00', 1509570),
('GX-004', '00022', NULL, 7, 0, 22, 40, '2023-05-12 12:30:00', 1509571),
('GX-016', '00022', NULL, 5, 0, 22, 40, '2023-05-13 13:30:00', 1509572),
('GX-019', '00022', NULL, 5, 0, 22, 40, '2023-05-14 14:30:00', 1509573),
('GX-000', '0003', NULL, 1, 0, 1300, 1980, '2023-06-15 09:15:00', 1509574),
('GX-003', '0003', NULL, 2, 0, 1300, 1980, '2023-06-16 10:15:00', 1509575),
('GX-004', '0003', NULL, 1, 0, 1300, 1980, '2023-06-17 11:15:00', 1509576),
('GX-016', '0003', NULL, 0, 0, 1300, 1980, '2023-06-18 12:15:00', 1509577),
('GX-019', '0003', NULL, 1, 0, 1300, 1980, '2023-06-19 13:15:00', 1509578),
('GX-000', '0005', NULL, 0, 0, 4200, 5200, '2023-07-01 14:45:00', 1509579),
('GX-003', '0005', NULL, 1, 0, 4200, 5200, '2023-07-02 15:45:00', 1509580),
('GX-004', '0005', NULL, 0, 0, 4200, 5200, '2023-07-03 16:45:00', 1509581),
('GX-016', '0005', NULL, 0, 0, 4200, 5200, '2023-07-04 17:45:00', 1509582),
('GX-019', '0005', NULL, 1, 0, 4200, 5200, '2023-07-05 18:45:00', 1509583);

-- --------------------------------------------------------

--
-- Table structure for table `inventory_count`
--

CREATE TABLE `inventory_count` (
  `ID` int(11) UNSIGNED NOT NULL,
  `Item_No` varchar(11) DEFAULT NULL,
  `Bra_No` varchar(10) DEFAULT NULL,
  `Count` double DEFAULT 0,
  `CountUser` varchar(10) DEFAULT NULL,
  `IsPost` enum('0','1') DEFAULT '0',
  `SeqNo` varchar(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `inventory_count`
--

INSERT INTO `inventory_count` (`ID`, `Item_No`, `Bra_No`, `Count`, `CountUser`, `IsPost`, `SeqNo`) VALUES
(1, '00001', 'GX-000', 24, 'current_us', '0', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_id`
--

CREATE TABLE `user_id` (
  `ID` int(10) UNSIGNED NOT NULL,
  `Uname` varchar(10) NOT NULL DEFAULT '',
  `Email` varchar(255) NOT NULL,
  `Pword` varchar(255) DEFAULT NULL,
  `password` varchar(25) DEFAULT NULL,
  `Emp_No` char(8) DEFAULT NULL,
  `Utype` varchar(10) DEFAULT NULL,
  `Last_Pass` date DEFAULT NULL,
  `IsWhatsNew` enum('0','1') DEFAULT '1'
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user_id`
--

INSERT INTO `user_id` (`ID`, `Uname`, `Email`, `Pword`, `password`, `Emp_No`, `Utype`, `Last_Pass`, `IsWhatsNew`) VALUES
(1, 'user', '', '', 'user', '0422-001', 'User', NULL, '1'),
(2, 'Adrey', 'ajrafallo@gmail.com', '$2y$10$NnCjdLxvVlxiJShcEpWIB.B.K62B0yXttSi3wG.qS0bhRiKUleaAS', NULL, '1', 'employee', NULL, '1'),
(3, 'testuser', 'test@example.com', '$2y$10$hpZwFrUN5Nvjn1//j.hxjekqIavvHdpuKI1MoOstWbY7IHgbsJr3S', NULL, 'EMP001', 'admin', NULL, '1');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `branch`
--
ALTER TABLE `branch`
  ADD PRIMARY KEY (`Bra_No`),
  ADD UNIQUE KEY `indx_no` (`Bra_No`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `indx_id` (`ID`),
  ADD KEY `indx_no` (`Cat_No`),
  ADD KEY `indx_desc` (`Item_Desc`),
  ADD KEY `indx_upc` (`Upcode`),
  ADD KEY `indx_label` (`Item_Desc_Label`),
  ADD KEY `indx_brand` (`Brand`),
  ADD KEY `indx_barcode` (`Barcode`),
  ADD KEY `indx_item` (`Item_No`);

--
-- Indexes for table `inventory_branch`
--
ALTER TABLE `inventory_branch`
  ADD PRIMARY KEY (`ID`) USING BTREE,
  ADD KEY `indx_bra` (`Bra_No`),
  ADD KEY `indx_item` (`Item_No`);

--
-- Indexes for table `inventory_count`
--
ALTER TABLE `inventory_count`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `user_id`
--
ALTER TABLE `user_id`
  ADD PRIMARY KEY (`ID`,`Uname`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `inventory_branch`
--
ALTER TABLE `inventory_branch`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1509584;

--
-- AUTO_INCREMENT for table `inventory_count`
--
ALTER TABLE `inventory_count`
  MODIFY `ID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `user_id`
--
ALTER TABLE `user_id`
  MODIFY `ID` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
