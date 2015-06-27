--
-- DROP DB
--

DROP DATABASE IF EXISTS golf_db;

--
-- CREATE DB
--

CREATE DATABASE golf_db;
USE golf_db;

--
-- Table structure for table `course`
--

DROP TABLE IF EXISTS `course`;
CREATE TABLE `course` (
  `name` varchar(40) NOT NULL CHECK (`name` <> ''),
  `greenfee` decimal(6,2) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `course`
--

LOCK TABLES `course` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `golfer`
--

DROP TABLE IF EXISTS `golfer`;
CREATE TABLE `golfer` (
  `ID` varchar(40) NOT NULL,
  `name` varchar(60) NOT NULL DEFAULT '',
  `home_course` varchar(40) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `golfer`
--

LOCK TABLES `golfer` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `round`
--

DROP TABLE IF EXISTS `round`;
CREATE TABLE `round` (
  `golferID` varchar(40) NOT NULL,
  `day` date NOT NULL,
  `course` varchar(40) NOT NULL,
  `tee` varchar(40) NOT NULL,
  `score` smallint(6) NOT NULL,
  UNIQUE KEY `golfer_date` (`golferID`,`day`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `round`
--

LOCK TABLES `round` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `tee`
--

DROP TABLE IF EXISTS `tee`;
CREATE TABLE `tee` (
  `course_name` varchar(40) NOT NULL,
  `name` varchar(40) NOT NULL,
  `course_rating` decimal(3,1) NOT NULL,
  `slope_rating` smallint(6) NOT NULL,
  `yardage` smallint(6) NOT NULL,
  UNIQUE KEY `tee_course_name` (`course_name`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tee`
--

LOCK TABLES `tee` WRITE;
UNLOCK TABLES;

LOAD DATA INFILE '/home/saket/hatex/2015_Summer/CSCI-585/Assignments/Assignment1/sql_data/courses_null.csv' IGNORE INTO TABLE course FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (name,greenfee);
LOAD DATA INFILE '/home/saket/hatex/2015_Summer/CSCI-585/Assignments/Assignment1/sql_data/tees_null.csv' IGNORE INTO TABLE tee FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (course_name,name, course_rating, slope_rating,yardage);
LOAD DATA INFILE '/home/saket/hatex/2015_Summer/CSCI-585/Assignments/Assignment1/sql_data/golfers_null.csv' IGNORE INTO TABLE golfer FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (ID, name, home_course);
LOAD DATA INFILE '/home/saket/hatex/2015_Summer/CSCI-585/Assignments/Assignment1/sql_data/rounds_null.csv' IGNORE INTO TABLE round FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES (golferID,day, course, tee, score );

