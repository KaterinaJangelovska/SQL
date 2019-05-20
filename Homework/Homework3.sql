use [SEDCHome]
GO

-- calculate the count of all grades in system
select count(*) as Grades
from dbo.Grade 

--count of all grades per Teacher
select t.ID, t.FirstName, t.LastName, sum(Grade) as Grades
from dbo.[Grade] g
inner join Teacher t on t.ID = g.TeacherID
group by t.ID, t.FirstName, t.LastName
go

-- for first 100 students ID <100
select t.ID, t.FirstName, t.LastName, sum(Grade) as Grades
from dbo.[Grade] g
inner join Teacher t on t.ID = g.TeacherID
where g.StudentID < 100
group by t.ID, t.FirstName, t.LastName
go


--maximal grade, average grade per student
select StudentID, FirstName,  max(Grade) as maxG, avg(Grade) as avgG
from dbo.[Grade] g
inner join Student s on s.ID = g.StudentID
group by StudentID, FirstName
go

--all grades per teacher filter only grater then 200
select TeacherID, sum(Grade) as Grades
from dbo.[Grade] g
inner join Teacher t on t.ID = g.TeacherID
group by TeacherID
having sum(Grade) > 200
go

-- for first 100 students ID <100 filter teachers with more than 50 grade count
select t.ID, t.FirstName, t.LastName, sum(Grade) as Grades
from dbo.[Grade] g
inner join Teacher t on t.ID = g.TeacherID
where g.StudentID < 100
group by t.ID, t.FirstName, t.LastName
having sum(Grade) > 50

-- grade count, max grade and avg grade per student on all grades. Filter only records where maxG = avgG
select StudentID, s.FirstName as FirstName, s.LastName as LastName, max(Grade) as maxG, avg(Grade) as avgG
from dbo.[Grade] o
inner join dbo.Student s on s.id = o.StudentID
group by StudentID, s.FirstName, s.LastName
having  max(Grade) = avg(Grade)
go

--create new view that will list all studentsID and count of 
create view [vv_StudentGrades]
as
select StudentID, sum(Grade) as Grades
from dbo.[Grade] g
group by StudentID
go

--change the view to show student firstname and lastname instead of id
alter view [vv_StudentGrades]
as
select s.FirstName, s.LastName, sum(Grade) as Grades
from dbo.[Grade] g
inner join Student s on s.ID = g.StudentID
group by s.FirstName, s.LastName

-- list all rows from view ordered by biggest grade count
select *
from vv_StudentGrades
order by Grades desc

