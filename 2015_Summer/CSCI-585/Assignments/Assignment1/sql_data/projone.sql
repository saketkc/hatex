use DATABASE golf_db;
/*
Query 1
*/
SELECT count(distinct ID) from golfer;
/*
+--------------------+
| count(distinct ID) |
+--------------------+
|                 22 |
+--------------------+
1 row in set (0.02 sec)
*/


/*
Query 2
*/

SELECT course_name FROM tee WHERE tee.yardage > 6680;
/*
+-------------+
| course_name |
+-------------+
| Encino |
| Rancho |
| Wilson |
| Wilson |
+-------------+
*/

/*
Query 2
*/

SELECT distinct(golferID) FROM round WHERE round.course = 'WILSON';
/*
+----------+
| golferID |
+----------+
| 1317 |
| 1588 |
| 2101 |
| 2174 |
| 2454 |
| 3161 |
| 4108 |
| 4122 |
| 4185 |
| 4649 |
| 4891 |
| 5008 |
| 6418 |
| 7451 |
| 8909 |
| 8994 |
| 9352 |
| 9466 |
| 9672 |
+----------+
*/








/*
Query 10
*/
SELECT AVG(score) FROM round WHERE round.course = 'WILSON';
/*
+------------+
| AVG(score) |
+------------+
|    88.1622 |
+------------+
*/
