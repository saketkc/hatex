use golf_db;
/*
Query 1
*/
SELECT golfer.name FROM golfer where ID IN (SELECT golferID FROM round WHERE  round.score>80);
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
| Logan     |
| Mason     |
| Jackson   |
| Oliver    |
| Jacob     |
| Alexander |
| Luke      |
| Daniel    |
| Ethan     |
| Michael   |
| James     |
| Jack      |
| Lucas     |
+-----------+
*/

/*
Query 2
*/
SELECT COUNT(golfer.name) FROM golfer WHERE ID NOT IN (SELECT golferID FROM round WHERE EXTRACT(YEAR FROM round.day)=2015);
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
| Logan     |
| Mason     |
| Jackson   |
| Oliver    |
| Jacob     |
| Alexander |
| Luke      |
| Daniel    |
| Ethan     |
| Michael   |
| James     |
| Jack      |
| Lucas     |
+-----------+
*/

/*
Query 3
*/

SELECT golfer.name, COUNT(round.day) as '#rounds' FROM round INNER JOIN golfer ON golfer.ID=round.golferID GROUP BY golfer.name ;
/*
+-----------+---------+
| name      | #rounds |
+-----------+---------+
| Alexander |      12 |
| Benjamin  |      10 |
| Caleb     |       3 |
| Carter    |       6 |
| Connor    |       6 |
| Daniel    |       8 |
| Ethan     |       6 |
| Jack      |       7 |
| Jackson   |       5 |
| Jacob     |       4 |
| James     |       8 |
| Liam      |      10 |
| Logan     |       4 |
| Lucas     |       9 |
| Luke      |       5 |
| Mason     |       8 |
| Matthew   |       8 |
| Michael   |       5 |
| Noah      |       8 |
| Oliver    |       7 |
| Ryan      |       6 |
| William   |       5 |
+-----------+---------+
*/

/*
Query 4
*/
SELECT golfer.name, COUNT(round.day) as '#rounds' FROM round INNER JOIN golfer ON golfer.ID=round.golferID WHERE EXTRACT(YEAR FROM round.day)=2013 GROUP BY golfer.name ;
/*
+-----------+---------+
| name      | #rounds |
+-----------+---------+
| Alexander |       3 |
| Benjamin  |       4 |
| Carter    |       2 |
| Connor    |       1 |
| Daniel    |       3 |
| Ethan     |       1 |
| Jack      |       3 |
| Jacob     |       2 |
| James     |       2 |
| Liam      |       4 |
| Logan     |       2 |
| Lucas     |       6 |
| Luke      |       1 |
| Mason     |       3 |
| Matthew   |       1 |
| Michael   |       1 |
| Noah      |       1 |
| Oliver    |       1 |
| Ryan      |       3 |
| William   |       1 |
+-----------+---------+
*/

/*
Query 5
*/
CREATE VIEW differential AS SELECT * , (round.score-tee.course_rating)*113/tee.slope_rating AS differential FROM round INNER JOIN tee WHERE round.tee = tee.name AND tee.course_name=round.course;



/*
Query 6
*/

SELECT DISTINCT(golfer.name), differential.differential FROM differential  INNER JOIN golfer WHERE golfer.ID=differential.golferID GROUP BY golfer.name ORDER BY differential.differential ASC LIMIT 3;
/*
+--------+--------------+
| name   | differential |
+--------+--------------+
| Ryan   |      5.83833 |
| Carter |     12.84091 |
| Caleb  |     13.03063 |
+--------+--------------+
*/

/*
Query 7
*/

SELECT DISTINCT(golfer.name), differential.differential FROM differential  INNER JOIN golfer WHERE golfer.ID=differential.golferID AND differential.course='Harding' ORDER BY differential.differential ASC LIMIT 1;
/*
+------+--------------+
| name | differential |
+------+--------------+
| Ryan |      5.32314 |
+------+--------------+
*/
