DROP DATABASE IF EXISTS `db_lecture`;

CREATE DATABASE `db_lecture` DEFAULT CHARACTER SET utf8mb4;

USE `db_lecture`;

DROP TABLE IF EXISTS `students`;

CREATE TABLE `students` (
  `id` INT(11) PRIMARY KEY,
  `grade` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(255) NOT NULL,
  `identity_number` INT(11) UNIQUE NOT NULL,
  `facility_name` VARCHAR(255),
  `department_id` VARCHAR(255) NOT NULL,
  `professor_id` INT(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `departments`;

CREATE TABLE `departments` (
  `id` VARCHAR(5) PRIMARY KEY,
  `location` INT(6) NOT NULL,
  `name` VARCHAR(20) UNIQUE NOT NULL,
  `college` VARCHAR(10) NOT NULL,
  `graduate_point` INT(3) NOT NULL,
  `max_student` INT(3) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `professors`;

CREATE TABLE `professors` (
  `id` INT(11) PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `location` INT(11) UNIQUE NOT NULL,
  `major` VARCHAR(255) NOT NULL,
  `facility_name` VARCHAR(255) UNIQUE DEFAULT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `lectures`;

CREATE TABLE `lectures` (
  `id` INT(11) PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `target_grade` INT(11) NOT NULL,
  `poINT(11)` INT(11) NOT NULL,
  `max_student` INT(11) NOT NULL,
  `professor_id` INT(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `facilities`;

CREATE TABLE `facilities` (
  `name` VARCHAR(255) PRIMARY KEY,
  `position` INT(11) NOT NULL,
  `area` INT(11) NOT NULL,
  `homepage_url` INT(11) NOT NULL,
  `tel_number` VARCHAR(255) NOT NULL,
  `professor_id` INT(11) UNIQUE NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `professors_departments`;

CREATE TABLE `professors_departments` (
  `professor_id` INT(11) NOT NULL,
  `department_id` VARCHAR(255) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `students_lectures`;

CREATE TABLE `students_lectures` (
  `student_id` INT(11) NOT NULL,
  `lecture_id` INT(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

ALTER TABLE
  `students`
ADD
  FOREIGN KEY (`facility_name`) REFERENCES `facilities` (`name`) ON DELETE SET NULL;

ALTER TABLE
  `students`
ADD
  FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

ALTER TABLE
  `students`
ADD
  FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);

ALTER TABLE
  `students_lectures`
ADD
  FOREIGN KEY (`student_id`) REFERENCES `students` (`id`);

ALTER TABLE
  `students_lectures`
ADD
  FOREIGN KEY (`lecture_id`) REFERENCES `lectures` (`id`);

ALTER TABLE
  `professors_departments`
ADD
  FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);

ALTER TABLE
  `professors_departments`
ADD
  FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);

ALTER TABLE
  `facilities`
ADD
  FOREIGN KEY (`name`) REFERENCES `departments` (`id`);

ALTER TABLE
  `lectures`
ADD
  FOREIGN KEY (`id`) REFERENCES `professors` (`id`);

ALTER TABLE
  `facilities`
ADD
  FOREIGN KEY (`professor_id`) REFERENCES `professors` (`id`);

ALTER TABLE
  `professors`
ADD
  FOREIGN KEY (`facility_name`) REFERENCES `facilities` (`name`);

  

INSERT INTO 
`departments` (`id`, `location`, `name`, `college`, `graduate_point`, `max_student`)
VALUES
("ENG01", 90201, "컴퓨터공학과", "공과대학", 136, 60);
