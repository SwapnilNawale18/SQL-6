use AdventureWorks2012;

select BusinessEntityID,Rate,
ROW_NUMBER() over(order by Rate desc) 'Series',
RANK() over (order by Rate desc) 'rank',
DENSE_RANK() over(order by Rate desc) 'WithoutGap'
from [HumanResources].[EmployeePayHistory];

create table empsales
(
productid int not null,
month int not null,
sales int not null
)

insert into EmpSales (productid,month,sales)
values (1,1,2000), (1,2,4500),(2,3,4800),(3,4,5600),(4,5,1500)

select * from empsales

select month,sales 'Current Month',
Lead(Sales) over(order by Month) 'Next Month',
Lag(Sales) over (order by Month) 'Previous Month'
from empsales

select BusinessEntityID, JobTitle,VacationHours
from HumanResources.Employee
where VacationHours>Any (select VacationHours
from HumanResources.Employee
where JobTitle='Recruiter')
order by VacationHours

select JobTitle, VacationHours 
from HumanResources.Employee e1
where JobTitle in('Buyer','Recruiter') and 
e1.VacationHours>(Select avg(VacationHours)
from HumanResources.Employee e2
where e1.JobTitle=e2.JobTitle
)

declare @rate int
select @rate=max(Rate)
from HumanResources.EmployeePayHistory
print @rate
if (@rate>120)
begin
print 'No need to revise'
end
go

create proc prcSales
as
begin
select * from empsales
end

exec prcSales

create proc prcMonthSales @m int
as
begin
Select *
from empsales
where month=@m
end

exec prcMonthSales 4

create proc prcEmpTitle @title varchar(20)
as
begin
select BusinessEntityID,LoginID,Gender
from HumanResources.Employee
where JobTitle=@title
end

exec prcEmpTitle 'Buyer'

-- display vh as output for given jobtitle at runtime
--alter
create proc prcTitleVH @title varchar(20), @vh int output
as
begin
select @vh=VacationHours
from HumanResources.Employee
where JobTitle=@title
end

Declare @v int 
exec prcTitleVH 'Tool Designer',@v output
print @v

-- display id,loginid, gender for the value jobtitle at runtime
--create
alter proc prcEmpTitle @title varchar(20)
as
begin
select BusinessEntityID,LoginID,Gender
from HumanResources.Employee
where JobTitle=@title
end

exec prcEmpTitle 'Buyer'

-- display vh as output for given jobtitle at runtime
alter proc prcTitleVH @title varchar(20), @vh int output
as
begin
select @vh=VacationHours
from HumanResources.Employee
where JobTitle=@title
end

Declare @v int 
exec prcTitleVH 'Tool Designer',@v output
print @v

create proc prcTitle @t varchar(20)
as
begin
Select BusinessEntityID,LoginId, JobTitle
from HumanResources.Employee
where JobTitle=@t
end

exec prcTitle 'Buyer'

create proc prcEmpDName @e int
as
begin
select Name
from HumanResources.Department d
where DepartmentID=(select DepartmentID
from HumanResources.EmployeeDepartmentHistory 
where BusinessEntityID=@e)
end

exec prcEmpDName 12

--create a proc which will create a table and insert values by calling it
create proc prcInsert
(
@sampleid int,
@samplename varchar(20)
)
as
begin
declare @tblSample Table(id int, Name varchar(20))
insert into @tblSample (id,Name) values(@sampleid,@samplename)
select * from @tblSample
end
go

--create another proc -- and call the previous proc
create proc prcCall @sid int, @sname varchar(20)
as
begin
exec prcInsert @sampleid=@sid, @samplename =@sname
end

exec prcCall 3,'Sample3' 