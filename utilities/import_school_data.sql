-- ------------------------------------------------------------------------------------
--  A SQL script for importing School District Data into a MySQL database.
-- ------------------------------------------------------------------------------------

LOAD DATA INFILE '/tmp/SCHOOL_INFORMATION.csv' INTO TABLE school_information
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_name_1,school_name_2,address,school_zip,zip_plus_4,city,state_cd,phone_number,sch_start_grade,sch_term_grade,hpaddr,school_level_name,latitude,longitude);

LOAD DATA INFILE '/tmp/SCHOOL_ENROLLMENT.csv' INTO TABLE school_enrollment
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,sch_attendance,sch_enrollment,sch_student_entered,sch_student_withdrew);

LOAD DATA INFILE '/tmp/SCHOOL_ETHNICITY_LOW_INCOME.csv' INTO TABLE school_ethnicity_low_income
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,african_american,white,asian,latino,other,pacific_islander,american_indian,sch_low_income_family);

LOAD DATA INFILE '/tmp/SCHOOL_PSSA.csv' INTO TABLE school_pssa
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,grade,math_advanced_percent,math_proficient_percent,math_basic_percent,math_below_basic_percent,read_advanced_percent,read_proficient_percent,read_basic_percent,read_below_basic_percent,math_combined_percent,read_combined_percent
);

LOAD DATA INFILE '/tmp/SCHOOL_SERIOUS_INCIDENTS.csv' INTO TABLE school_serious_incidents
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(ulcs_no,school_year,assault,drug,morals,weapons,theft);

LOAD DATA INFILE '/tmp/SCHOOL_STUDENT.csv' INTO TABLE school_student
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,sch_spec_ed_services,sch_mg,sch_esol_services);

LOAD DATA INFILE '/tmp/SCHOOL_SUSPENSIONS.csv' INTO TABLE school_suspensions
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,total_suspensions,sch_one_time_susp,sch_two_time_susp,sch_three_time_susp,sch_more_than_three_susp);

LOAD DATA INFILE '/tmp/TEACHER_ATTEND.csv' INTO TABLE teacher_attend
	FIELDS TERMINATED BY ','
	ENCLOSED BY '"' 
	LINES TERMINATED BY '\n'
	IGNORE 1 LINES
	(school_code,school_year,sch_teacher_attend,sdp_teacher_attend_avg);
