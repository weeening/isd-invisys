-- phpMyAdmin SQL Dump
-- version 4.5.1
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 13, 2017 at 04:10 PM
-- Server version: 10.1.19-MariaDB
-- PHP Version: 7.0.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `invsys`
--

-- --------------------------------------------------------

--
-- Table structure for table `auth_assignment`
--

CREATE TABLE `auth_assignment` (
  `item_name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `auth_assignment`
--

INSERT INTO `auth_assignment` (`item_name`, `user_id`, `created_at`) VALUES
('admin', 'a001', NULL),
('admin', 'a002', NULL),
('staff', 'u001', NULL),
('staff', 'u002', 1486916041),
('staff', 'u003', 1486958950);

-- --------------------------------------------------------

--
-- Table structure for table `auth_item`
--

CREATE TABLE `auth_item` (
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `type` smallint(6) NOT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `rule_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` blob,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `auth_item`
--

INSERT INTO `auth_item` (`name`, `type`, `description`, `rule_name`, `data`, `created_at`, `updated_at`) VALUES
('admin', 1, NULL, NULL, NULL, NULL, NULL),
('staff', 1, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `auth_item_child`
--

CREATE TABLE `auth_item_child` (
  `parent` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `child` varchar(64) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `auth_item_child`
--

INSERT INTO `auth_item_child` (`parent`, `child`) VALUES
('admin', 'staff');

-- --------------------------------------------------------

--
-- Table structure for table `auth_rule`
--

CREATE TABLE `auth_rule` (
  `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `data` blob,
  `created_at` int(11) DEFAULT NULL,
  `updated_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migration`
--

CREATE TABLE `migration` (
  `version` varchar(180) NOT NULL,
  `apply_time` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `migration`
--

INSERT INTO `migration` (`version`, `apply_time`) VALUES
('m000000_000000_base', 1486905378),
('m140506_102106_rbac_init', 1486905522);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` varchar(100) NOT NULL,
  `ven_id` varchar(100) NOT NULL,
  `sta_id` varchar(100) NOT NULL,
  `order_quantity` int(11) DEFAULT NULL,
  `order_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `ven_id`, `sta_id`, `order_quantity`, `order_date`) VALUES
('o001', 'v003', 's004', 20, '2017-02-13'),
('o002', 'v002', 's003', 23, '2017-02-13');

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `addstock` AFTER INSERT ON `orders` FOR EACH ROW UPDATE stationery s
SET s.sta_quantity = s.sta_quantity + new.order_quantity
WHERE s.sta_id = new.sta_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `correctstock` AFTER DELETE ON `orders` FOR EACH ROW UPDATE stationery s SET s.sta_quantity = s.sta_quantity - old.order_quantity WHERE s.sta_id = old.sta_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reserve`
--

CREATE TABLE `reserve` (
  `res_id` varchar(100) NOT NULL,
  `user_id` varchar(100) DEFAULT NULL,
  `sta_id` varchar(100) DEFAULT NULL,
  `res_quantity` int(11) DEFAULT NULL,
  `res_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `reserve`
--

INSERT INTO `reserve` (`res_id`, `user_id`, `sta_id`, `res_quantity`, `res_date`) VALUES
('0.11844200 1486963757', 'u002', 's003', 3, '2017-02-13'),
('0.37921400 1486959002', 'a001', 's004', 5, '2017-02-13'),
('0.89891600 1486963561', 'u002', 's001', 10, '2017-02-13'),
('0.95032300 1486997789', 'a001', 's002', 10, '2017-02-13');

--
-- Triggers `reserve`
--
DELIMITER $$
CREATE TRIGGER `deductstock` AFTER INSERT ON `reserve` FOR EACH ROW UPDATE stationery s
SET s.sta_quantity = s.sta_quantity - new.res_quantity
WHERE s.sta_id = new.sta_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `stationery`
--

CREATE TABLE `stationery` (
  `sta_id` varchar(100) NOT NULL,
  `sta_name` varchar(100) NOT NULL,
  `sta_brand` varchar(100) NOT NULL,
  `sta_price` double DEFAULT NULL,
  `sta_category` varchar(100) DEFAULT NULL,
  `sta_quantity` int(11) DEFAULT NULL,
  `ven_id` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stationery`
--

INSERT INTO `stationery` (`sta_id`, `sta_name`, `sta_brand`, `sta_price`, `sta_category`, `sta_quantity`, `ven_id`) VALUES
('s001', 'Pen - Blue', 'Pilot', 4.5, 'writing tools', 40, 'v001'),
('s002', 'Pen - Black', 'Stabilo', 2.1, 'writing tools', 40, 'v001'),
('s003', 'Binding Tape - Black 1"', 'Astar', 2, 'adhesives', 40, 'v002'),
('s004', 'A4 Plain Paper - Box', 'Double A', 10.4, 'paper products', 25, 'v003');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` varchar(100) NOT NULL,
  `user_password` varchar(100) NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `user_email` varchar(100) DEFAULT NULL,
  `user_phone` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `user_password`, `user_name`, `user_email`, `user_phone`) VALUES
('a001', 'admin', 'admin', 'admin@fist.mmu.edu.my', '062738293'),
('a002', 'admin2', 'admin2', 'admin2@fist.mmu.edu.my', '062738293'),
('u001', 'abc', 'Jay', 'jay@staff.mmu.edu.my', '0192838473'),
('u002', 'abc', 'Dr. Afizan Azman', 'afizan.azman@mmu.edu.my', '062738273'),
('u003', 'abc', 'Anon', 'anon@anon.com', '0138493839');

-- --------------------------------------------------------

--
-- Table structure for table `vendor`
--

CREATE TABLE `vendor` (
  `ven_id` varchar(100) NOT NULL,
  `ven_name` varchar(100) NOT NULL,
  `ven_phone` varchar(50) DEFAULT NULL,
  `ven_email` varchar(100) DEFAULT NULL,
  `ven_address` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vendor`
--

INSERT INTO `vendor` (`ven_id`, `ven_name`, `ven_phone`, `ven_email`, `ven_address`) VALUES
('v001', 'ABC Stationeries Sdn. Bhd.', '019283729387', 'abc@abc.my', '9,Jalan Kuning, Tampin'),
('v002', 'DEF Wholesale Sdn. Bhd.', '01938209380', 'def@defwholesale.my', '2, Jalan Hitam, Ayer Keroh'),
('v003', 'GHI Suppliers Sdn. Bhd.', '0129302930', 'ghi@ghisuppliers.my', '89, Jalan Merah, Bukit Beruang'),
('v004', 'JKL Goods Sdn. Bhd.', '01920392039', 'jklgoods@goods.my', '10, Jalan Hijau, Ayer Keroh');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auth_assignment`
--
ALTER TABLE `auth_assignment`
  ADD PRIMARY KEY (`item_name`,`user_id`);

--
-- Indexes for table `auth_item`
--
ALTER TABLE `auth_item`
  ADD PRIMARY KEY (`name`),
  ADD KEY `rule_name` (`rule_name`),
  ADD KEY `idx-auth_item-type` (`type`);

--
-- Indexes for table `auth_item_child`
--
ALTER TABLE `auth_item_child`
  ADD PRIMARY KEY (`parent`,`child`),
  ADD KEY `child` (`child`);

--
-- Indexes for table `auth_rule`
--
ALTER TABLE `auth_rule`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `migration`
--
ALTER TABLE `migration`
  ADD PRIMARY KEY (`version`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `sta_id` (`sta_id`),
  ADD KEY `ven_id` (`ven_id`);

--
-- Indexes for table `reserve`
--
ALTER TABLE `reserve`
  ADD PRIMARY KEY (`res_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `sta_id` (`sta_id`);

--
-- Indexes for table `stationery`
--
ALTER TABLE `stationery`
  ADD PRIMARY KEY (`sta_id`),
  ADD KEY `ven_id` (`ven_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- Indexes for table `vendor`
--
ALTER TABLE `vendor`
  ADD PRIMARY KEY (`ven_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_assignment`
--
ALTER TABLE `auth_assignment`
  ADD CONSTRAINT `auth_assignment_ibfk_1` FOREIGN KEY (`item_name`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `auth_item`
--
ALTER TABLE `auth_item`
  ADD CONSTRAINT `auth_item_ibfk_1` FOREIGN KEY (`rule_name`) REFERENCES `auth_rule` (`name`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `auth_item_child`
--
ALTER TABLE `auth_item_child`
  ADD CONSTRAINT `auth_item_child_ibfk_1` FOREIGN KEY (`parent`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `auth_item_child_ibfk_2` FOREIGN KEY (`child`) REFERENCES `auth_item` (`name`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`sta_id`) REFERENCES `stationery` (`sta_id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`ven_id`) REFERENCES `vendor` (`ven_id`);

--
-- Constraints for table `reserve`
--
ALTER TABLE `reserve`
  ADD CONSTRAINT `reserve_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `reserve_ibfk_2` FOREIGN KEY (`sta_id`) REFERENCES `stationery` (`sta_id`);

--
-- Constraints for table `stationery`
--
ALTER TABLE `stationery`
  ADD CONSTRAINT `stationery_ibfk_1` FOREIGN KEY (`ven_id`) REFERENCES `vendor` (`ven_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
