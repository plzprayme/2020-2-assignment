-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema 20180639_황성찬_DB프로그래밍
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `20180639_황성찬_DB프로그래밍` ;

-- -----------------------------------------------------
-- Schema 20180639_황성찬_DB프로그래밍
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `20180639_황성찬_DB프로그래밍` DEFAULT CHARACTER SET utf8mb4 ;
USE `20180639_황성찬_DB프로그래밍` ;

-- -----------------------------------------------------
-- Table `학과`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `학과` ;
CREATE TABLE IF NOT EXISTS `학과` (
  `학과코드` VARCHAR(5) NOT NULL,
  `위치` INT(6) NOT NULL,
  `이름` VARCHAR(20) NOT NULL,
  `단과` VARCHAR(10) NOT NULL,
  `졸업학점` INT(3) NOT NULL,
  `학과정원` INT(3) NOT NULL,
  PRIMARY KEY (`학과코드`),
  UNIQUE INDEX `name` (`이름` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;




-- -----------------------------------------------------
-- Table `교수`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수` ;
CREATE TABLE IF NOT EXISTS `교수` (
  `사번` INT(5) NOT NULL AUTO_INCREMENT,
  `이름` VARCHAR(10) NOT NULL,
  `이메일` VARCHAR(30) NOT NULL,
  `연구실위치` INT(6) NOT NULL,
  `전공` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`사번`),
  UNIQUE INDEX `location` (`연구실위치` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;
ALTER TABLE `교수` AUTO_INCREMENT=10000;

-- -----------------------------------------------------
-- Table `실험실`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `실험실` ;
CREATE TABLE IF NOT EXISTS `실험실` (
  `이름` VARCHAR(20) NOT NULL,
  `위치` INT(6) NOT NULL,
  `면적` INT(6) NOT NULL,
  `홈페이지` VARCHAR(50) NOT NULL,
  `전화번호` INT(4) NOT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  `담당교수` INT(5) NOT NULL UNIQUE,
  PRIMARY KEY (`이름`),
  CONSTRAINT `facilities_ibfk_1`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE,
  CONSTRAINT `facilities_ibfk_2`
    FOREIGN KEY (`담당교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `수업`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `수업` ;
CREATE TABLE IF NOT EXISTS `수업` (
  `학수번호` INT(5) NOT NULL,
  `이름` VARCHAR(20) NOT NULL,
  `수강학년` INT(1) NOT NULL,
  `학점` INT(1) NOT NULL,
  `수강정원` INT(3) NOT NULL,
  `담당교수` INT(5) NOT NULL,
  PRIMARY KEY (`학수번호`),
  CONSTRAINT `lectures_ibfk_1`
    FOREIGN KEY (`담당교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `교수_학과`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수_학과` ;
CREATE TABLE IF NOT EXISTS `교수_학과` (
  `교수` INT(5) NOT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  CONSTRAINT `professors_departments_ibfk_1`
    FOREIGN KEY (`교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `professors_departments_ibfk_2`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

-- -----------------------------------------------------
-- Table `학생`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `학생` ;
CREATE TABLE IF NOT EXISTS `학생` (
  `학번` INT(8) NOT NULL,
  `학년` INT(1) NOT NULL,
  `이름` VARCHAR(20) NOT NULL,
  `전화번호` INT(11) NOT NULL,
  `주민등록번호` VARCHAR(14) NOT NULL,
  `소속실험실` VARCHAR(20) DEFAULT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  `멘토교수` INT(5) NOT NULL,
  PRIMARY KEY (`학번`),
  UNIQUE INDEX `identity_number` (`주민등록번호` ASC),
  CONSTRAINT `students_ibfk_1`
    FOREIGN KEY (`소속실험실`)
    REFERENCES `실험실` (`이름`) ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT `students_ibfk_2`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE,
  CONSTRAINT `students_ibfk_3`
    FOREIGN KEY (`멘토교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `학생_수업`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `학생_수업` ;
CREATE TABLE IF NOT EXISTS `학생_수업` (
  `학번` INT(8) NOT NULL,
  `학수번호` INT(5) NOT NULL,
  UNIQUE INDEX `uix_student_lecture` (`학번`, `학수번호`),
  CONSTRAINT `students_lectures_ibfk_1`
    FOREIGN KEY (`학번`)
    REFERENCES `학생` (`학번`) ON UPDATE CASCADE,
  CONSTRAINT `students_lectures_ibfk_2`
    FOREIGN KEY (`학수번호`)
    REFERENCES `수업` (`학수번호`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- 학과 생성 쿼리
INSERT INTO
  `학과` (`학과코드`, `위치`, `이름`, `단과`, `졸업학점`, `학과정원`)
VALUES
  ("ENG01", 90201, "컴퓨터공학과", "공과대학", 126, 60),
  ("ENG02", 90201, "컴퓨터통신무인기술학과", "공과대학", 136, 150),
  ("LIB01", 40201, "영어영문학과", "문과대학", 120, 110),
  ("EDU01", 30201, "수학교육과", "사범대학", 127, 25),
  ("LAW01", 560501, "법학과", "법정대학", 120, 40),
  ("INT01", 50201, "빅데이터응용학과", "사회적경제융합대학", 120, 60),
  ("LSN01", 60201, "식품영양학과", "생명나노대학", 120, 60);


-- 교수 생성 쿼리
INSERT INTO
  `교수` (`이름`, `이메일`, `연구실위치`, `전공`)
VALUES
  ("최의인", "eichoi@hnu.kr", 90701, "데이터베이스"),
  ("이강수", "gslee@hnu.kr", 90702, "소프트웨어공학"),
  ("이만희", "manheelee@hnu.kr", 90703, "시스템보안"),
  ("안기영", "kya@hnu.kr", 90704, "프로그래밍언어"),
  ("소우영", "wsoh@hnu.kr", 90705, "뉴럴 네트워크"),
  ("변지현", "byunjh@hnu.kr", 40301, "영작 및 독해"),
  ("김화길", "hwakil@gmail.com", 30102, "해석학"),
  ("피용호", "drchopin@gmail.com", 560501, "노동법"),
  ("김명준", "mkim@hnu.kr", 50101, "빅데이터응용"),
  ("송수진", "sjsong9635@gmail.com", 60501, "영양학");

-- 교수 학과 관계 매핑
INSERT INTO
  `교수_학과` (`교수`, `소속학과`)
VALUES
  (10000, "ENG01"), (10000, "ENG02"),
  (10001, "ENG01"), (10001, "ENG02"),
  (10002, "ENG01"), (10002, "ENG02"),
  (10003, "ENG01"), (10003, "ENG02"),
  (10004, "ENG01"), (10004, "ENG02"),
  (10005, "LIB01"),
  (10006, "EDU01"),
  (10007, "LAW01"),
  (10008, "INT01"),
  (10009, "LSN01");

-- 실험실 생성 쿼리
INSERT INTO
  `실험실` (`이름`, `위치`, `면적`, `홈페이지`, `전화번호`, `소속학과`, `담당교수`)
VALUES 
  ("데이터베이스", 90710, 50, "db", 7600, "ENG02", 10000),
  ("네트워크", 90711, 40, "netwk", 7601, "ENG02", 10001),
  ("고성능 보안", 90711, 45, "hpsc", 7602, "ENG02", 10002),
  ("프로그래밍언어", 90711, 35, "pl", 7603, "ENG02", 10003),
  ("뉴럴 네트워크", 90711, 30, "nn", 7604, "ENG02", 10004),
  ("영작 및 독해", 90711, 55, "english", 7605, "LIB01", 10005),
  ("해석학", 90711, 30, "analysis", 7606, "EDU01", 10006),
  ("노동법", 90711, 40, "laborlaw", 7607, "LAW01", 10007),
  ("빅데이터응용", 90711, "50", "bigdata", 7608, "INT01", 10008),
  ("영양학", 90711, 50, "nutri", 7609, "LSN01", 10009);

-- 수업 생성 쿼리
INSERT INTO
  `수업` (`학수번호`, `이름`, `수강학년`, `학점`, `수강정원`, `담당교수`)
VALUES
  (10000, "데이터베이스", 3, 3, 25, 10000),
  (10001, "데이터베이스", 3, 3, 25, 10000),
  (10002, "데이터베이스", 3, 3, 25, 10000),
  (10003, "데이터베이스", 3, 3, 25, 10000),
  (10004, "데이터베이스", 3, 3, 25, 10000),
  (10005, "데이터베이스", 3, 3, 25, 10000),
  (10006, "데이터베이스", 3, 3, 25, 10000),
  (10007, "데이터베이스", 3, 3, 25, 10000),
  (10008, "데이터베이스", 3, 3, 25, 10000);

-- 학생 생성 쿼리
INSERT INTO
  `학생` (`학번`, `학년`, `이름`, `전화번호`, `주민등록번호`, `소속학과`, `멘토교수`)
VALUES
  (20180639, 3, "황성찬", '01032971897', "950407-1111111", "ENG01", 10000),
  (20140000, 4, "이헌주", '01012345678', "950408-1111112", "ENG01", 10000),
  (20150000, 4, "신종환", '01056781234', "940407-1111111", "ENG01", 10001),
  (20160000, 4, "송준화", '01087654321', "960409-1111112", "ENG01", 10002),
  (20140001, 4, "이상현", '01043218765', "950410-1111111", "ENG01", 10003);


-- 학생_수업 매핑 쿼리
INSERT IGNORE INTO
  `학생_수업` (`학번`, `학수번호`)
VALUES
  (20180639, 10000),(20180639, 10000), (20180639, 10001), (20180639, 10002), (20180639, 10003), (20180639, 10000);
