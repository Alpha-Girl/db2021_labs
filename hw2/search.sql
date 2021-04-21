# 1

#select sno,sname from Student where sname LIKE '%科%';

# 2

#select cno,cname from Course where credit>=3;

# 3
/*
select Student.sno,Student.sname
from Student,Course,SC
where Student.sno=SC.sno and Course.cno=SC.cno and
Course.type=3 and SC.score is null;

# 4

select t1.sno,t1.sname,age
from Student natural join(select sno,sname,FLOOR(YEAR(now())-YEAR(birthdate)+1/1000*(DAYOFYEAR(now())-DAYOFYEAR(birthdate))) as age from Student) as t1
where age > 20;

# 5

select sname
from Student
where sno IN (
    select sno 
    from Course,SC
    where type=0 and SC.cno=Course.cno
    group by sno
    having sum(credit)>16
    )
    and sno not in(
    select SC.sno
    from Course,SC
    where type=2 and score<=75 and Course.cno=SC.cno
    );

# 6

select Student.sno,sname
from Student
where not exists(
    select *
    from Course
    where not exists(
        select * 
        from SC
        where SC.sno=Student.sno and SC.cno=Course.cno)
    and type =0
)
and
student.sno not in(
    select Student.sno
    from Student,SC,course
    where Student.sno=SC.sno and score <60 and type =0
);

# 7

with Total(sno,total_score) as (
    select sno,avg(score)
    from Course natural join SC
    group by sno
)
select student.sno,sname,average_score,total_score
from Student ,
(
    select SC.sno,avg(score) as average_score 
    from SC natural join Course
    where type =0
    group by SC.sno
) as tt , Total 
where student.sno=tt.sno and Total.sno = student.sno and 
(
    select count(*) from Total as t2
     where t2.total_score > Total.total_score)
< ceil((select count(*) from Student)/2)
order by average_score desc limit 10;
# 8
/*
with Total(cno,total_number) as(
    select cno,count(*) from SC
    group by cno
),
Fail(cno,fail_number) as(
    select cno,count(*) 
    from SC
    where score<60
    group by cno
)
select cname,type,max_grade,min_grade,average_score,fail_rate
from (Course natural join
(
    select cno,max(score) as max_grade,min(score) as min_grade, avg(score) as average_score
    from SC
    group by cno
) as t1 natural join
(
    select cno,(fail_number/(cast(total_number as float))) as fail_rate
    from Total natural join Fail
) as tt
) 
order by field(type,2,0,1,3);

# 9
select SC.sno,sname,SC.cno,cname
from 
    (select sno,cno 
    from (
        select sno,cno,count(term) as c 
        from SC 
        group by sno,cno) as t6
    where c>=2 
    ) as t3
    natural join (
    select sno,cno,m_t
    from (
        select sno,cno,max(term) as m_t
        from SC 
        group by sno,cno) as t7
    ) as t4 ,Student,Course,SC 
where m_t=SC.term and Student.sno=SC.sno and Course.cno=SC.cno and score <60;
*/
select student.sno,sname,course.cno,cname
from 
    (select sno,cno 
    from (
        select sno,cno,count(term) as c 
        from SC 
        group by sno,cno) as t6
    where c>=2 
    ) as t3
    ,Student,Course 
where Student.sno=t3.sno and Course.cno=t3.cno;

# 10
/*
delete from SC as t1
where t1.term <>(select * from(
    select max(t2.term)
    from SC as t2
    where t1.sno=t2.sno and t1.cno=t2.cno) as alisname 
);