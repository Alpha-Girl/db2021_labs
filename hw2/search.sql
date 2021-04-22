# 1 查询姓名中含有“科”字的学生学号和姓名

SELECT sno,
	sname
FROM Student
WHERE sname LIKE '%科%';

# 2 查询学分不低于 3 分的必修课课程号和课程名

SELECT cno,
	cname
FROM Course
WHERE credit >= 3;

# 3 查询选修了公选课但是缺少成绩的学生学号和姓名

SELECT Student.sno,
	Student.sname
FROM Student,
	Course,
	SC
WHERE Student.sno = SC.sno
	AND Course.cno = SC.cno
	AND Course.type = 3
	AND SC.score is null;

# 4 查询年龄大于 20 的学生学号、姓名和年龄

SELECT t1.sno,
	t1.sname,
	age
FROM Student
	natural JOIN (
		SELECT sno,
			sname,
			FLOOR(
				YEAR(now()) - YEAR(birthdate) + 1 / 1000 *(DAYOFYEAR(now()) - DAYOFYEAR(birthdate))
			) AS age
		FROM Student
	) AS t1
WHERE age > 20;

# 5 查询已选必修课总学分大于 16 并且所选通识课成绩都大于 75 分的学生姓名

SELECT sname
FROM Student
WHERE sno IN (
		SELECT sno
		FROM Course,
			SC
		WHERE type = 0
			AND SC.cno = Course.cno
		GROUP BY sno
		HAVING SUM(credit) > 16
	)
	AND sno not in(
		SELECT SC.sno
		FROM Course,
			SC
		WHERE type = 2
			AND score <= 75
			AND Course.cno = SC.cno
	);

# 6 查询已经修完所有必修课且成绩合格的学生学号和姓名

SELECT Student.sno,
	sname
FROM Student
WHERE not exists(
		SELECT *
		FROM Course
		WHERE not exists(
				SELECT *
				FROM SC
				WHERE SC.sno = Student.sno
					AND SC.cno = Course.cno
			)
			AND type = 0
	)
	AND student.sno not in(
		SELECT Student.sno
		FROM Student,
			SC,
			course
		WHERE Student.sno = SC.sno
			AND score < 60
			AND type = 0
	);

# 7 查询总平均成绩排名在前 50%（向上取整）的学生中必修课平均分最高的前 10 位同学，
# 要求返回这些学生的学号、姓名、必修课平均分以及课程总平均成绩（不足 10 位时则全
# 部返回）

WITH Total(sno, total_score) AS (
	SELECT sno,
		AVG(score)
	FROM Course
		natural JOIN SC
	GROUP BY sno
)
SELECT student.sno,
	sname,
	average_score,
	total_score
FROM Student,
	(
		SELECT SC.sno,
			AVG(score) AS average_score
		FROM SC
			natural JOIN Course
		WHERE type = 0
		GROUP BY SC.sno
	) AS tt,
	Total
WHERE student.sno = tt.sno
	AND Total.sno = student.sno
	AND (
		SELECT COUNT(*)
		FROM Total AS t2
		WHERE t2.total_score > Total.total_score
	) < CEIL(
		(
			SELECT COUNT(*)
			FROM Student
		) / 2
	)
ORDER BY average_score desc
LIMIT 10;

# 8 查询每门课程的课程名、课程类型、最高成绩、最低成绩、平均成绩和不及格率，要求结
# 果按通识课、必修课、选修课、公选课顺序排列（提示：课程名可能有重名）

with Total(cno, total_number) as(
	SELECT cno,
		COUNT(*)
	FROM SC
	GROUP BY cno
),
Fail(cno, fail_number) as(
	SELECT cno,
		COUNT(*)
	FROM SC
	WHERE score < 60
	GROUP BY cno
)
SELECT cname,
	type,
	max_grade,
	min_grade,
	average_score,
	fail_rate
FROM (
		Course
		natural JOIN (
			SELECT cno,
				MAX(score) AS max_grade,
				MIN(score) AS min_grade,
				AVG(score) AS average_score
			FROM SC
			GROUP BY cno
		) AS t1
		natural JOIN (
			SELECT cno,
				(fail_number /(cast(total_number AS float))) AS fail_rate
			FROM Total
				natural JOIN Fail
		) AS t2
	)
ORDER BY field(type, 2, 0, 1, 3);

# 9 查询存在课程重修不及格情况的学生学号、姓名以及重修不及格的课程号和课程名
# 第二次重修的课程不及格
SELECT SC.sno,
	sname,
	SC.cno,
	cname
FROM (
		SELECT sno,
			cno
		FROM (
				SELECT sno,
					cno,
					COUNT(term) AS c
				FROM SC
				GROUP BY sno,
					cno
			) AS t1
		WHERE c >= 2
	) AS t2
	natural JOIN (
		SELECT sno,
			cno,
			m_t
		FROM (
				SELECT sno,
					cno,
					MAX(term) AS m_t
				FROM SC
				GROUP BY sno,
					cno
			) AS t3
	) AS t4,
	Student,
	Course,
	SC
WHERE m_t = SC.term
	AND Student.sno = SC.sno
	AND Course.cno = SC.cno
	AND score < 60;

# 修两次的课程（假设第一次不及格才重修）

SELECT student.sno,
	sname,
	course.cno,
	cname
FROM (
		SELECT sno,
			cno
		FROM (
				SELECT sno,
					cno,
					COUNT(term) AS c
				FROM SC
				GROUP BY sno,
					cno
			) AS t6
		WHERE c >= 2
	) AS t3,
	Student,
	Course
WHERE Student.sno = t3.sno
	AND Course.cno = t3.cno;

# 10  SC 表中重复的 sno 和 cno 意味着该学生重修了课程（在不同的学期里），现在我们希
# 望删除学生重复选课的信息，只保留最近一个学期的选课记录以及成绩，请给出相应的
# SQL 语句

delete FROM SC AS t1
WHERE t1.term <>(
		SELECT *
		FROM (
				SELECT MAX(t2.term)
				FROM SC AS t2
				WHERE t1.sno = t2.sno
					AND t1.cno = t2.cno
			) AS alisname
	);