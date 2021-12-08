-- MySQL Workbench Forward Engineering



SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ForManiac
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ForManiac
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ForManiac` DEFAULT CHARACTER SET utf8 ;
USE `ForManiac` ;

-- -----------------------------------------------------
-- Table `ForManiac`.`USERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`USERS` (
  `USER_number` INT NOT NULL AUTO_INCREMENT COMMENT '번호 1~1000 번대 까지는 관리자',
  `USER_id` VARCHAR(45) NOT NULL,
  `USER_password` VARCHAR(45) NOT NULL,
  `USER_email` VARCHAR(45) NULL DEFAULT NULL,
  `USER_nickname` VARCHAR(45) NOT NULL,
  `USER_lastlogined` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`USER_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`Fields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`Fields` (
  `FIELD_number` INT NOT NULL AUTO_INCREMENT,
  `FIELD_name` VARCHAR(45) NOT NULL,
  `FIELD_profile_image` MEDIUMBLOB NULL DEFAULT NULL COMMENT 'BLOB의 분류\\nTINYBLOB : 2^8 - 1 [256 Bytes]\\nBLOB : 2^16 - 1 [64KB]\\nMEDIUMBLOB : 2^24 - 1 [8 MB]\\nLONGBLOB : 2^32 - 1 [4GB]\\n\\n== 대표가 되는 이미지를 저장하고, 이 이미지는 초반에 관심사를 수집할 때 대표사진으로 이용됨.',
  `FIELD_createdBy` INT NOT NULL,
  PRIMARY KEY (`FIELD_number`),
  INDEX `fk_Fields_USERS1_idx` (`FIELD_createdBy` ASC),
  CONSTRAINT `fk_Fields_USERS1`
    FOREIGN KEY (`FIELD_createdBy`)
    REFERENCES `ForManiac`.`USERS` (`USER_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3
COMMENT = '						';


-- -----------------------------------------------------
-- Table `ForManiac`.`POSTS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`POSTS` (
  `POST_number` INT NOT NULL AUTO_INCREMENT,
  `POST_desc` TEXT NULL DEFAULT NULL COMMENT '어떤 분야의 POST에 대한 설명 추가(200자 이내)',
  `FIELD_number` INT NOT NULL,
  `POST_createdDate` VARCHAR(45) NULL DEFAULT NULL,
  `POST_updatedDate` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`POST_number`, `FIELD_number`),
  INDEX `fk_POST_Fields1_idx` (`FIELD_number` ASC),
  CONSTRAINT `fk_POST_Fields01`
    FOREIGN KEY (`FIELD_number`)
    REFERENCES `ForManiac`.`Fields` (`FIELD_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`COMMENTFIELDS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`COMMENTFIELDS` (
  `COMMENTFIELD_number` INT NOT NULL AUTO_INCREMENT,
  `POST_number` INT NOT NULL,
  `FIELD_number` INT NOT NULL,
  `COMMENTFIELD_updated_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`COMMENTFIELD_number`),
  INDEX `fk_COMMENTFIELDS_POST1_idx` (`POST_number` ASC, `FIELD_number` ASC),
  CONSTRAINT `fk_COMMENTFIELDS_POST1`
    FOREIGN KEY (`POST_number` , `FIELD_number`)
    REFERENCES `ForManiac`.`POSTS` (`POST_number` , `FIELD_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`COMMENTFIELDS_has_USERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`COMMENTFIELDS_has_USERS` (
  `COMMENT_number` INT NOT NULL,
  `USER_number` INT NOT NULL,
  `USER_commet_picture` MEDIUMBLOB NULL DEFAULT NULL COMMENT '해당 코멘트 창에서 유저가 올린 편집된 사진 저장',
  PRIMARY KEY (`COMMENT_number`, `USER_number`),
  INDEX `fk_COMMENTFIELDS_has_USERS_USERS1_idx` (`USER_number` ASC),
  INDEX `fk_COMMENTFIELDS_has_USERS_COMMENTFIELDS1_idx` (`COMMENT_number` ASC),
  CONSTRAINT `fk_COMMENTFIELDS_has_USERS_COMMENTFIELDS1`
    FOREIGN KEY (`COMMENT_number`)
    REFERENCES `ForManiac`.`COMMENTFIELDS` (`COMMENTFIELD_number`),
  CONSTRAINT `fk_COMMENTFIELDS_has_USERS_USERS1`
    FOREIGN KEY (`USER_number`)
    REFERENCES `ForManiac`.`USERS` (`USER_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`DMs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`DMs` (
  `USER_sent` INT NOT NULL,
  `USER_received` INT NOT NULL,
  `DM_created` DATE NOT NULL,
  PRIMARY KEY (`USER_sent`, `USER_received`),
  INDEX `fk_USERS_has_USERS_USERS2_idx` (`USER_received` ASC),
  INDEX `fk_USERS_has_USERS_USERS1_idx` (`USER_sent` ASC),
  CONSTRAINT `fk_USERS_has_USERS_USERS1`
    FOREIGN KEY (`USER_sent`)
    REFERENCES `ForManiac`.`USERS` (`USER_number`),
  CONSTRAINT `fk_USERS_has_USERS_USERS2`
    FOREIGN KEY (`USER_received`)
    REFERENCES `ForManiac`.`USERS` (`USER_number`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`DMs_TEXT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`DMs_TEXT` (
  `DM_USER_sent` INT NOT NULL,
  `DM_USER_received` INT NOT NULL,
  `DM_text` TEXT NOT NULL,
  `DM_image` MEDIUMBLOB NULL DEFAULT NULL,
  `DM_sent_date` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`DM_USER_sent`, `DM_USER_received`),
  CONSTRAINT `fk_TEXT_DMs1`
    FOREIGN KEY (`DM_USER_sent` , `DM_USER_received`)
    REFERENCES `ForManiac`.`DMs` (`USER_sent` , `USER_received`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ForManiac`.`FavoriteFields`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ForManiac`.`FavoriteFields` (
  `USER_number` INT NOT NULL,
  `FIELD_number` INT NOT NULL,
  `added_date` DATE NULL,
  PRIMARY KEY (`USER_number`, `FIELD_number`),
  INDEX `fk_USERS_has_Fields_Fields1_idx` (`FIELD_number` ASC),
  INDEX `fk_USERS_has_Fields_USERS1_idx` (`USER_number` ASC),
  CONSTRAINT `fk_USERS_has_Fields_USERS1`
    FOREIGN KEY (`USER_number`)
    REFERENCES `ForManiac`.`USERS` (`USER_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_USERS_has_Fields_Fields1`
    FOREIGN KEY (`FIELD_number`)
    REFERENCES `ForManiac`.`Fields` (`FIELD_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;

-- auto_increment setting
ALTER TABLE `ForManiac`.`USERS` auto_increment = 1001;
ALTER TABLE `ForManiac`.`POSTS` auto_increment = 1;
ALTER TABLE `ForManiac`.`COMMENTFIELDS` auto_increment = 1;
-- TIPS
-- AUTO_INCREMENT 값 초기화 하기
-- ALTER TABLE [테이블명] AUTO_INCREMENT=[시작할려는 순서]
-- AUTO_INCREMENT가 적용된 컬럼값 재정렬하기
-- SET @COUNT = 0; 여기서는 USER의 경우 1000까지는 관리자라서 1001부터 일반 유저다
-- UPDATE [테이블명] SET [컬럼명] = @COUNT:=@COUNT+1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
