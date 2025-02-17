--Create Datatype and rule for Password 
Create type Password from nvarchar(8) not null
Create rule Pass_Rule as len(@password) = 6
sp_bindrule Pass_Rule , 'Password'

------------------------------------------------------------

---Create table Intake
create table intake
(
Intake_Id int primary key identity(1,1) ,
Name varchar(20) not null,
start_date date not null default getdate() ,
end_date date not null default getdate(),
IsActive bit default 0,
year int not null unique
);

---------------------------------------------
---Create table Branch
create table branch
(
Branch_Id int primary key identity(1,1) ,
Name varchar(20) not null,
location varchar(30)
);
------------------------------------------------

---Create table Department
create table Department(
Dept_Id int primary key identity(1,1),
[Name] varchar(25) not null,

);
--------------------------------------------

---Create table Track
create table track
(
Track_Id int primary key identity(1,1) ,
Name varchar(20),
Dept_Id int foreign key  references Department(Dept_Id) ON UPDATE CASCADE ON DELETE CASCADE
);

--------------------------------------------------------

---Create table Class associative entity between track,intake,branch
create table Class
(

Track_Id int not null ,
Intake_Id int not null,
Branch_Id int not null ,
FOREIGN KEY (Track_Id) REFERENCES Track(Track_Id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Intake_Id) REFERENCES Intake(Intake_Id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (Branch_Id) REFERENCES Branch(Branch_Id)ON UPDATE CASCADE ON DELETE CASCADE,
CONSTRAINT PK_Class PRIMARY KEY ( Track_Id, Intake_Id, Branch_Id),  


);

------------------------------------------------

---create table student 
create table student
(
student_Id int primary key identity ,
fname varchar(10) not null ,
lname varchar(10) not null,
email varchar(30) not null,
phone varchar(13) not null,
birth_date date,
Age as year(Getdate())- year(birth_date),
st_UserName nvarchar(15) not null,
st_Password Password not null,
Track_Id int ,
Intake_Id int ,
Branch_Id int ,
CONSTRAINT FK_Student_Class FOREIGN KEY ( Track_Id, Intake_Id, Branch_Id)
        REFERENCES Class( Track_Id, Intake_Id, Branch_Id) ON DELETE CASCADE
);
------------------------------------------------------------

--- Create table Course
CREATE TABLE Course (
    CourseID INT IDENTITY(1,1) PRIMARY KEY,
    C_Name NVARCHAR(255) NOT NULL,
	description varchar(max),
	max_degree int,
	min_degree int ,
   
);
--------------------------------------

---Create Course_Track result between track contain many courses
CREATE TABLE Course_Track (
 
    [Course_Id] [int] NOT NULL,
    [Track_Id] [int] NOT NULL,
    CONSTRAINT [FK_Course_Track_Courses] FOREIGN KEY ([Course_Id]) REFERENCES [Course] (CourseID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT [FK_Course_Track_Track] FOREIGN KEY ([Track_Id]) REFERENCES [dbo].[Track] ([Track_id])ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_Course_Track PRIMARY KEY ( Course_Id,Track_Id)
);


------------------------------------------------------------

---Create table instructor
CREATE TABLE Instructor (
    Ins_ID INT IDENTITY(1,1) PRIMARY KEY,
    Ins_Name NVARCHAR(255) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    Address NVARCHAR(255) NULL,
    Phone NVARCHAR(20) UNIQUE NOT NULL,
	Ins_UserName nvarchar(15) not null,
	Ins_Password Password not null,
	is_trainning_manager bit
);
---------------------------------------------------
----teach
---Create table Instructor_course result between many instructor teach many courses in deffirent years
CREATE TABLE Instructor_course (
    Ins_ID int,
    course_id int,
    year int,
	CONSTRAINT [FK_Instructor_course_Courses] FOREIGN KEY (course_id) REFERENCES [Course] (CourseID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT [FK_Instructor_course_Instrictor] FOREIGN KEY (Ins_ID) REFERENCES [dbo].[Instructor] (Ins_ID)ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PK_Instructor_course  PRIMARY KEY ( Course_Id,Ins_ID)
);
-----------------------------------------------------
--Create table exam 
create table exam 
(
Exam_Id int primary key identity ,
type varchar(10) not null check(type in('normal','corrective')) default 'normal',
instructor_id int,
course_id int,
FOREIGN KEY (instructor_id) REFERENCES Instructor(Ins_ID) ON DELETE SET NULL,
FOREIGN KEY (course_id) REFERENCES Course(CourseID) ON DELETE SET NULL
);

-----------------------------
----Create table ExmAllowanceOptions for exam 
Create table ExmAllowanceOptions
(
	Exam_Id int not null ,
	AllowanceOptions nvarchar(150) not null
	Constraint PK_ExmAllowanceOptions Primary Key(Exam_Id,AllowanceOptions),
	Constraint FK_ExmAllowanceOptions_Exam Foreign Key (Exam_Id) references Exam(Exam_Id)
)
---------------------------------------------------
----Create table Question 
CREATE TABLE [dbo].[Question] (
    [Qus_Id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Que_Text] [nvarchar](max) NOT NULL,
    type varchar(30) check (Type in ('Text' ,'True & False','Multiple choice')),
    [Course_Id] [int] NOT NULL,
	CONSTRAINT [FK_Question_course] FOREIGN KEY (Course_Id) REFERENCES [dbo].[course] (CourseID)ON UPDATE CASCADE ON DELETE CASCADE,
   
    
);
------------------------------------------

----Create table Exam_Class result between relation many exam related to many Class (intake.track,branch) 
create table Exam_Class
(
exam_id int,
track_id int,
branch_id int,
intake_id int,
FOREIGN KEY (Track_Id) REFERENCES Track(Track_Id) ON DELETE cascade,
FOREIGN KEY (Intake_Id) REFERENCES Intake(Intake_Id) ON DELETE cascade,
FOREIGN KEY (Branch_Id) REFERENCES Branch(Branch_Id) ON DELETE cascade,
CONSTRAINT PK_Exam_Class PRIMARY KEY ( exam_id,Track_Id, Intake_Id, Branch_Id) ,
start_time time not null  default '9:00:00' ,
end_time time not null  default '10:00:00',
Year int not null,
exam_date date
);



------------------------------------------------------
----Create table Exam_Student result between relation many student assigned to many exams
create table Exam_Student
(
exam_id int,
student_id int,
final_result int null default 0,
FOREIGN KEY (student_id) REFERENCES student(student_Id) ON DELETE cascade,
FOREIGN KEY (exam_id) REFERENCES exam(Exam_Id) ON DELETE cascade,

CONSTRAINT PK_Exam_Student PRIMARY KEY ( exam_id,student_Id)

);



---------------------------------------------------------

----Create table Exam_Question result between relation many exams contain many question (associative entity)
CREATE TABLE Exam_Question (
    exam_id int,
    Question_id int,
    mark int,
	CONSTRAINT [FK_Exam_Question_Question] FOREIGN KEY (Question_id) REFERENCES Question (Qus_Id)  ON DELETE CASCADE,
    CONSTRAINT [FK_Exam_Question_Exam] FOREIGN KEY ( exam_id) REFERENCES Exam (Exam_Id) ON DELETE CASCADE,
    CONSTRAINT PK_Exam_Question  PRIMARY KEY (  exam_id,Question_id)
);

--------------------------------------------------------------

----Create table Answer result between relation many student have many exam_question 
CREATE TABLE Answer (
    student_id int,
    exam_id int,
    Question_id int,
    student_ans varchar(20),
    is_correct bit,
	 
    CONSTRAINT [FK_Answer_Student] FOREIGN KEY (student_id) REFERENCES Student (student_Id)ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT FK_Answer_Exam_Question FOREIGN KEY ( exam_id, Question_id)
        REFERENCES Exam_Question( exam_id,Question_id) ON DELETE cascade,

    CONSTRAINT PK_Answer  PRIMARY KEY (  exam_id,Question_id,student_id)
);

-----------------------------------------------------------
----Create table TrueFalseQuestion result of is a relation
CREATE TABLE TrueFalseQuestion (
    Que_Id INT PRIMARY KEY,
    CorrectAnswer char(6) NOT NULL,
    FOREIGN KEY (Que_Id) REFERENCES Question(Qus_Id) ON DELETE CASCADE
);

----Create table MCQQuestion  result of is a relation

CREATE TABLE MCQQuestionChoices (
    Que_Id INT NOT NULL,  
    Choice_Id INT NOT NULL ,
    Choice_Text NVARCHAR(MAX) NOT NULL,
    IsCorrect BIT NOT NULL,  
    PRIMARY KEY (Que_Id, Choice_Id),
    FOREIGN KEY (Que_Id) REFERENCES Question(Qus_Id) ON DELETE CASCADE
);

----Create table TextQuestion result of is a relation
CREATE TABLE TextQuestion (
    Que_Id INT PRIMARY KEY,
    CorrectAnswer NVARCHAR(255) NOT NULL,
    FOREIGN KEY (Que_Id) REFERENCES Question(Qus_Id) ON DELETE CASCADE
);
--------------------------------------


/*********************************************************************/
/******************** Schemas For Permissions ***********************/
Create Schema Tr_Manager


ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddIntake;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_UpdateIntake;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddDepartment;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_UpdateDepartment;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddTrack;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_UpdateTrack;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddBranch;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_UpdateBranch;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddStudent;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_OpenClass;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_UpdateStudent;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_AddInstructor;
ALTER SCHEMA Tr_Manager TRANSFER dbo.instrucrors_courses_PROC;
ALTER SCHEMA Tr_Manager TRANSFER dbo.show_BranchTrack_proc;
ALTER SCHEMA Tr_Manager TRANSFER dbo.show_TrackCourses_proc;
ALTER SCHEMA Tr_Manager TRANSFER dbo.get_Departments  ;
ALTER SCHEMA Tr_Manager TRANSFER dbo.SP_GetIntakeData;
ALTER SCHEMA Tr_Manager TRANSFER dbo.proc_GetTrackBranchIntake;
ALTER SCHEMA Tr_Manager TRANSFER dbo.sp_StudentsEnrolledInCourses;
ALTER SCHEMA Tr_Manager TRANSFER dbo.sp_InstructorsTeachingCourses ;

------------------------------------------------------------------------
Create Schema Instructor

ALTER SCHEMA Instructor TRANSFER dbo.GetQuestionsByExamAndIntake  ;
ALTER SCHEMA Instructor TRANSFER dbo.sp_StudentFinalResultsByCourse;
ALTER SCHEMA Instructor TRANSFER dbo.sp_ExamDetailsByTrackBranchIntakeDepartment;

ALTER SCHEMA Instructor TRANSFER dbo.proc_AddQuestionToCourseOfIns  ;
ALTER SCHEMA Instructor TRANSFER dbo.proc_CreateExam;
ALTER SCHEMA Instructor TRANSFER dbo.proc_AssignExamToClass;

ALTER SCHEMA Instructor TRANSFER dbo.proc_CreateExamManually  ;
ALTER SCHEMA Instructor TRANSFER dbo.proc_AssignQueToExam;
ALTER SCHEMA Instructor TRANSFER dbo.proc_AssignStudentToExam;
ALTER SCHEMA Instructor TRANSFER dbo.sp_AllowExamOptions;


-------------------------------------------------------------------
Create Schema Student


ALTER SCHEMA Student TRANSFER dbo.proc_solvequestion;
ALTER SCHEMA Student TRANSFER dbo.proc_GetExamQuestionWithMark;
ALTER SCHEMA Student TRANSFER dbo.GetTotalDeForStudentExam;