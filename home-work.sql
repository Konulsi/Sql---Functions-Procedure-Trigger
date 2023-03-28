
create database CourseDb

use CourseDb

create table Students(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50),
	[Surname] nvarchar(50),
	[Age] int,
	[Email] nvarchar(100) unique,
	[Address] nvarchar(100)
)



INSERT INTO Students ([Name],[Surname],[Age],[Email],[Address])
VALUES ('Anar','Aliyev',27,'anar@gmail.com','Genclik'),
       ('Shamil', 'Abbasli',25,'shamil@gmail.com','Bayil'),
       ('Cavid' ,'Bashirov',29,'cavid@gmail.com','Ehmedli'),
       ('Besir',' Huseynzade',24,'besir@gmail.com','Mastaga'),
	   ('Zehra','Huseynzade',23,'zehra@gmail.com','Narimanov'),
       ('Lale', 'Aliyeva',21,'lale@gmail.com','Elmler')


select * from Students


create table StudentArchives(
	[Id] int primary key identity(1,1),
	[StudentID] int,
	[Operation] nvarchar(10),
	[Date] datetime
)


create trigger trg_deleteStudent on Students
after delete
as
BEGIN
	insert into StudentArchives([StudentID],[Operation],[Date])
	select Id,'Delete',GETDATE() from deleted
END


delete from Students where Id = 1


create procedure usp_deleteStudent
@id int
as
BEGIN
	delete from Students where Id = @id
END

exec usp_deleteStudent 2