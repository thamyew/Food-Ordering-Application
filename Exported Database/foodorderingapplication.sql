-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 01, 2023 at 07:03 AM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `foodorderingapplication`
--

-- --------------------------------------------------------

--
-- Table structure for table `achievement`
--

CREATE TABLE `achievement` (
  `achievement_id` int(11) NOT NULL,
  `achievement_name` varchar(30) NOT NULL,
  `achievement_description` varchar(100) NOT NULL,
  `condition_table` varchar(20) NOT NULL,
  `condition_key` varchar(20) NOT NULL,
  `condition_operator` char(2) NOT NULL,
  `condition_value` int(5) NOT NULL,
  `checking_key` varchar(20) NOT NULL DEFAULT '',
  `checking_operator` char(2) NOT NULL DEFAULT '',
  `checking_value` int(5) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `achievement`
--

INSERT INTO `achievement` (`achievement_id`, `achievement_name`, `achievement_description`, `condition_table`, `condition_key`, `condition_operator`, `condition_value`, `checking_key`, `checking_operator`, `checking_value`) VALUES
(1, 'Spending Apprentice', 'Spent more than RM 100.00 through the application', 'spending', 'SUM(total)', '>=', 100, '', '', 0),
(2, 'Spending Expert', 'Spent more than RM 300.00 through the application', 'spending', 'SUM(total)', '>=', 300, '', '', 0),
(3, 'Spending Master', 'Spent more than RM 500.00 through the application', 'spending', 'SUM(total)', '>=', 500, '', '', 0),
(4, 'Daily Spending Apprentice', 'Spent more than RM 10.00 through the application in a day', 'spending', 'total', '>=', 10, 'spending_date', '=', 0),
(5, 'Daily Spending Expert', 'Spent more than RM 20.00 through the application in a day', 'spending', 'total', '>=', 20, 'spending_date', '=', 0),
(6, 'Daily Spend Master', 'Spent more than RM 30.00 through the application in a day', 'spending', 'total', '>=', 30, 'spending_date', '=', 0),
(7, 'First Order', 'Using the application to make order for the first time', 'food_order', 'COUNT(order_status)', '>', 0, 'order_status', '>=', 0),
(8, 'Complete First Order', 'Have an order marked as completed in the application', 'food_order', 'COUNT(order_status)', '>', 0, 'order_status', '=', 3),
(9, 'Sorry, You Are Rejected', 'Have an order that is rejected by the cafe owner', 'food_order', 'COUNT(order_status)', '>', 0, 'order_status', '=', 5),
(10, 'Cancel Order', 'Cancel an order through the application', 'food_order', 'COUNT(order_status)', '>', 0, 'order_status', '=', 4),
(11, 'Order Apprentice', 'Have more than 5 orders marked as completed within 180 days', 'food_order', 'COUNT(order_status)', '>=', 5, 'order_status', '=', 3),
(12, 'Order Expert', 'Have more than 20 orders marked as completed within 180 days', 'food_order', 'COUNT(order_status)', '>=', 20, 'order_status', '=', 3),
(13, 'Order Master', 'Have more than 50 orders marked as completed within 180 days', 'food_order', 'COUNT(order_status)', '>=', 50, 'order_status', '=', 3),
(14, 'Loyal Customer', 'Spent more than RM 1000.00 through the application', 'spending', 'SUM(total)', '>=', 1000, '', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `achievement_record`
--

CREATE TABLE `achievement_record` (
  `achievement_id` int(11) NOT NULL,
  `customer_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `adminkey`
--

CREATE TABLE `adminkey` (
  `id` int(11) NOT NULL,
  `admin_password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `adminkey`
--

INSERT INTO `adminkey` (`id`, `admin_password`) VALUES
(1, '#123');

-- --------------------------------------------------------

--
-- Table structure for table `earning`
--

CREATE TABLE `earning` (
  `earning_date` date NOT NULL DEFAULT current_timestamp(),
  `total` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `earning`
--

INSERT INTO `earning` (`earning_date`, `total`) VALUES
('2022-12-01', 234),
('2022-12-28', 23);

-- --------------------------------------------------------

--
-- Table structure for table `fcm_token`
--

CREATE TABLE `fcm_token` (
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `token` varchar(200) NOT NULL,
  `token_level` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `fcm_token`
--

INSERT INTO `fcm_token` (`username`, `token`, `token_level`) VALUES
('ahmad', 'cjUT7rQhTpiZwiq8XZV_PM:APA91bGldjRgKM_s9e-YysWyyLgwMCexjyK9CChU6jut51-qf70tM3UEsfMmezirtWT-45v9HyaV1yvtQ-zI62v5jT-dns5cc-NfJts_1Eq6Ugp73YSqNIVskaAuZMrslfk-a9irfjW6', 1),
('jiantay', 'ec_dTtz7SSuM5ZhtUFDLIH:APA91bHdLWL_7VWCEis9-vcJ2A7Zc6LUKZtlXPPxdUIbPv8_6yxMU-ynP6Yz2FVIhLHW0gmLQlpXcl4OefsP1ncf49KsXYUH4I2jfUYVk8nxRUkDIB8Ru6-VhEo_npQEgZpmmL4s7dp_', 0);

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `content` varchar(200) NOT NULL,
  `date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `order_id`, `content`, `date`) VALUES
(18, 26, 'Testing', '2022-12-27');

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `food_id` int(11) NOT NULL,
  `food_name` varchar(50) NOT NULL,
  `food_description` varchar(200) NOT NULL,
  `food_price` float NOT NULL DEFAULT 0,
  `food_recommend` tinyint(1) NOT NULL DEFAULT 0,
  `food_archived` tinyint(1) NOT NULL DEFAULT 0,
  `archive_expiry_date` datetime DEFAULT NULL,
  `food_img_id` int(11) NOT NULL DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`food_id`, `food_name`, `food_description`, `food_price`, `food_recommend`, `food_archived`, `archive_expiry_date`, `food_img_id`) VALUES
(1, 'Kaya Butter Bread', 'Bread with kaya and butter paste.', 2, 1, 0, NULL, 8),
(2, 'Mee goreng', 'Mee goreng', 5.6, 0, 0, NULL, 13),
(4, 'Egg Sandwich', 'Sandwich with egg, tomatoes and lettuces.', 3, 1, 0, NULL, 9),
(6, 'Fried Rice with egg', 'Fried rice with eggs and cucumbers , more seasonings', 7, 1, 0, NULL, 2);

-- --------------------------------------------------------

--
-- Table structure for table `food_order`
--

CREATE TABLE `food_order` (
  `order_id` int(11) NOT NULL,
  `order_date_time` datetime NOT NULL DEFAULT current_timestamp(),
  `order_status` int(1) NOT NULL DEFAULT 0,
  `order_remark` varchar(100) CHARACTER SET utf8mb4 NOT NULL,
  `subtotal_price` float NOT NULL,
  `total_price` float NOT NULL,
  `order_archived` tinyint(1) NOT NULL DEFAULT 0,
  `order_archived_expiry_date` datetime DEFAULT NULL,
  `customer_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `discount_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food_order`
--

INSERT INTO `food_order` (`order_id`, `order_date_time`, `order_status`, `order_remark`, `subtotal_price`, `total_price`, `order_archived`, `order_archived_expiry_date`, `customer_username`, `discount_id`) VALUES
(2, '2022-12-21 07:54:30', 0, '', 2, 2, 0, NULL, 'jian', NULL),
(3, '2022-12-20 08:51:48', 0, '', 2, 2, 0, NULL, 'tayjian', NULL),
(26, '2022-12-27 18:54:29', 4, '', 5.6, 5.6, 1, '2023-06-25 11:54:54', 'asd123', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `food_order_cart`
--

CREATE TABLE `food_order_cart` (
  `cart_id` int(11) NOT NULL,
  `subtotal_price` float NOT NULL DEFAULT 0,
  `total_price` float NOT NULL DEFAULT 0,
  `cart_customer_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_order_cart`
--

INSERT INTO `food_order_cart` (`cart_id`, `subtotal_price`, `total_price`, `cart_customer_username`) VALUES
(2, 0, 0, 'ahmad');

-- --------------------------------------------------------

--
-- Table structure for table `food_order_cart_line`
--

CREATE TABLE `food_order_cart_line` (
  `cart_id` int(11) NOT NULL,
  `food_id` int(11) NOT NULL,
  `quantity` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `food_order_line`
--

CREATE TABLE `food_order_line` (
  `order_id` int(11) NOT NULL,
  `food_id` int(11) NOT NULL,
  `food_name` varchar(50) NOT NULL,
  `quantity` int(2) NOT NULL,
  `per_price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_order_line`
--

INSERT INTO `food_order_line` (`order_id`, `food_id`, `food_name`, `quantity`, `per_price`) VALUES
(2, 1, 'Kaya Butter Bread', 1, 2),
(3, 1, 'Kaya Butter Bread', 1, 2),
(26, 2, 'Mee goreng', 1, 5.6);

-- --------------------------------------------------------

--
-- Table structure for table `food_rating`
--

CREATE TABLE `food_rating` (
  `food_id` int(11) NOT NULL,
  `customer_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `rating` int(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_rating`
--

INSERT INTO `food_rating` (`food_id`, `customer_username`, `rating`) VALUES
(1, 'ahmad', 3),
(2, 'ahmad', 2),
(4, 'ahmad', 2);

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `file_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `uploaded_on` datetime NOT NULL,
  `path` varchar(20) NOT NULL,
  `status` enum('1','0') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `file_name`, `uploaded_on`, `path`, `status`) VALUES
(1, 'defaultAvatar.jpg', '2022-11-26 11:41:30', 'images/profile_pic/', '1'),
(2, 'defaultFood.jpg', '2022-11-18 08:01:41', 'images/food_pic/', '1'),
(3, 'defaultAchievementLocked.jpg', '2022-12-26 11:33:40', 'images/achieve_pic/', '1'),
(4, 'defaultAchievementUnlocked.jpg', '2022-12-26 11:34:14', 'images/achieve_pic/', '1'),
(8, 'food_pic_8.jpg', '2022-11-30 08:14:50', 'images/food_pic/', '1'),
(9, 'food_pic_9.jpg', '2022-11-29 08:19:59', 'images/food_pic/', '1'),
(11, 'profile_pic_11.jpg', '2022-11-29 15:11:26', 'images/profile_pic/', '1'),
(13, 'food_pic_13.jpg', '2022-11-30 12:14:22', 'images/food_pic/', '1');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_temp`
--

CREATE TABLE `password_reset_temp` (
  `id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `passKey` varchar(50) NOT NULL,
  `expDate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `spending`
--

CREATE TABLE `spending` (
  `spending_date` date NOT NULL DEFAULT current_timestamp(),
  `customer_username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `total` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `spending`
--

INSERT INTO `spending` (`spending_date`, `customer_username`, `total`) VALUES
('2022-12-28', 'ahmad', 35.6),
('2022-12-31', 'ahmad', 12);

-- --------------------------------------------------------

--
-- Table structure for table `userinfo`
--

CREATE TABLE `userinfo` (
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `level` int(1) NOT NULL DEFAULT 1,
  `name` varchar(50) NOT NULL,
  `gender` int(1) NOT NULL,
  `address` varchar(100) NOT NULL,
  `phone_num` varchar(30) NOT NULL,
  `profile_pic_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `userinfo`
--

INSERT INTO `userinfo` (`username`, `password`, `email`, `level`, `name`, `gender`, `address`, `phone_num`, `profile_pic_id`) VALUES
('ahmad', 'ahmad', 'iujiuj132@gmail.com', 1, 'Ahmad', 0, '34E, Jalan Kundang, Taman Bukit Indah 79100 Johor Bahru, Johor', '+60123456789', 1),
('jiantay', 'twj132', 'twj132@gmail.com', 0, 'Jian Wei Tay', 0, 'No, 32E, Jalan Kenangan, Taman Kenangan, Johor Bahru, Malaysia', '+601110223344', 11),
('tayjian', '12345', 'tayjian@graduate.utm.my', 0, 'Tay Wei Jian', 0, 'No 34asda, Jalan Kangkung, Taman Kangkung', '+601110958928', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `achievement`
--
ALTER TABLE `achievement`
  ADD PRIMARY KEY (`achievement_id`);

--
-- Indexes for table `achievement_record`
--
ALTER TABLE `achievement_record`
  ADD PRIMARY KEY (`achievement_id`,`customer_username`),
  ADD KEY `fk_record_achievement_customer` (`customer_username`);

--
-- Indexes for table `adminkey`
--
ALTER TABLE `adminkey`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `earning`
--
ALTER TABLE `earning`
  ADD PRIMARY KEY (`earning_date`);

--
-- Indexes for table `fcm_token`
--
ALTER TABLE `fcm_token`
  ADD PRIMARY KEY (`username`,`token`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_feedback_order_id` (`order_id`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`food_id`),
  ADD KEY `fk_food_img_id` (`food_img_id`);

--
-- Indexes for table `food_order`
--
ALTER TABLE `food_order`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `food_order_cart`
--
ALTER TABLE `food_order_cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD KEY `fk_cart_customer_username` (`cart_customer_username`);

--
-- Indexes for table `food_order_cart_line`
--
ALTER TABLE `food_order_cart_line`
  ADD PRIMARY KEY (`cart_id`,`food_id`),
  ADD KEY `fk_cart_line_food_id` (`food_id`);

--
-- Indexes for table `food_order_line`
--
ALTER TABLE `food_order_line`
  ADD PRIMARY KEY (`order_id`,`food_id`);

--
-- Indexes for table `food_rating`
--
ALTER TABLE `food_rating`
  ADD PRIMARY KEY (`food_id`,`customer_username`),
  ADD KEY `fk_rating_customer` (`customer_username`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_temp`
--
ALTER TABLE `password_reset_temp`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `spending`
--
ALTER TABLE `spending`
  ADD PRIMARY KEY (`spending_date`,`customer_username`),
  ADD KEY `fk_spending_customer` (`customer_username`);

--
-- Indexes for table `userinfo`
--
ALTER TABLE `userinfo`
  ADD PRIMARY KEY (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone_num` (`phone_num`),
  ADD KEY `fk_profile_pic_id_images` (`profile_pic_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `achievement`
--
ALTER TABLE `achievement`
  MODIFY `achievement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `adminkey`
--
ALTER TABLE `adminkey`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
  MODIFY `food_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `food_order`
--
ALTER TABLE `food_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `food_order_cart`
--
ALTER TABLE `food_order_cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `password_reset_temp`
--
ALTER TABLE `password_reset_temp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `achievement_record`
--
ALTER TABLE `achievement_record`
  ADD CONSTRAINT `fk_record_achievement_customer` FOREIGN KEY (`customer_username`) REFERENCES `userinfo` (`username`),
  ADD CONSTRAINT `fk_record_achievement_id` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`achievement_id`);

--
-- Constraints for table `fcm_token`
--
ALTER TABLE `fcm_token`
  ADD CONSTRAINT `fk_token_username` FOREIGN KEY (`username`) REFERENCES `userinfo` (`username`);

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `fk_feedback_order_id` FOREIGN KEY (`order_id`) REFERENCES `food_order` (`order_id`);

--
-- Constraints for table `food`
--
ALTER TABLE `food`
  ADD CONSTRAINT `fk_food_img_id` FOREIGN KEY (`food_img_id`) REFERENCES `images` (`id`);

--
-- Constraints for table `food_order_cart`
--
ALTER TABLE `food_order_cart`
  ADD CONSTRAINT `fk_cart_customer_username` FOREIGN KEY (`cart_customer_username`) REFERENCES `userinfo` (`username`);

--
-- Constraints for table `food_order_cart_line`
--
ALTER TABLE `food_order_cart_line`
  ADD CONSTRAINT `fk_cart_line_cart_id` FOREIGN KEY (`cart_id`) REFERENCES `food_order_cart` (`cart_id`),
  ADD CONSTRAINT `fk_cart_line_food_id` FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`);

--
-- Constraints for table `food_order_line`
--
ALTER TABLE `food_order_line`
  ADD CONSTRAINT `fk_order_line_order_id` FOREIGN KEY (`order_id`) REFERENCES `food_order` (`order_id`);

--
-- Constraints for table `food_rating`
--
ALTER TABLE `food_rating`
  ADD CONSTRAINT `fk_rating_customer` FOREIGN KEY (`customer_username`) REFERENCES `userinfo` (`username`),
  ADD CONSTRAINT `fk_rating_food_id` FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`);

--
-- Constraints for table `spending`
--
ALTER TABLE `spending`
  ADD CONSTRAINT `fk_spending_customer` FOREIGN KEY (`customer_username`) REFERENCES `userinfo` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
