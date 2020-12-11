DROP SCHEMA IF EXISTS `20180639_황성찬_DB프로그래밍` ;
CREATE SCHEMA IF NOT EXISTS `20180639_황성찬_DB프로그래밍` DEFAULT CHARACTER SET utf8mb4 ;
USE `20180639_황성찬_DB프로그래밍` ;

-- 모든 외래키는 기본적으로 모두 UPDATE CASCACDE 입니다.
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
  UNIQUE INDEX `name` (`이름` ASC)) -- 학과 이름은 중복 불가
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
  UNIQUE INDEX `location` (`연구실위치` ASC)) -- 교수님은 연구실을 단독으로 사용해야만 한다.
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;
ALTER TABLE `교수` AUTO_INCREMENT=10000; -- 사번은 10000부터 1씩 증가

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
  `담당교수` INT(5) NOT NULL UNIQUE, -- 교수님과 실험실은 1:1 관계이다.
  PRIMARY KEY (`이름`),
  CONSTRAINT `facilities_ibfk_1`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE, -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
  CONSTRAINT `facilities_ibfk_2`
    FOREIGN KEY (`담당교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE) -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
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
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE) -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `교수_학과` 교수와 학과는 M:N 관계
-- -----------------------------------------------------
DROP TABLE IF EXISTS `교수_학과` ;
CREATE TABLE IF NOT EXISTS `교수_학과` (
  `교수` INT(5) NOT NULL,
  `소속학과` VARCHAR(5) NOT NULL,
  CONSTRAINT `professors_departments_ibfk_1`
    FOREIGN KEY (`교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE ON DELETE CASCADE, -- 참조하고 있는 값이 변경되면 외래키도 변경되며 참조하고 있는 값이 지워지면 함께 지워진다.
  CONSTRAINT `professors_departments_ibfk_2`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE) -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
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
    REFERENCES `실험실` (`이름`) ON UPDATE CASCADE ON DELETE SET NULL, -- 참조하고 있는 값이 변경되면 외래키도 변경되며 실험실이 폐쇄되면 외래키가 NULL로 바뀐다.
  CONSTRAINT `students_ibfk_2`
    FOREIGN KEY (`소속학과`)
    REFERENCES `학과` (`학과코드`) ON UPDATE CASCADE, -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
  CONSTRAINT `students_ibfk_3`
    FOREIGN KEY (`멘토교수`)
    REFERENCES `교수` (`사번`) ON UPDATE CASCADE) -- 참조하고 있는 값이 변경되면 외래키도 변경된다.
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;


-- -----------------------------------------------------
-- Table `학생_수업`
-- -----------------------------------------------------
-- 학생은 한 수업을 중복해서 수강할 수 없다. 그래서 `학생_수업`.`학번`, `학생_수업`.`학번`을 복합 유니크 인덱스로 지정하여 중복된 값이 저장될 수 없도록 지정했다.
-- 나중에 데이터를 INSERT 할 때 IGNORE 명령어를 통해 중복 데이터를 INSERT 하지 않는다.
DROP TABLE IF EXISTS `학생_수업` ;
CREATE TABLE IF NOT EXISTS `학생_수업` (
  `학번` INT(8) NOT NULL,
  `학수번호` INT(5) NOT NULL,
  UNIQUE INDEX `uix_student_lecture` (`학번`, `학수번호`), -- 복합 유니크 인덱스
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
-- 교수는 여러 학과에 소속될 수 있다.
-- ex) 컴공, 컴통무 둘 다 소속될 수 있다.
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
-- 교수는 여러 수업을 담당할 수 있다.
-- 수업을 하나도 담당하지 않을 수도 있다.
INSERT INTO
  `수업` (`학수번호`, `이름`, `수강학년`, `학점`, `수강정원`, `담당교수`)
VALUES
  (10000, "데이터베이스", 3, 3, 25, 10000),
  (10001, "운영체제", 3, 3, 25, 10000),
  (10002, "자료구조", 3, 3, 25, 10000),
  (10003, "영작및독해", 3, 3, 25, 10005),
  (10004, "해석학", 3, 3, 25, 10006),
  (10005, "노동법", 3, 3, 25, 10007),
  (10006, "빅데이터", 3, 3, 25, 10008),
  (10007, "영양학", 3, 3, 25, 10009);


-- 학생 생성 쿼리
-- 소속 실험실을 추가하지 않으면 NULL이 기본값으로 저장된다.
INSERT INTO
  `학생` (`학번`, `학년`, `이름`, `전화번호`, `주민등록번호`, `소속학과`, `멘토교수`)
VALUES
  (20180639, 3, "황성찬", '01032971897', "950407-1111111", "ENG02", 10000),
  (20150000, 4, "신종환", '01056781234', "940407-1111111", "ENG02", 10001),
  (20160000, 4, "송준화", '01087654321', "960409-1111112", "ENG01", 10002),
  (20140001, 4, "이상현", '01043218765', "950410-1111111", "ENG01", 10003),
  (20200004, 1, "임재영", '01087654321', "000105-1111112", "ENG01", 10004),
  (20200005, 1, "양용준", '01087654321', "000106-1111112", "LSN01", 10009),
  (20200000, 1, "이동욱", '01032971897', "000101-1111111", "LIB01", 10005),
  (20200001, 1, "김영한", '01056781234', "000102-1111111", "EDU01", 10006),
  (20200002, 1, "김정환", '01087654321', "000103-1111112", "LAW01", 10007),
  (20200003, 1, "백기선", '01043218765', "000104-1111111", "INT01", 10008);

-- 소속 실험실 포함하여 학생 생성하기
INSERT INTO 
  `학생` (`학번`, `학년`, `이름`, `전화번호`, `주민등록번호`, `소속학과`, `멘토교수`, `소속실험실`)
VALUES
    (20140000, 4, "이헌주", '01012345678', "950408-1111112", "ENG01", 10000, "네트워크");


-- 학생_수업 매핑 쿼리
-- 복합 인덱스를 걸어놓은 덕분에 중복된 값을 INSERT하려고 하면 무시한다.
-- 무시하는 명령어: IGNORE
INSERT IGNORE INTO
  `학생_수업` (`학번`, `학수번호`)
VALUES
  (20180639, 10000),(20180639, 10000), (20180639, 10001), (20180639, 10002), (20180639, 10003), (20180639, 10000),
  (20150000, 10001),(20150000, 10004), (20150000, 10003), (20150000, 10002),
  (20150000, 10001), (20150000, 10005), (20150000, 10006),
  (20150000, 10001), (20150000, 10002),
  (20150000, 10003), (20150000, 10004);