-- ------------------------------------------------------------------------------------
--  A SQL script for creating a School District Database in a MySQL database instance.
-- ------------------------------------------------------------------------------------

DROP DATABASE IF EXISTS schooldata;

CREATE DATABASE schooldata;

USE schooldata;

DROP TABLE IF EXISTS school_information;
CREATE TABLE school_information (
	school_code INT(4),
	school_name_1 VARCHAR(30),
	school_name_2 VARCHAR(30),
	address VARCHAR(45),
	school_zip CHAR(5),
	zip_plus_4 CHAR(4),
	city VARCHAR(25),
	state_cd CHAR(2),
	phone_number CHAR(10),
	sch_start_grade CHAR(2),
	sch_term_grade CHAR(2),
	hpaddr VARCHAR(60),
	school_level_name VARCHAR(30),
	latitude FLOAT,
	longitude FLOAT,
	closure TINYINT(1)
);

DROP TABLE IF EXISTS school_enrollment;
CREATE TABLE school_enrollment (
	school_code INT(4),
	school_year CHAR(9),
	sch_attendance FLOAT,
	sch_enrollment INT(5),
	sch_student_entered INT(5),
	sch_student_withdrew INT(5)
);

DROP TABLE IF EXISTS school_ethnicity_low_income;
CREATE TABLE school_ethnicity_low_income (
	school_code INT(4),
	school_year INT(3),
	african_american INT(3),
	white INT(3),
	asian INT(3),
	latino INT(3),
	other INT(3),
	pacific_islander INT(3),
	american_indian INT(3),
	sch_low_income_family FLOAT
);

DROP TABLE IF EXISTS school_pssa;
CREATE TABLE school_pssa (
	school_code INT(4),
	school_year CHAR(9),
	grade CHAR(2),
	math_advanced_percent FLOAT,
	math_proficient_percent FLOAT,
	math_basic_percent FLOAT,
	math_below_basic_percent FLOAT,
	read_advanced_percent FLOAT,
	read_proficient_percent FLOAT,
	read_basic_percent FLOAT,
	read_below_basic_percent FLOAT,
	math_combined_percent FLOAT,
	read_combined_percent FLOAT
);

DROP TABLE IF EXISTS school_serious_incidents;
CREATE TABLE school_serious_incidents (
	ulcs_no INT(4),
	school_year CHAR(9),
	assault INT(5),
	drug INT(5),
	morals INT(5),
	weapons INT(5),
	theft INT(5)
);

-- Modify columns name in table to match otehr tables.
ALTER TABLE school_serious_incidents CHANGE ulcs_no school_code INT(4);

DROP TABLE IF EXISTS school_student;
CREATE TABLE school_student (
	school_code INT(4),
	school_year CHAR(9),
	sch_spec_ed_services INT(5),
	sch_mg INT(5),
	sch_esol_services INT(5)
);

DROP TABLE IF EXISTS school_suspensions;
CREATE TABLE school_suspensions (
	school_code INT(4),
	school_year CHAR(9),
	total_suspensions INT(5),
	sch_one_time_susp INT(5),
	sch_two_time_susp INT(5),
	sch_three_time_susp INT(5),
	sch_more_than_three_susp INT(5)
);

DROP TABLE IF EXISTS teacher_attend;
CREATE TABLE teacher_attend (
	school_code INT(4),
	school_year CHAR(9),
	sch_teacher_attend FLOAT,
	sdp_teacher_attend_avg FLOAT
);

-- Create database user.
CREATE USER 'schoolapi'@'loaclhost' IDENTIFIED BY 'password';
GRANT EXECUTE ON *.* TO 'schoolapi'@'localhost';
FLUSH PRIVILEGES;

-- Stored Procedures.
DELIMITER $$
DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolData`$$

CREATE PROCEDURE `schooldata`.`GetSchoolData`(IN table_name VARCHAR(50), IN code INT)
BEGIN
	SET @qry = CONCAT('SELECT * FROM ', table_name, ' WHERE school_code = ?');
	SET @code = code;
	PREPARE STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolSummary`$$

CREATE PROCEDURE `schooldata`.`getSchoolSummary`()
BEGIN
	SELECT school_name_1, school_code, school_level_name, hpaddr, latitude, longitude FROM school_information;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolClosingSummary`$$

CREATE PROCEDURE `schooldata`.`GetSchoolClosingSummary`()
BEGIN
	SELECT school_name_1, school_code, school_level_name, hpaddr, latitude, longitude FROM school_information WHERE closure ORDER BY school_name_1;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolSummaryByZip`$$

CREATE PROCEDURE `schooldata`.`GetSchoolSummaryByZip`(IN postal char(5))
BEGIN
	SET @qry = 'SELECT * FROM school_information WHERE school_zip = ?';
	SET @postal = postal;
	PREPARE STMT FROM @qry;
	EXECUTE STMT USING @postal;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolDetail`$$

CREATE PROCEDURE `schooldata`.`GetSchoolDetail`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_name_1, school_name_2, address, school_zip, zip_plus_4, city, state_cd, phone_number, sch_start_grade, sch_term_grade, hpaddr, school_level_name FROM school_information where school_code = ?';
	SET @code = code;
	PREPARE STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolEthnicity`$$

CREATE PROCEDURE `schooldata`.`GetSchoolEthnicity`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, african_american, white, asian, latino, other, pacific_islander, american_indian, sch_low_income_family FROM school_ethnicity_low_income WHERE school_code = ?';
	SET @code = code;
	PREPARE	STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolEnrollment`$$

CREATE PROCEDURE `schooldata`.`GetSchoolEnrollment`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, sch_attendance, sch_enrollment, sch_student_entered, sch_student_withdrew FROM school_enrollment WHERE school_code = ?';
	SET @code = code;
	PREPARE	STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolByRadius`$$

CREATE PROCEDURE `schooldata`.`GetSchoolByRadius`(IN code INT, IN miles INT)
BEGIN
	SET @qry = CONCAT('SELECT * , ( 3959 * ACOS( COS( RADIANS( (SELECT latitude from school_information where school_code = ', code, ') ) ) * COS( RADIANS( latitude ) ) * COS( RADIANS( longitude ) - RADIANS( (SELECT longitude from school_information where school_code = ', code, ') ) ) + SIN( RADIANS( (SELECT latitude from school_information where school_code = ', code, ') ) ) * SIN( RADIANS( latitude ) ) ) ) AS distance FROM school_information HAVING distance < ? ORDER BY distance');
	SET @miles = miles;
	PREPARE STMT FROM @qry;
	EXECUTE STMT USING @miles;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolStudent`$$

CREATE PROCEDURE `schooldata`.`GetSchoolStudent`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, sch_spec_ed_services, sch_mg, sch_esol_services FROM school_student WHERE school_code = ?';
	SET @code  = code;
	PREPARE STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolPSSA`$$

CREATE PROCEDURE `schooldata`.`GetSchoolPSSA`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, grade, math_advanced_percent, math_proficient_percent, math_basic_percent, math_below_basic_percent, read_advanced_percent, read_proficient_percent, read_basic_percent, read_below_basic_percent, math_combined_percent, read_combined_percent FROM school_pssa WHERE school_code = ?';
	SET @code = code;
	PREPARE	STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolIncident`$$

CREATE PROCEDURE `schooldata`.`GetSchoolIncident`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, assault, drug, morals, weapons, theft FROM school_serious_incidents WHERE school_code = ?';
	SET @code = code;
	PREPARE	STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DROP PROCEDURE IF EXISTS `schooldata`.`GetSchoolSuspension`$$

CREATE PROCEDURE `schooldata`.`GetSchoolSuspension`(IN code INT)
BEGIN
	SET @qry = 'SELECT school_year, total_suspensions, sch_one_time_susp, sch_two_time_susp, sch_three_time_susp, sch_more_than_three_susp FROM school_suspensions WHERE school_code = ?';
	SET @code = code;
	PREPARE	STMT FROM @qry;
	EXECUTE STMT USING @code;
END$$

DELIMITER ;
