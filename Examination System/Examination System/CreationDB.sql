create database Examination_System
on 
primary 
(
	name='Exammination_SystemData',  
	filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Exammination_SystemData.mdf',
	size=10MB,
	filegrowth=10MB,
	Maxsize=50MB
)
Log on 
(
	name='Exammination_SystemLog', 
	filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Exammination_SystemLog.ldf', 
	size=5MB,
	filegrowth=10MB,
	Maxsize=40MB
)

--make new filegroup for db
alter database Examination_System
add filegroup ExamFG;

--add new file(ndf) in secondary file group 
alter database Examination_System 
add file
(
name='SecondFile',  
	filename='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\SecondFile.ndf',
	size=10MB,
	filegrowth=10MB,
	Maxsize=50MB
)
to filegroup ExamFG;
