--create view department
create or alter view department_veiw
with encryption
as
(
select name as [dept_name]
from Department 
)
--create view intake
create or alter view intake_veiw
with encryption
as
(
select name as [intake_name], start_date as[st_date], end_date as[enddate], year as[Year]
from intake 
)

--create view branch
create or alter view branch_veiw
with encryption
as
(
select Name as [branch_name],  location as[branch_loc]
from branch 
)
--create view track_Department
create or alter view track_dept_veiw
with encryption
as
(
select T.Name as [track_name],  T.Name as[dept_name]
from track T , Department D
where T.Dept_Id =D.Dept_Id
)

GO
----- create view track branch intake  
create or alter view track_branch_intack_view
with encryption
as
(
select T.Name as'Track Name',B.Name as'Branch Name',I.Name AS'Intake Name'
from track T,branch B,intake I, Class c
WHERE T.Track_Id=c.Track_Id and B.Branch_Id=c.Branch_Id and c.Intake_Id=c.Intake_Id
)
GO

--create view course
go
create view Course_veiw
with encryption
as
(
select C_Name as [course_name],  description as [course_desc],min_degree as[min_deg] ,max_degree as[max_deg]
from Course 
)
go 


--create view Student
go
create view student_veiw
with encryption
as
(
select fname + ' '+ lname as [st_name],  email as [st_email],phone as[phone] ,birth_date as[BD],Age AS [age]
from student 
)
go 


--create instructor_veiw
go
create view instructor_veiw
with encryption
as
(
select Ins_Name ,  Address as [Address],phone as[phone] ,Salary 
from instructor 
)
go 

--create exam_quetion_view
go
create OR ALTER view exam_quetion_view
with encryption
as
(
select Q.Que_Text, Q.type as[Question_type], E.type as[exam_type] , EQ.mark
from exam E,Question Q, Exam_Question EQ
where E.Exam_Id= EQ.exam_id AND Q.Qus_Id=EQ.Question_id
)
go 

--create course_TRACK
go
create OR ALTER view course_Track_view
with encryption
as
(
select T.Name AS [Track_name], c.C_Name as [course]
from track	T, Course_Track TR_crs , course c
where T.Track_Id= TR_crs.Track_Id and TR_crs.Course_Id= c.CourseID

)

--create instructor_course_veiw
go
create OR ALTER view instructor_course_view
with encryption
as
(
select ins.Ins_Name as [instructor_name], c.C_Name as [course],ins_crs.year as[year]
from instructor ins, instructor_course ins_crs , course c
where ins.Ins_ID=ins_crs.Ins_ID and ins_crs.course_id= c.CourseID

)
go 
  
  --create student_degree_view
go
create OR ALTER view student_degree_view
with encryption
as
(
select s.fname + ' '+ s.lname as [student_name] , e.type as[exam_type] ,ES.final_result
from exam e, student s,Exam_Student ES
where e.Exam_id= ES.exam_id and s.student_Id=ES.student_id

)



--1-------------------------------------
go
CREATE OR ALTER VIEW V_StudentFinalResultsByCourse (StudentFullName, CourseName, FinalResult)
with encryption
AS
SELECT 
    CONCAT(Std.Fname, ' ', Std.lname), 
    Cors.C_Name, 
    E_Std.final_result
FROM 
    student Std
JOIN 
    Exam_Student E_Std ON Std.student_Id = E_Std.student_id
JOIN 
    exam E ON E.Exam_Id = E_Std.exam_id
JOIN 
    Instructor Inst ON Inst.Ins_ID = E.instructor_id
JOIN 
    Instructor_course Inst_Cors ON Inst_Cors.Ins_ID = Inst.Ins_ID
JOIN 
    Course Cors ON Inst_Cors.course_id = Cors.CourseID;

GO
SELECT * FROM V_StudentFinalResultsByCourse;

--2------------------------------------------------
Go
CREATE OR ALTER VIEW V_ExamDetailsByTrackBranchIntakeDepartment 
(ExamId, TrackName, BranchName, IntakeName, DepartmentName)
AS
SELECT 
    Ex_C.exam_id,
    Trk.Name ,
    Bran.Name ,
    Itk.Name ,
    Dept.Name
FROM 
    Exam_Class Ex_C
JOIN 
    branch Bran ON Ex_C.branch_id = Bran.Branch_Id
JOIN 
    intake Itk ON Ex_C.intake_id = Itk.Intake_Id
JOIN 
    track Trk ON Ex_C.track_id = Trk.Track_Id
JOIN 
    Department Dept ON Trk.Dept_Id = Dept.Dept_Id;

GO
SELECT * FROM V_ExamDetailsByTrackBranchIntakeDepartment;
--3----------------------------------------------------
Go
CREATE OR ALTER VIEW V_AllowExamOptions AS
SELECT 
    Ex.Exam_Id AS ExamId, 
    ExAllow.AllowanceOptions AS ExamAllowanceOptions
FROM 
    exam Ex
JOIN 
    ExmAllowanceOptions ExAllow 
ON
    ExAllow.Exam_Id = Ex.Exam_Id;

go
SELECT * FROM V_AllowExamOptions;
---4-----------------------------------------------------

---5----------------------------------------------------
GO
CREATE OR ALTER VIEW V_StudentsEnrolledInCourses (StudentFullName,CourseName)
AS
SELECT 
    CONCAT(Std.fname, ' ', Std.lname), 
    Cors.C_Name
FROM 
    student Std
JOIN 
    Class Cls ON Cls.Track_Id = Std.Track_Id
JOIN 
    track Trk ON Cls.Track_Id = Trk.Track_Id
JOIN 
    Course_Track Cors_Trk ON Cors_Trk.Track_Id = Trk.Track_Id
JOIN 
    Course Cors ON Cors_Trk.Course_Id = Cors.CourseID;

GO
SELECT * FROM V_StudentsEnrolledInCourses;
---6------------------------------------------------
GO
CREATE OR ALTER VIEW V_InstructorsTeachingCourses(InstructorName,CourseName,Year)
AS
SELECT 
    Inst.Ins_Name, 
    Cors.C_Name , 
    Inst_cors.year
FROM 
    Instructor Inst
JOIN 
    Instructor_course Inst_cors ON Inst_cors.Ins_ID = Inst.Ins_ID
JOIN 
    Course Cors ON Inst_cors.course_id = Cors.CourseID;

GO
SELECT InstructorName FROM V_InstructorsTeachingCourses;


/********************************************************************************/
--1
go
CREATE OR ALTER VIEW StudentFinalResultsByCourse (StudentFullName, CourseName, FinalResult)
AS
SELECT 
    CONCAT(Std.Fname, ' ', Std.lname), 
    Cors.C_Name, 
    E_Std.final_result
FROM 
    student Std
JOIN 
    Exam_Student E_Std ON Std.student_Id = E_Std.student_id
JOIN 
    exam E ON E.Exam_Id = E_Std.exam_id
JOIN 
    Instructor Inst ON Inst.Ins_ID = E.instructor_id
JOIN 
    Instructor_course Inst_Cors ON Inst_Cors.Ins_ID = Inst.Ins_ID
JOIN 
    Course Cors ON Inst_Cors.course_id = Cors.CourseID;

GO
SELECT * FROM StudentFinalResultsByCourse;

--2------------------------------------------------
Go
CREATE OR ALTER VIEW ExamDetailsByTrackBranchIntakeDepartment 
(ExamId, TrackName, BranchName, IntakeName, DepartmentName)
AS
SELECT 
    Ex_C.exam_id,
    Trk.Name ,
    Bran.Name ,
    Itk.Name ,
    Dept.Name
FROM 
    Exam_Class Ex_C
JOIN 
    branch Bran ON Ex_C.branch_id = Bran.Branch_Id
JOIN 
    intake Itk ON Ex_C.intake_id = Itk.Intake_Id
JOIN 
    track Trk ON Ex_C.track_id = Trk.Track_Id
JOIN 
    Department Dept ON Trk.Dept_Id = Dept.Dept_Id;

GO
SELECT * FROM ExamDetailsByTrackBranchIntakeDepartment;
--3----------------------------------------------------
Go
CREATE OR ALTER VIEW AllowExamOptions AS
SELECT 
    Ex.Exam_Id AS ExamId, 
    ExAllow.AllowanceOptions AS ExamAllowanceOptions
FROM 
    exam Ex
JOIN 
    ExmAllowanceOptions ExAllow 
ON
    ExAllow.Exam_Id = Ex.Exam_Id;

go
SELECT * FROM AllowExamOptions;
---4-----------------------------------------------------

---5----------------------------------------------------
GO
CREATE OR ALTER VIEW StudentsEnrolledInCourses (StudentFullName,CourseName)
AS
SELECT 
    CONCAT(Std.fname, ' ', Std.lname), 
    Cors.C_Name
FROM 
    student Std
JOIN 
    Class Cls ON Cls.Track_Id = Std.Track_Id
JOIN 
    track Trk ON Cls.Track_Id = Trk.Track_Id
JOIN 
    Course_Track Cors_Trk ON Cors_Trk.Track_Id = Trk.Track_Id
JOIN 
    Course Cors ON Cors_Trk.Course_Id = Cors.CourseID;

GO
SELECT * FROM StudentsEnrolledInCourses;
---6------------------------------------------------
GO
CREATE OR ALTER VIEW InstructorsTeachingCourses(InstructorName,CourseName,Year)
AS
SELECT 
    Inst.Ins_Name, 
    Cors.C_Name , 
    Inst_cors.year
FROM 
    Instructor Inst
JOIN 
    Instructor_course Inst_cors ON Inst_cors.Ins_ID = Inst.Ins_ID
JOIN 
    Course Cors ON Inst_cors.course_id = Cors.CourseID;

GO
SELECT InstructorName FROM InstructorsTeachingCourses;
