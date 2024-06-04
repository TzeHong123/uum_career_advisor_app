-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 03, 2024 at 03:20 AM
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
-- Database: `uum_career_advisor_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_advice_content`
--

CREATE TABLE `tbl_advice_content` (
  `advice_id` int(10) NOT NULL,
  `post_id` int(10) NOT NULL,
  `user_id` int(5) NOT NULL,
  `user_name` varchar(100) DEFAULT NULL,
  `job_title` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `advice_title` varchar(255) DEFAULT NULL,
  `advice_content` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_advice_content`
--

INSERT INTO `tbl_advice_content` (`advice_id`, `post_id`, `user_id`, `user_name`, `job_title`, `company_name`, `advice_title`, `advice_content`, `created_at`) VALUES
(1, 1, 3, 'Ali Ahmad bin Hamdan', 'Software designer', 'Company B', 'Sharpen your skills', 'Do not neglect on your soft skills. Learn to communicate with your team better. Teamwork is often the key to success of a project!', '2024-05-03 10:18:12'),
(2, 1, 3, 'Xinyi', 'System analyst', 'Company C', 'Sharpen your skills', 'Practice is the key to perfection. Be proactive in learning from your seniors during internship.', '2024-05-03 10:43:03'),
(3, 1, 3, 'Siti Aisyah binti Adam', 'Developer', 'IT Tech Industry', 'Sharpen your skills', 'Gain as much experience as you can during your internship. You are there to learn what it\'s like to be working in the real industry.', '2024-05-03 10:44:25'),
(4, 1, 3, 'admin', 'Manager', 'SSS', 'Sharpen your skills', 'Train your skills repeatedly. Make it a routine to keep refining your programming skills so that you can perform more efficiently.', '2024-05-03 10:46:30'),
(5, 2, 3, 'Ahmad', 'Software Engineer', 'Company B', 'Skill requirements', 'Do some research beforehand about your internship skill requirements. It will help you to achieve better performance.', '2024-05-07 02:29:35'),
(7, 3, 5, 'Sarah', 'Software engineer', 'Company A', 'Experience sharing ', 'I have been working in the IT industry for 5 years. Be cooperative with your team, share ideas and learn together.', '2024-05-07 02:46:58'),
(9, 1, 5, 'Sarah', 'Software Engineer', 'IT Company A', 'Sharpen your skills', 'Train your skills on a regular basis.It will help you become more experienced.', '2024-05-31 05:44:47');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_comment`
--

CREATE TABLE `tbl_comment` (
  `comment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `user_profile_pic` varchar(255) DEFAULT NULL,
  `comment_text` varchar(255) NOT NULL,
  `upvotes` int(11) DEFAULT 0,
  `downvotes` int(11) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_comment`
--

INSERT INTO `tbl_comment` (`comment_id`, `user_id`, `question_id`, `user_profile_pic`, `comment_text`, `upvotes`, `downvotes`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 'assets/images/profile.png', 'Great initiative! I suggest you to ask experts fellow programmers online to know the trend nowadays. Good luck!', 0, 0, '2024-04-23 23:01:54', '2024-04-23 23:01:54');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_posts`
--

CREATE TABLE `tbl_posts` (
  `post_id` int(10) NOT NULL,
  `user_id` int(5) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `post_title` varchar(50) NOT NULL,
  `post_content` varchar(300) NOT NULL,
  `post_likes` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_posts`
--

INSERT INTO `tbl_posts` (`post_id`, `user_id`, `user_name`, `post_title`, `post_content`, `post_likes`) VALUES
(1, 3, 'admin', 'Sharpen your skills', 'Technical skills are very important in the field of IT and Computer Science. Always aim to further improve your skills. Here are some tips you may find helpful to train your personal skills.', 1),
(2, 3, 'admin', 'Skill requirements', 'Another important tips for students that are undergoing interships in company is to look for the skills requirements beforehand. This will benefit you a lot if you studied beforehand about what sort of working environment you will be working at.', 1),
(3, 3, 'admin', 'Experience sharing ', 'Here you can find some past experiences from seniors and alumni of UUM that has been working in the industry for years.', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post_favourites`
--

CREATE TABLE `tbl_post_favourites` (
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `added_to_fav` int(5) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_post_favourites`
--

INSERT INTO `tbl_post_favourites` (`post_id`, `user_id`, `added_to_fav`, `created_at`) VALUES
(1, 5, 0, '2024-05-31 06:20:02'),
(2, 5, 0, '2024-05-31 06:45:05');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_post_likes`
--

CREATE TABLE `tbl_post_likes` (
  `post_like_time` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `post_id` int(10) NOT NULL,
  `user_id` int(5) NOT NULL,
  `user_has_liked` int(5) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_post_likes`
--

INSERT INTO `tbl_post_likes` (`post_like_time`, `post_id`, `user_id`, `user_has_liked`) VALUES
('2024-05-31 14:19:56.397643', 1, 5, 1),
('2024-05-31 14:36:43.855279', 2, 5, 0),
('2024-05-31 14:45:14.638978', 3, 5, 0),
('2024-06-01 19:04:21.987259', 1, 3, 0),
('2024-06-01 19:04:23.064527', 2, 3, 1),
('2024-06-01 19:04:27.853682', 3, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_questions`
--

CREATE TABLE `tbl_questions` (
  `question_id` int(8) NOT NULL,
  `user_id` int(5) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `question_title` varchar(50) NOT NULL,
  `question_content` varchar(300) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_questions`
--

INSERT INTO `tbl_questions` (`question_id`, `user_id`, `user_name`, `question_title`, `question_content`) VALUES
(1, 2, 'AbuBinHamdan', 'How to learn new language', 'I wish to learn new things such as Laravel, Mongoldb because my lecturer told me about them.'),
(5, 4, 'Tze Hong', 'What website should I use to learn pyhton?', 'I want to learn python, and wondering if there is any good website or good tutorial video to the language.\n');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(100) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(5) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `user_role` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`, `user_role`) VALUES
(2, 'Abu123@gmail.com', 'AbuBinHamdan', '015-87695854', '601f1889667efaebb33b8c12572835da3f027f78', '36967', '2024-01-28 13:12:00.470796', 'Student'),
(3, 'admin@gmail.com', 'admin', '018-8888888', '601f1889667efaebb33b8c12572835da3f027f78', '40926', '2024-01-30 23:47:20.991054', 'Senior'),
(4, 'Tzehong123@gmail.com', 'Tze Hong', '019-5624812', '601f1889667efaebb33b8c12572835da3f027f78', '26305', '2024-02-01 20:15:20.645325', 'Student'),
(5, 'Sarah123@gmail.com', 'Sarah', '015-6278924', '601f1889667efaebb33b8c12572835da3f027f78', '84685', '2024-05-07 10:45:13.690520', 'Senior');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_advice_content`
--
ALTER TABLE `tbl_advice_content`
  ADD PRIMARY KEY (`advice_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `tbl_comment`
--
ALTER TABLE `tbl_comment`
  ADD PRIMARY KEY (`comment_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `tbl_posts`
--
ALTER TABLE `tbl_posts`
  ADD PRIMARY KEY (`post_id`);

--
-- Indexes for table `tbl_post_favourites`
--
ALTER TABLE `tbl_post_favourites`
  ADD KEY `post_id` (`post_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_questions`
--
ALTER TABLE `tbl_questions`
  ADD PRIMARY KEY (`question_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_advice_content`
--
ALTER TABLE `tbl_advice_content`
  MODIFY `advice_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_comment`
--
ALTER TABLE `tbl_comment`
  MODIFY `comment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_posts`
--
ALTER TABLE `tbl_posts`
  MODIFY `post_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_questions`
--
ALTER TABLE `tbl_questions`
  MODIFY `question_id` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_advice_content`
--
ALTER TABLE `tbl_advice_content`
  ADD CONSTRAINT `tbl_advice_content_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `tbl_posts` (`post_id`);

--
-- Constraints for table `tbl_comment`
--
ALTER TABLE `tbl_comment`
  ADD CONSTRAINT `tbl_comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`),
  ADD CONSTRAINT `tbl_comment_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `tbl_questions` (`question_id`);

--
-- Constraints for table `tbl_post_favourites`
--
ALTER TABLE `tbl_post_favourites`
  ADD CONSTRAINT `tbl_post_favourites_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `tbl_posts` (`post_id`),
  ADD CONSTRAINT `tbl_post_favourites_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
