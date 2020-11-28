DROP DATABASE IF EXISTS `db_lecture`;
CREATE DATABASE `db_lecture`;
USE `db_lecture`;

DROP TABLE IF EXISTS `students`;
CREATE TABLE `students` (
  `id` int PRIMARY KEY,
  `grade` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `identity_number` int UNIQUE NOT NULL,
  `facility_name` varchar(255),
  `department_id` varchar(255) NOT NULL,
  `professor_id` int NOT NULL
);

DROP TABLE IF EXISTS `departments`;
CREATE TABLE `departments` (
  `id` varchar(255) PRIMARY KEY,
  `location` int NOT NULL,
  `name` varchar(255) UNIQUE NOT NULL,
  `college` varchar(255) NOT NULL,
  `graduate_point` int NOT NULL,
  `max_student` int NOT NULL
);

DROP TABLE IF EXISTS `professors`;
CREATE TABLE `professors` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `location` int UNIQUE NOT NULL,
  `major` varchar(255) NOT NULL,
  `facility_name` varchar(255) NOT NULL
);

DROP TABLE IF EXISTS `lectures`;
CREATE TABLE `lectures` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `target_grade` int NOT NULL,
  `point` int NOT NULL,
  `max_student` int NOT NULL,
  `professor_id` int NOT NULL
);

DROP TABLE IF EXISTS `facilities`;
CREATE TABLE `facilities` (
  `name` varchar(255) PRIMARY KEY,
  `position` int NOT NULL,
  `area` int NOT NULL,
  `homepage_url` int NOT NULL,
  `tel_number` varchar(255) NOT NULL,
  `professor_id` int NOT NULL
);

DROP TABLE IF EXISTS `professors_departments`;
CREATE TABLE `professors_departments` (
  `professor_id` int NOT NULL,
  `department_id` varchar(255) NOT NULL
);

DROP TABLE IF EXISTS `students_lectures`;
CREATE TABLE `students_lectures` (
  `student_id` int NOT NULL,
  `lecture_id` int NOT NULL
);

ALTER TABLE `students` ADD FOREIGN KEY (`facility_name`) REFERENCES `facilities` (`name`);

ALTER TABLE `students` ADD FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

ALTER TABLE `students` ADD FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);

ALTER TABLE `students_lectures` ADD FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);

ALTER TABLE `students_lectures` ADD FOREIGN KEY (`lecture_id`) REFERENCES `lectures` (`id`);

ALTER TABLE `professors_departments` ADD FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);

ALTER TABLE `professors_departments` ADD FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

ALTER TABLE `facilities` ADD FOREIGN KEY (`name`) REFERENCES `departments` (`id`);

ALTER TABLE `lectures` ADD FOREIGN KEY (`id`) REFERENCES `professors` (`id`);

ALTER TABLE `facilities` ADD FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);
ALTER TABLE `professors` ADD FOREIGN KEY (`facility_name`) REFERENCES `facilities` (`name`);