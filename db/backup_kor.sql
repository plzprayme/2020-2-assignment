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
  `계열` VARCHAR(10) NOT NULL,
  `졸업학점` INT(3) NOT NULL,
  `학과정원` INT(3) NOT NULL,
  PRIMARY KEY (`학과코드`),
  UNIQUE INDEX `name` (`이름` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `실험실`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `실험실` ;

CREATE TABLE IF NOT EXISTS `실험실` (
  `이름` VARCHAR(20) NOT NULL,
  `위치` INT(6) NOT NULL,
  `면적` INT(6) NOT NULL,
  `홈페이지` INT(50) NOT NULL,
  `전화번호` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`이름`),
  CONSTRAINT `facilities_ibfk_1`
    FOREIGN KEY (`이름`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `교수`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수` ;

CREATE TABLE IF NOT EXISTS `교수` (
  `사번` INT(5) NOT NULL,
  `이름` VARCHAR(10) NOT NULL,
  `이메일` VARCHAR(30) NOT NULL,
  `연구실위치` INT(6) NOT NULL,
  `전공` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`사번`),
  UNIQUE INDEX `location` (`연구실위치` ASC))
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
    FOREIGN KEY (`학수번호`)
    REFERENCES `교수` (`사번`) ON UPDATE  ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `교수_학과`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수_학과` ;

CREATE TABLE IF NOT EXISTS `교수_학과` (
  `교수` INT(5) NOT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  INDEX `professor_id` (`교수` ASC),
  INDEX `department_id` (`소속학과` ASC),
  CONSTRAINT `professors_departments_ibfk_1`
    FOREIGN KEY (`교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `professors_departments_ibfk_2`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `교수_실험실`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수_실험실` ;

CREATE TABLE IF NOT EXISTS `교수_실험실` (
  `담당교수` INT(5) NOT NULL,
  `실험실` VARCHAR(5) NOT NULL,
  UNIQUE INDEX `professor_id` (`담당교수` ASC),
  UNIQUE INDEX `facility_name` (`실험실` ASC),
  CONSTRAINT `professors_facilities_ibfk_1`
    FOREIGN KEY (`담당교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `professors_facilities_ibfk_2`
    FOREIGN KEY (`실험실`)
    REFERENCES `실험실` (`이름`) ON UPDATE CASCADE)
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
  `전화번호` VARCHAR(15) NOT NULL,
  `주민등록번호` VARCHAR(14) NOT NULL,
  `소속실험실` VARCHAR(20) NULL DEFAULT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  `멘토교수` INT(5) NOT NULL,
  PRIMARY KEY (`학번`),
  UNIQUE INDEX `identity_number` (`주민등록번호` ASC),
  INDEX `facility_name` (`소속실험실` ASC),
  INDEX `department_id` (`소속학과` ASC),
  INDEX `professor_id` (`멘토교수` ASC),
  CONSTRAINT `students_ibfk_1`
    FOREIGN KEY (`소속실험실`)
    REFERENCES `실험실` (`이름`) ON UPDATE CASCADE ON DELETE SET DEFAULT,
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
  INDEX `student_id` (`학번` ASC),
  INDEX `lecture_id` (`학수번호` ASC),
  CONSTRAINT `students_lectures_ibfk_1`
    FOREIGN KEY (`학번`)
    REFERENCES `학생` (`학번`) ON UPDATE CASCADE,
  CONSTRAINT `students_lectures_ibfk_2`
    FOREIGN KEY (`학수번호`)
    REFERENCES `수업` (`학수번호`) ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;