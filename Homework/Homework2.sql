USE [SEDCHome]
GO

-- Find all students with FirstName = 'Antonio'
select *
from dbo.[Student] s
where FirstName = 'Antonio'

--DateOfBirth > '1999-01-01'
select *
from dbo.[Student] s
where DateOfBirth >=  '1999-01-01'

--Find all Male students
select *
from dbo.[Student] s
where Gender = 'M'

--Last name start with T
select *
from dbo.[Student] s
where LastName like 'T%'

--Enrolled in January 1998
select *
from dbo.[Student] s
where EnrolledDate = '1998-01-01'

-- lastName start with J and enrolled 1998
select *
from dbo.[Student] s
where LastName like 'J%' and  EnrolledDate >= '1998-01-01'

--all students Antonio ordered by LastName
select *
from dbo.[Student] s
where FirstName = 'Antonio'
order by LastName

-- all students ordered by firstName
select *
from dbo.[Student] s
order by FirstName

--all Male students ordere by enrolled date starting from last
select *
from dbo.[Student] s
order by EnrolledDate DESC

-- all teacher and students FirstName WITH DUPLICATES
select FirstName
from Teacher
UNION ALL
select FirstName
from Student

-- all teacher and students LastName WITHOUT DUPLICATES
select LastName
from Teacher
UNION 
select LastName
from Student

--all firstName for teacher and Students
select FirstName
from Teacher
UNION
select FirstName
from Student

-------------------------
ALTER TABLE [dbo].GradeDetails
ADD CONSTRAINT DF_GradeDetails_AchievementMaxPoints
DEFAULT 100 FOR [AchievementMaxPoint]
GO



ALTER TABLE [dbo].GradeDetails WITH CHECK
ADD CONSTRAINT CHK_GradeDetails_AchievementPoints
CHECK (AchievementPoints <= AchievementMaxPoint)
GO


ALTER TABLE [dbo].[Grade] WITH CHECK
ADD CONSTRAINT [FK_Grade_Teacher]
FOREIGN KEY([TeacherID])
REFERENCES [dbo].[Teacher] ([ID])
GO

-----------------------------------------
select c.Name as CourseName, a.Name as AchievmentType
from dbo.Course c 
cross join dbo.AchievementType a
GO


select t.FirstName as TeacherName, e.Grade as ExamGrade
from dbo.Teacher t
cross join dbo.Grade e 
GO

select DISTINCT n.FirstName, g.Grade
from [Grade] g
inner join dbo.Teacher n on n.ID = g.TeacherID

--SELECT column_name(s)
--FROM table1
--LEFT JOIN table2
--ON table1.column_name = table2.column_name;

select t.FirstName
from dbo.Teacher t
left join dbo.[Grade] g on t.ID = g.TeacherID
where g.TeacherID is null
go


select s.*
from dbo.[Grade] g
right join dbo.Student s on g.StudentID = s.ID
where g.StudentID is null
go