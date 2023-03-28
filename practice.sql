--use P135

--create view getCustomersById
--as
--select * from Customers where Id = 1

--select * from getCustomersById



--FUNCTIONS
--functionun icherisinde ancaq select ishleri gorulur
--return typesi mutleq olmalidir

create function SayHelloWorld()
returns nvarchar(50)
as
BEGIN
	return 'Hello World'
END


--functionu chagirmaq
select dbo.SayHelloWorld()



create function dbo.writeWord(@word nvarchar(20))
returns nvarchar(50)
as
BEGIN
	return @word
END

--variable teyin etmek
declare @word nvarchar(20)= 'P135'

select dbo.writeWord(@word)




create function dbo.writeWordsWithTwoParametr(@word nvarchar(20), @source nvarchar(20))
returns nvarchar(50)
as
BEGIN
	return @word + @source
END

select dbo.writeWordsWithTwoParametr('Shaiq','P135') as 'Data'




create function dbo.sumOfNumbers(@num1 int, @num2 int)
returns nvarchar(50)
as
BEGIN
	return @num1 + @num2
END

select dbo.sumOfNumbers(5,10)




create function dbo.getCustomerCount()
returns int
as
BEGIN
	declare @count int
	--select count yazsaq return edecek table, biz ise bildirmiwikki bize int return edecek deye
	--ona gore vareybl teyin edib onu beraberlesdirib icindeki reqemi elde edib ele return edirik
	select @count = COUNT (*) from Customers
	return @count
END

select dbo.getCustomerCount()




create function dbo.getCustomerAvarageAgeById(@id int)
returns int
as
BEGIN
	declare @avgAge int
	select @avgAge = AVG (Age) from Customers where Id > @id
	return @avgAge
END

select * from Customers

select dbo.getCustomerAvarageAgeById(4)







--Procedure
 --Procedurun returnu olada biler, olmayada biler. functionun returnu hokmen olmalidir
 --Functionun ichinde ancaq select ishleri gorulur. Procedure de Crut(create,delete,update) ishleri gorulur, hemde select ishleri
 --functionun ancaq input parametrleri olur. yeni cholden parametr qebul edir, nese gosterir.
 --procedurede outputda olur. variable teyin edirsen evveline outpout yazib sonra procedureden choldede istifade ede bilirsen.
 --functionun ichinde procedureni chagirmaq olmur, procedurenin ichinde function chagirmaq olur.



 create procedure usp_SayHelloWorld
 as
 BEGIN
	print 'Hello world'
 END

 --procedureni ishletmek
 exec usp_SayHelloWorld



 create procedure usp_sumOfNums
 @num1 int,
 @num2 int
 as
 BEGIN
	print @num1 + @num2
 END


 exec usp_sumOfNums 5, 8


 --tableye procedure ile data elave etmek her defe insert yazib elave etmemek uchun
 create procedure usp_addCustomer
 @name nvarchar(50),
 @surname nvarchar(50),
 @age int
 as
 BEGIN
	insert into Customers([Name],[Surname],[Age])
	values(@name,@surname,@age)
 END

 exec usp_addCustomer 'ELi','Aliyev',18



 --tableden procedure ile data silmek  her defe delete yazib silmemek  uchun

  create procedure usp_deleteCustomer
 @id int
 as
 BEGIN
	delete from Customers where Id = @id
 END

 exec usp_deleteCustomer 3



 --tableden datani sil ve goster
   create procedure usp_deleteCustomerAndShowDatas
 @id int
 as
 BEGIN
	delete from Customers where Id = @id
	select * from Customers
 END

 exec usp_deleteCustomerAndShowDatas 8







 --classTask

 create table Users(
	[Id] int primary key identity(1,1),
	[Name] nvarchar(50),
	[Age] int,
	[IsDelete] bit
 )





--tableden silme emeliyyatatini isdeleted mentiqine gore yazib, ekranda silinmeyenleri gostermek.procedure ile yazmaq
create procedure usp_deleteUsersByIsDelete
@id int
as
BEGIN
	update  Users set IsDelete = 'true' where Id= @id
	select * from Users where IsDelete = 'false'
END


exec usp_deleteUsersByIsDelete 4


--procedur yazilir. 2 nvarchar qebulk edir 1ci text 2ci search text 2cinin 1cide olub olmamasini  yoxlayirssan

create procedure usp_searchOperation
@text nvarchar(100),
@search nvarchar(10)
as
BEGIN
	declare @num int
	select @num = CHARINDEX(@search, @text)

	if @num > 0 
		print 'Yes'
	else
		print 'No'
END

exec usp_searchOperation 'Azerbaycan', 'A'
 




 --Trigger
 --Trigger nedir?
 --Trigger tetiklemekdir
 --Bir tablede nese mueyyen bir ish gorende (yeni, data elave etmek, silmek, update elemek) 
 --bashqa bir tabledede de mueyyen ishler gorulsun (hemin tablede nese ish gormuruk ozu avtomatik olur).
 
 --deyishiklikleri neye edirikse, yeni hansi tablede prosesleri edirikse triggeri ona edirik. orada olan deyishiklikler diger tablede gorsenir

 create table UserLogs(
	[Id] int primary key identity(1,1),
	[UserID] int,
	[Operation] nvarchar(10),
	[Date] datetime
 )


 --triggeri yaradiriq ve hansi tablede olacaqsa, onu qeyd edirik(on Users)
 --create trigger trg_insertUser on Users
 --after insert
 --as
 --BEGIN
	----burada, deyisiklik etdiyimiz tabledeki deyisiklikleri diger tableye (yeni, userlogs-a) elave edirik
	--insert into UserLogs([UserId],[Operation],[Date])
	--select Id,'Insert',GETDATE() from inserted
 --END



 --trigger olan tableye teze data elave edende diger tablede(yeni, userLog) deyisiklik olsun
 --her defe insert etmmemk uchun bele yaziriq
 --create procedure usp_insertUser
 --@name nvarchar(20),
 --@age int
 --as
 --BEGIN
	--insert into Users([Name],[Age])
	--values (@name,@age)
 --END


 --exec usp_insertUser 'Ceyhun', 23


 --create trigger trg_deleteUser on Users
 --after delete
 --as
 --BEGIN
	--insert into UserLogs([UserId],[Operation],[Date])
	--select Id,'Delete',GETDATE() from deleted
 --END

 --delete from Users where Id = 1




 
 create trigger trg_updateUser on Users
 after update
 as
 BEGIN
	insert into UserLogs([UserId],[Operation],[Date])
	select Id,'Update',GETDATE() from deleted
 END


 --istediyimiz id li useri update edirik 

update Users
set [Age] = 30 where Id = 3

update Users
set [Name] = 'Alekber' where Id = 3


--id si 3-e beraber olan usere ne deyisiklikler olubsa onu gostermek

select * from UserLogs where UserID = 3

