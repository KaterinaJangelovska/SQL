--Declare scalar variable for storing FirstName values
--Assign value ‘Antonio’ to the FirstName variable
--Find all Students having FirstName same as the variable

declare @FirstName nvarchar(100)
set @FirstName = 'Antonio'

select * 
from Student
where FirstName = @FirstName
go


--Declare table variable that will contain StudentId, StudentName and DateOfBirth
--Fill the table variable with all Female students

declare @FemaleStudents table 
(StudentId int, StudentName nvarchar(100), DateOfBirth date);

insert into @FemaleStudents
select Id, FirstName, DateOfBirth
from dbo.Student
where Gender = 'F'

select * 
from @FemaleStudents
go

--Declare temp table that will contain LastName and EnrolledDate columns
--Fill the temp table with all Male students having First Name starting with ‘A’
--Retrieve the students from the table which last name is with 7 characters

create table #MaleStudents
(LastName nvarchar (100), EnrolledDate date);

insert into #MaleStudents
select LastName, EnrolledDate
from dbo.Student
where Gender = 'M' and  FirstName like 'A%' 

select * 
from #MaleStudents
where Len(LastName) = 7    -- ne postojat
go 

--Find all teachers whose FirstName length is less than 5 and
--the first 3 characters of their FirstName and LastName are the same

declare @TeacherName table
(FirstName nvarchar(100), LastName nvarchar (100));

insert into @TeacherName
select FirstName, LastName
from dbo.Teacher
where len(FirstName) < 5
and substring(FirstName, 1, 3) = substring(LastName, 1, 3)

select * from @TeacherName
go

--Declare scalar function (fn_FormatStudentName) for retrieving the Student description for specific StudentId in the following format:
--StudentCardNumber without “sc-”
--“ – “
--First character of student FirstName
--“.”
--Student LastName

--select *
--from dbo.Student
--go

create function dbo.fn_FormatStudentName (@StudentId int)
returns nvarchar(100)
as
begin

declare @result nvarchar(100)

select @result = substring(StudentCardNumber,4,8) + ' - ' + left(FirstName,1) + '.' + LastName
from dbo.Student
where id = @StudentId

return @result

--drop function dbo.fn_FormatStudentName

end
go

select *,dbo.fn_FormatStudentName (id) as FunctionOutput
from dbo.Student


--Create multi-statement table value function that for specific Teacher and Course will return list of students (FirstName, LastName) 
--who passed the exam, together with Grade and CreatedDate

drop function if exists dbo.fn_SpecificTeacher;
go

create function dbo.fn_SpecificTeacher (@TeacherID int, @CourseID int)
returns @output table (StudentFirstName nvarchar(100),StudentLastName nvarchar (100), Grade smallint, CreatedDate date)
as
begin


insert into @output
select s.FirstName as StudentFirstName, s.LastName as StudentLastName, g.Grade as Grade, g.CreatedDate as CreatedDate
from dbo.[Grade] g
inner join dbo.Student s on s.Id = g.StudentID
inner join dbo.Student t on t.Id = g.TeacherID
where t.Id = @TeacherID and g.CourseID = @CourseID

return
end

go

declare @TeacherID int = 1
declare @CourseID int = 1

select * 
from dbo.fn_SpecificTeacher (@TeacherID, @CourseID)

