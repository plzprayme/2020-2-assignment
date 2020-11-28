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
  `id` INT(5) PRIMARY KEY,
  `name` VARCHAR(10) NOT NULL,
  `email` VARCHAR(30) NOT NULL,
  `location` INT(6) UNIQUE NOT NULL,
  `major` VARCHAR(30) NOT NULL,
  `facility_name` VARCHAR(30) UNIQUE DEFAULT NULL
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
  `professor_id` INT(5) NOT NULL,
  `department_id` VARCHAR(5) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

DROP TABLE IF EXISTS `students_lectures`;
CREATE TABLE `students_lectures` (
  `student_id` INT(11) NOT NULL,
  `lecture_id` INT(11) NOT NULL
) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4;

ALTER TABLE
  `students`
ADD
  FOREIGN KEY (`facility_name`) REFERENCES `facilities` (`name`) ON DELETE
SET
  NULL;

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

-- 학과 생성 코드 
INSERT INTO
  `departments` (`id`, `location`, `name`, `college`, `graduate_point`, `max_student`)
VALUES
  ("ENG01", 90201, "컴퓨터공학과", "공과대학", 126, 60),
  ("ENG02", 90201, "컴퓨터통신무인기술학과", "공과대학", 136, 150),
  ("LIB01", 40201, "영어영문학과", "문과대학", 120, 110),
  ("EDU01", 30201, "수학교육과", "사범대학", 127, 25),
  ("LAW01", 560501, "법학과", "법정대학", 120, 40),
  ("INT01", 50201, "빅데이터응용학과", "사회적경제융합대학", 120, 60),
  ("LSN01", 60201, "식품영양학과", "생명나노대학", 120, 60);

-- 교수 생성 코드
INSERT INTO
  `professors` (`id`, `name`, `email`, `location`, `major`)
VALUES
  (10001, "최의인", "eichoi@hnu.kr", 90701, "데이터베이스"),
  (10002, "이강수", "gslee@hnu.kr", 90702, "소프트웨어공학"),
  (10003, "이만희", "manheelee@hnu.kr", 90703, "시스템보안"),
  (10004, "안기영", "kya@hnu.kr", 90704, "프로그래밍언어"),
  (10005, "소우영", "wsoh@hnu.kr", 90705, "뉴럴 네트워크"),
  (10006, "변지현", "byunjh@hnu.kr", 40301, "영작 및 독해"),
  (10007, "김화길", "hwakil@gmail.com", 30102, "해석학"),
  (10008, "피용호", "drchopin@gmail.com", 560501, "노동법"),
  (10009, "김명준", "mkim@hnu.kr", 50101, "빅데이터응용"),
  (10010, "송수진", "sjsong9635@gmail.com", 60501, "영양학");

-- 교수 학과 관계 매핑
INSERT INTO
  `professors_departments` (`professor_id`, `department_id`)
VALUES
  (10001, "ENG01"), (10001, "ENG02"),
  (10002, "ENG01"), (10002, "ENG02"),
  (10003, "ENG01"), (10003, "ENG02"),
  (10004, "ENG01"), (10004, "ENG02"),
  (10005, "ENG01"), (10005, "ENG02"),
  (10006, "LIB01"),
  (10007, "EDU01"),
  (10008, "LAW01"),
  (10009, "INT01"),
  (10010, "LSN01");
