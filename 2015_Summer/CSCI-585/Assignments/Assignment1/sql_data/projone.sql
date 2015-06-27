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
Query 3
*/
Select distinct(golfer.name) FROM golfer INNER JOIN round ON golfer.ID = round.golferID WHERE round.course = 'Wilson';
/*
+-----------+
| name      |
+-----------+
| Benjamin  |
| Noah      |
| Liam      |
| Connor    |
| Caleb     |
| Carter    |
| William   |
| Matthew   |
| Ryan      |
| Mason     |
| Jackson   |
| Oliver    |
| Alexander |
| Daniel    |
| Ethan     |
| Michael   |
| James     |
| Jack      |
| Lucas     |
+-----------+

*/


/*
Query 4
*/

SELECT SUM(course.greenfee) FROM course INNER JOIN round ON course.name = round.course INNER JOIN golfer ON round.golferID = golfer.ID WHERE golfer.name = 'Logan' AND EXTRACT(YEAR FROM round.day)=2013;
/*
+----------------------+
| SUM(course.greenfee) |
+----------------------+
|               160.00 |
+----------------------+

*/


/*
Query 5
*/
SELECT distinct(course) FROM round INNER JOIN golfer ON golfer.ID = round.golferID WHERE golfer.name = 'Michael' ;
/*
+---------+
| course  |
+---------+
| Harding |
| Rancho  |
| Wilson  |
+---------+
*/


/*
Query 6
*/
SELECT SUM(distinct(round.golferID)) FROM round WHERE round.tee='Harding';
/*
+-------------------------------+
| SUM(distinct(round.golferID)) |
+-------------------------------+
|                          NULL |
+-------------------------------+
/*


/*
Query 7
*/

SELECT golfer.name, round.score FROM round INNER JOIN golfer ON golfer.ID=round.golferID WHERE EXTRACT(YEAR FROM round.day) =2014 ORDER BY round.score ASC LIMIT 10;
/*
+---------+-------+
| name    | score |
+---------+-------+
| Matthew | 74 |
| Mason   | 75 |
| Matthew | 76 |
| Ryan    | 77 |
| Ryan    | 77 |
| Mason   | 77 |
| Michael | 78 |
| Matthew | 78 |
| Mason   | 80 |
| Ethan   | 80 |
+---------+-------+
*/


/*
Query 8
*/

SELECT MAX(round.score) FROM round WHERE round.tee='Yellow' AND round.course='Rancho';
/*
+------------------+
| MAX(round.score) |
+------------------+
|               92 |
+------------------+
*/


/*
Query 9
*/

SELECT AVG(round.score) FROM round WHERE round.course = 'RANCHO' AND round.day BETWEEN '2013-06-01' AND '2013-08-31' ;
/*
+------------------+
| AVG(round.score) |
+------------------+
|          85.6667 |
+------------------+
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
