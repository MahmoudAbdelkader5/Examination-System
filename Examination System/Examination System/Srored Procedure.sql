/***********************************************************************/
/*************************** Instructor Strored **************************/



--Add Question For His Course 
create or alter procedure proc_AddQuestionToCourseOfIns
  @instructor_id int,
  @Ques_Text nvarchar(max),
  @type varchar(30),
  @crs_id int
as
Begin
    begin try
	if exists (select 1 from Instructor_course  WHERE Ins_ID = @instructor_id AND course_id = @crs_id)
        begin
		  insert into Exam_Question
		  values(@Ques_Text,@type,@crs_id );
		end 
	 else  
	     begin
		   print 'You cannot add question in course you donnot teach it '
		 end
	       
    end try

    begin catch
        PRINT 'Error in Adding Question.. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
    end catch

End;

exec proc_AddQuestionToCourseOfIns
    @instructor_id =2,
    @Ques_Text ='what is fk?',
    @type ='Multiple choice',
    @crs_id =4

-----------------------------------------------------------------------
----Create Exam Automatic with random Question 
-- Stored Procedure for Create Exam automatic random by system by Instructor 
create or alter procedure proc_createexam
  @type varchar(10),
  @instructor_id int,
  @num_t_f int = null,
  @num_mcq int = null,
  @num_text int = null,
  @crs_id int
as
begin
    begin try
        -- check if instructor can add exam in this intake
        declare @countintake int;
        set @countintake = (
            select count(*)  
            from intake 
            where isactive = 1 
            and year = (
                select year 
                from instructor_course ic
                where ic.ins_id = @instructor_id and ic.course_id = @crs_id
            )
        );

        -- start to create exam
        if @countintake = 1
        begin
            print 'you can add exam';

            insert into exam
            values(@type, @instructor_id, @crs_id);

            declare @exam_id int = scope_identity(); 

            print 'exam created successfully.';

            -- add true/false questions to exam
            if @num_t_f is not null
            begin 
                insert into exam_question(exam_id, question_id, mark)
                select @exam_id, qus_id, 25
                from (
                    select top(@num_t_f) qus_id 
                    from question 
                    where course_id = @crs_id and type = 'true & false'
                    order by newid()
                ) as t_f_questions;
            end

            -- add multiple-choice questions to exam
            if @num_mcq is not null
            begin 
                insert into exam_question(exam_id, question_id, mark)
                select @exam_id, qus_id, 25
                from (
                    select top(@num_mcq) qus_id 
                    from question 
                    where course_id = @crs_id and type = 'multiple choice'
                    order by newid()
                ) as mcq_questions;
            end
        end
        else
        begin
            print 'you cannot add exam';
        end
    end try
    begin catch
        print 'error in creating exam. error number: ' + cast(error_number() as varchar) 
              + ', message: ' + error_message();
    end catch
end;

exec proc_CreateExam
  @type ='normal',
  @instructor_id =2,
  @Num_T_F =1,
  @Num_mcq =2,
  @Num_Text =null,
  @crs_id =3

---------------------------------------------------------------------------
--Assign Exam To Class (track,intake,branch) with specific date and time 
go
create or alter procedure proc_AssignExamToClass 
    @exam_id int,
    @track_id int,
    @branch_id int,
    @intake_id int,
    @start_time time,
    @end_time time,
    @exam_date date
as
begin
    begin try
        declare @year int;

        -- get year of intake
        select @year = year
        from intake
        where intake_id = @intake_id;

        -- insert exam into class
        insert into exam_class (exam_id, track_id, branch_id, intake_id, start_time, end_time, year, exam_date)
        values (@exam_id, @track_id, @branch_id, @intake_id, @start_time, @end_time, @year, @exam_date);

        -- check if the insert was successful
        if @@rowcount > 0
        begin
            print 'success: exam added to class successfully.';
        end;
        else
        begin
            print 'error: exam was not added to class.';
        end;
   
    end try
    begin catch
        print 'error in adding exam to class. error number: ' 
              + cast(error_number() as varchar) 
              + ', message: ' + error_message();
    end catch
end;

exec proc_AssignExamToClass 
    @exam_id =8,
	@track_id =1,
	@branch_id =3,
	@intake_id =5,
	@start_time='10:00:00' ,
	@end_time ='11:00:00',
	@exam_date ='2025-05-10'

--------------------------------------------------------------
-- Create Exam Manually By Instructor 

create or alter procedure proc_CreatEexaMmanually
  @type varchar(10),
  @instructor_id int,
  @crs_id int
as
begin
    begin try
        -- check if instructor can add exam in this intake
        declare @countintake int;
        set @countintake = (
            select count(*)  
            from intake 
            where isactive = 1 
            and year = (
                select year 
                from instructor_course ic
                where ic.ins_id = @instructor_id and ic.course_id = @crs_id
            )
        );

        -- start to create exam
        if @countintake = 1
        begin
            insert into exam
            values(@type, @instructor_id, @crs_id);

            print 'Exam Created Successfully.';
        end
        else
        begin
            print 'you cannot add exam.';
        end
    end try
    begin catch
        print 'error in creating exam. error number: ' + cast(error_number() as varchar) 
              + ', message: ' + error_message();
    end catch
end;

exec proc_CreateExamManually
  @type ='normal',
  @instructor_id =2,
  @crs_id =3

  --------------------------------------------------------------------
--Assign Question to Exam    

create or alter proc proc_AssignQueToExam
  @exam_id int,
  @question_id int,
  @mark int
as 
begin
   begin try
   if not exists (select 1 from exam where Exam_Id=@exam_id)
     begin
	    print 'The Exam Does not Exist'
		return;
	 end
    if exists (select 1 from Exam_Question where exam_id=@exam_id and Question_id=@question_id)
     begin
	    print 'The Question Is Added Already'
		return;
	 end
     insert into Exam_Question
	 values(@exam_id,@question_id,@mark)
	 print 'Question Added Sucessfully !'
   end try

   begin catch
      PRINT 'Error in Add Question To Exam. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
   end catch
end

exec  proc_AssignQueToExam
  @exam_id =9,
  @question_id =7,
  @mark =8

  exec  proc_AssignQueToExam
  @exam_id =9,
  @question_id =8,
  @mark =8

    exec  proc_AssignQueToExam
  @exam_id =9,
  @question_id =10,
  @mark =8

---------------------------------------------------------------------------------
-- Assign Student To Exam check as normal exam or corective exam
CREATE OR ALTER PROCEDURE proc_AssignStudentToExam   
    @StudentId INT,  
    @ExamId INT
AS  
BEGIN  
    BEGIN TRY  
       
		declare @finalresult int
        declare @marks int
		 declare @typeExam varchar(25)
     set @typeExam=(select type from exam where Exam_Id=@ExamId)	
	  if(@typeExam='normal')
	     begin
	       insert into Exam_Student(exam_id,student_id)
	       values(@ExamId,@StudentId)
		    print 'Normal Exam Added To Student Sucessfully'
	     end
	  else if(@typeExam='corrective')
	     begin
		 select @finalresult=es.final_result ,@marks=SUM(eq.mark)
         from Exam_Student es,exam e,Exam_Question eq
         where student_id=@StudentId and es.exam_id=e.Exam_Id and eq.exam_id=es.exam_id and e.course_id  = (select course_id
		  from exam
		  where Exam_Id=@ExamId)
         group by final_result

        IF @finalresult < (@marks/2)  
        BEGIN  
            INSERT INTO Exam_Student (exam_id, student_id, final_result)  
            VALUES (@ExamId, @StudentId,0); 

            PRINT 'Corrective exam inserted for the student.';  
        END  
        ELSE  
        BEGIN  
            PRINT 'Student has passed the exam, corrective exam will not be inserted.';  
        END  
		 end
   
    END TRY  
    BEGIN CATCH  
        PRINT 'Error in inserting corrective exam. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR)   
            + ', Message: ' + ERROR_MESSAGE();  
    END CATCH  
END;


exec proc_AssignStudentToExam 1,9

------------------------------------------------------------------------
-- solve question
create or alter procedure proc_solvequestion
    @student_id int,
    @exam_id int,
    @question_id int,
    @stud_ans varchar(20)
as
begin
    declare @is_correct bit = 0;
    declare @question_type varchar(30);
    declare @mark int;

    -- get question type without returning the table
    select @question_type = type from question where qus_id = @question_id;

    if @question_type is null
    begin
        print 'error: invalid question id.';
        return;
    end;

    -- get the mark for the question
    select @mark = mark from exam_question where question_id = @question_id and exam_id = @exam_id;

    begin try
        begin transaction;
		 -- ensure the student has an entry in exam_student
        if  exists (select 1 from exam_student where student_id = @student_id and exam_id = @exam_id)
		begin
        -- check if the answer is correct
        if @question_type = 'multiple choice'
        begin
            if exists (select 1 from mcqquestionchoices where que_id = @question_id and iscorrect = 1 and choice_id = @stud_ans)
                set @is_correct = 1;
        end
        else if @question_type = 'true & false'
        begin
            if exists (select 1 from truefalsequestion where que_id = @question_id and correctanswer = @stud_ans)
                set @is_correct = 1;
        end
        else
        begin
            print 'error: unsupported question type.';
            rollback transaction;
            return;
        end;

        -- insert student's answer
        insert into answer (student_id, exam_id, question_id, student_ans, is_correct)
        values (@student_id, @exam_id, @question_id, @stud_ans, @is_correct);
      
	    print 'Question Solved Sucessfully !'
       
        if @is_correct = 1
            begin
                 update exam_student
                 set final_result = final_result + @mark
                 where student_id = @student_id and exam_id = @exam_id;
             end;

		
		   end 
		else
		   begin
		       print 'You not Assigned To This Exam'
		   end

        commit transaction;
    end try
    begin catch
        print 'error: ' + error_message();
        rollback transaction;
    end catch;
end;


exec proc_SolveQuestion
    @student_id =1,
	@exam_id =9,
	@question_id =7,
	@stud_ans ='false'

	select * from exam

exec proc_SolveQuestion
    @student_id =1,
	@exam_id =9,
	@question_id =8,
	@stud_ans ='2'

exec proc_SolveQuestion
    @student_id =1,
	@exam_id =9,
	@question_id =10,
	@stud_ans ='2'
	
---------------------------------------------------------
--Get Exam Question With Mark
create or alter procedure proc_GetExamQuestionWithMark
  @exam_id int
 
as
Begin
    begin try
	select q.Que_Text,type,mark
    from Exam_Question eq ,Question q 
    where eq.exam_id=@exam_id  and eq.Question_Id=q.Qus_Id
    end try

    begin catch
        PRINT 'Error in Get Question.. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
    end catch

End;

exec proc_GetExamQuestionWithMark 10
--------------------------------------------------------------------------------------
-- Get Final Result
CREATE OR ALTER PROCEDURE GetTotalDegreeForStudentExam  
    @student_id INT,  
    @exam_id INT 
AS  
BEGIN  
   
    IF @student_id <= 0 OR @exam_id <= 0  
    BEGIN  
     
        SELECT 'Invalid input. Student ID and Exam ID must be greater than zero.' AS ResultMessage  
        RETURN  
    END  

    
    IF NOT EXISTS (SELECT 1 FROM Exam_Student WHERE student_id = @student_id AND exam_id = @exam_id)  
    BEGIN  
        
        SELECT 'Student ID and Exam ID pair does not exist in Exam_Student table.' AS ResultMessage  
        RETURN  
    END  

    DECLARE @totalDegree INT
	
    -- Calculate total degree by summing up final results  
    SELECT @totalDegree = ISNULL(SUM(final_result), 0)  
    FROM Exam_Student  
    WHERE student_id = @student_id AND exam_id = @exam_id  
	

		
      
    -- Get the total degree required for passing from the Exam table  
    DECLARE @totalDegreeRequired INT  
    SELECT @totalDegreeRequired = ISNULL(sum(mark), 0) / 2   
    FROM Exam_Question  
    WHERE exam_ID = @exam_id  

    IF @totalDegree >= @totalDegreeRequired  
    BEGIN  
        SELECT @totalDegree AS TotalDegree, 'Pass' AS ResultMessage  
    END  
    ELSE  
    BEGIN  
        SELECT @totalDegree AS TotalDegree, 'Fail' AS ResultMessage  
    END  
END


exec GetTotalDegreeForStudentExam   
    @student_id =1,  
    @exam_id =9



/***************************************************************************/
/*************************** Stored Trainning Manager *********************/

--Stored Procedure for trainning manager to Add and Update intake
-- Add Intake
create or alter procedure proc_AddIntake
  @int_name varchar(20),
  @start_date date,
  @end_date date,
  @year int,
  @isactive bit
as
begin
  begin try
  if not exists (select 1 from intake where year = @year)
begin
    insert into intake (name, start_date, end_date, year, isactive)
    values (@int_name, @start_date, @end_date, @year, @isactive);
end
else
begin
    print 'error: duplicate year value.';
end
  end try

  begin catch
    PRINT 'Error in adding intake. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec Tr_manager.proc_AddIntake 'intake 77','2025-05-20','2025-06-30',2080,0



-- Update Intake with name or start date 
create or alter procedure proc_UpdateIntake
  @intake_id int,
  @intake_name varchar(20) =null,
  @start_date date =null,
  @is_active bit =null
as
begin
  begin try
 
      if not exists (select 1 from Intake WHERE Intake_Id =@intake_id)
	  begin
	     PRINT 'Error:Intake not found';
            RETURN;
	  end
      update  intake
	  set 
	   start_date=coalesce( @start_date,start_date),
	   name=coalesce( @intake_name,name),
	   IsActive=coalesce( @is_active, IsActive)
	   where Intake_Id=@intake_id
  end try

  begin catch
      print 'Error in Update Intake Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_UpdateIntake 1 ,'intake 45','2024-05-06',1


/**********************************************************************************/

--Stored Procedure for trainning manager to Add and Update Department

-- Add Department

create or alter procedure proc_AddDepartment
  @dept_name varchar(25)
as
begin
  begin try
      insert into Department
      values(@dept_name)
  end try

  begin catch
    PRINT 'Error in adding New Department. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_AddDepartment 'Software Development'



--*****************************************************************
-- Update Department with name  
create or alter procedure proc_UpdateDepartment
  @Dept_id int ,
  @Dept_name varchar(20) 
as
begin
  begin try
       if not exists (select 1 from Department WHERE Dept_Id =@Dept_id)
	  begin
	     PRINT 'Error:Department not found';
            RETURN;
	  end

      update  Department
	  set Name=@Dept_name 
	  where Dept_Id=@Dept_id
  end try

  begin catch
      print 'Error in Update Department Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_UpdateDepartment 1 ,'Test'


/******************************************************************/
--Stored Procedure for trainning manager to Add and Update Track
-- Add track

create or alter procedure proc_AddTrack
  @track_name varchar(25),
  @dept_id int
as
begin
  begin try
       
      insert into track
      values(@track_name,@dept_id)
  end try

  begin catch
    PRINT 'Error in adding New Track. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_AddTrack 'Front_End' ,1



--*************************************************************

-- Update track with name  or department assigned to it
create or alter procedure proc_UpdateTrack
   @track_id int,
   @track_name varchar(30) =null,
   @dept_id int =null
as
begin
  begin try
      if not exists (select 1 from track WHERE Track_Id = @track_id)
	  begin
	     PRINT 'Error:Track not found';
            RETURN;
	  end

      update track
	  set [Name]=coalesce(@track_name,name),
	  Dept_Id=coalesce(@dept_id,Dept_id)
	  where Track_Id=@track_id
  end try

  begin catch
      print 'Error in Update Track Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_UpdateTrack 1 ,null,1

select * from track

/*************************************************************************/

--Stored Procedure for trainning manager to Add and Update Branch

-- Add branch

create or alter procedure proc_AddBranch
  @branch_name varchar(25),
  @location varchar(250)
as
begin
  begin try
      insert into branch
      values(@branch_name,@location)
  end try

  begin catch
    PRINT 'Error in adding New Branch. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_AddBranch 'Minia Branch' ,'Minia University'



--*************************************************************

-- Update Branch with name or location
create or alter procedure proc_UpdateBranch
  @branch_id int,
  @branch_name varchar(25)=null,
  @location varchar(250)=null
as
begin
  begin try
      
      if not exists (select 1 from branch WHERE Branch_Id = @branch_id)
	  begin
	     PRINT 'Error: Branch not found';
            RETURN;
	  end

      update branch
	  set [Name]=coalesce(@branch_name,name),
	  location=coalesce(@location,location)
	  where Branch_Id=@branch_id
  end try

  begin catch
      print 'Error in Update Branch Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_UpdateBranch 1 ,null,'Bani_Suef Smart Village'

--Stored Procedure for trainning manager to Add and Update Student

-- Add Student

create or alter procedure proc_AddStudent
  @fname varchar(10),
  @lname varchar(10),
  @email varchar(30),
  @phone varchar(13),
  @birth_date date,
  @std_username varchar(10),
  @std_password varchar(10)
as
begin
  begin try
      insert into student(fname,lname,email,phone,birth_date,st_UserName,st_Password)
      values(@fname,@lname,@email,@phone,@birth_date,@std_username,@std_password)
  end try

  begin catch
    PRINT 'Error in adding New Student. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_AddStudent 
      @fname='Arwa',
      @lname='Alaa',
      @email='arwaalaa99@hotmail.com',
	  @phone='01011037481',
	  @birth_date='2002-04-11',
	  @std_username='Arwa1',
	  @std_password='p@ss12'


--**********************************************************
--Stored Procedure for  to open new  class (intake,branch,track)

-- open new class

create or alter procedure proc_OpenClass
  @track_id int,
  @intake_id int,
  @branch_id int
as
begin
  begin try
      insert into Class
      values( @track_id, @intake_id,@branch_id)
  end try

  begin catch
    PRINT 'Error in adding New Class. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_OpenClass
  @track_id= 1,
  @intake_id= 1,
  @branch_id= 1



/*****************************************************************************************/

-- Update Student to add to track,branch,intake

create or alter procedure proc_UpdateStudent
  @std_id int,
  @track_id int,
  @intake_id int,
  @branch_id int
as
begin
  begin try
     if not exists (select 1 from student WHERE student_Id =@std_id)
	  begin
	     PRINT 'Error: student not found';
            RETURN;
	  end
     update student
	 set
	 Track_Id=@track_id,
	 intake_id=@intake_id,
	 Branch_Id=@branch_id
	 where student_Id=@std_id
  end try

  begin catch
    PRINT 'Error in adding New Student. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch
end;

exec proc_UpdateStudent
  @std_id= 2,
  @track_id =1,
  @intake_id=1,
  @branch_id =1

/*****************************************************************/

--Stored For Add Instructor

create or alter procedure proc_AddInstructor
  @inst_name varchar(25),
  @salary decimal(10,2),
  @address varchar(50),
  @phone varchar(13),
  @ins_username varchar(13),
  @ins_password varchar(13),
  @is_trn_mgr bit
as
begin
  begin try
      insert into Instructor
      values( @inst_name,  @salary ,@address,@phone, @ins_username,@ins_password,@is_trn_mgr)
  end try

  begin catch
    PRINT 'Error in adding New Instructor. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE() ;
  end catch

end;

exec proc_AddInstructor
 @inst_name='Sara Salah',
  @salary =15000,
  @address='23 el_rawda street',
  @phone = '01011037481',
  @ins_username ='sara1',
  @ins_password ='p@ss12',
  @is_trn_mgr =0



/**************************************************************************/
/**************************** Student Stored *******************************/
--------------------------(1) Show Course TEACH by Instractor_ID--------------------------
create OR ALTER PROCEDURE  instrucrors_courses_PROC( @ins_id INT)
as
BEGIN
IF NOT exists(Select Ins_ID From instructor Where Ins_ID=@ins_id)
Select 'Instructor ID You have entered not exists' 

ELSE
select  I.Ins_Name AS'Instructor Name', C.C_Name AS'Corse Name'  
from instructor I,instructor_course IC ,Course C
where  I.Ins_ID=IC.Ins_ID AND C.CourseID=IC.course_id
 AND I.Ins_ID= @ins_id                          

END
GO
instrucrors_courses_PROC 1
END
Go
--------------------------(2) Show Tracks in this Branch --------------------------
create OR ALTER PROCEDURE show_BranchTrack_proc (@branch_name nvarchar(15))
as
BEGIN
IF NOT exists(Select Name From branch Where Name=@branch_name)
Select ' Branch Name not exists' 
else
select B.Name AS'Branch Name',T.Name AS'Track Name'
from branch B,track T,student S
WHERE  S.Branch_Id=B.Branch_Id   AND S.Track_Id=T.Track_Id 
AND B.Name=@branch_name
END
GO
Select Name From branch 
EXECUTE show_BranchTrack_proc @branch_name = 'Bani_suef Branch';  
--------------------------(3) Show Course in this Track --------------------------
CREATE OR ALTER PROCEDURE show_TrackCourses_proc (@track_name nvarchar(50))
AS
BEGIN
    IF NOT EXISTS (SELECT Name FROM track WHERE Name = @track_name)
    BEGIN
        SELECT 'Track Name does not exist'
    END
    ELSE
    BEGIN
        SELECT T.Name AS 'Track Name', C.C_Name AS 'Course Name'
        FROM track T
        INNER JOIN student S ON S.Track_ID = T.Track_Id 
        INNER JOIN Course C ON S.student_Id  = C.CourseID
        WHERE T.Name = @track_name
    END
END
EXECUTE show_TrackCourses_proc  'test';  

--get get_Departments
CREATE OR ALTER PROCEDURE get_Departments  
AS  
BEGIN  
    SELECT * FROM department_veiw;  
END

exec get_Departments  

--get SP_GetIntakeData

CREATE OR ALTER PROCEDURE SP_GetIntakeData
    @Year INT = NULL -- Optional parameter to filter by year
AS
BEGIN
    BEGIN TRY
        -- Query the intake_view and filter by year if provided
        SELECT 
            intake_name,
            st_date,
            enddate,
            Year
        FROM intake_veiw
        WHERE (@Year IS NULL OR Year = @Year);
    END TRY
    BEGIN CATCH
        -- Handle errors
        PRINT 'Error in SP_GetIntakeData. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR) 
              + ', Message: ' + ERROR_MESSAGE();
    END CATCH;
END;
exec SP_GetIntakeData
-----------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE proc_GetTrackBranchIntake  
    @TrackName NVARCHAR(100) = NULL,  
    @BranchName NVARCHAR(100) = NULL,  
    @IntakeName NVARCHAR(100) = NULL  
AS  
BEGIN  
    SET NOCOUNT ON;  

    -- Validation Conditions  
    IF @TrackName IS NOT NULL  
    BEGIN  
        IF NOT EXISTS (SELECT 1 FROM track WHERE Name = @TrackName)  
        BEGIN  
            RAISERROR('Invalid Track Name: %s', 16, 1, @TrackName);  
            RETURN;  
        END  
    END  

    IF @BranchName IS NOT NULL  
    BEGIN  
        IF NOT EXISTS (SELECT 1 FROM branch WHERE Name = @BranchName)  
        BEGIN  
            RAISERROR('Invalid Branch Name: %s', 16, 1, @BranchName);  
            RETURN;  
        END  
    END  

    IF @IntakeName IS NOT NULL  
    BEGIN  
        IF NOT EXISTS (SELECT 1 FROM intake WHERE Name = @IntakeName)  
        BEGIN  
            RAISERROR('Invalid Intake Name: %s', 16, 1, @IntakeName);  
            RETURN;  
        END  
    END  

    -- Main Query Execution  
    SELECT *  
    FROM track_branch_intack_view  
    WHERE (@TrackName IS NULL OR [Track Name] = @TrackName)  
      AND (@BranchName IS NULL OR [Branch Name] = @BranchName)  
      AND (@IntakeName IS NULL OR [Intake Name] = @IntakeName);  
END;  
GO

exec GetTrackBranchIntake

----------------------------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE GetQuestionsByExamAndIntake  
as
    -- Main Query Execution  
    SELECT *  
    FROM exam_quetion_view  
   

exec GetQuestionsByExamAndIntake






--------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE ValidateStudentResult  
    
AS  
BEGIN  
    
declare	@Score int
select @Score=final_result
from Exam_Student 
    -- Validate Score  
    IF @Score < 0 OR @Score > 100  
    BEGIN  
        RAISERROR('Invalid Score: %.2f. Score must be between 0 and 100.', 16, 1, @Score);  
        RETURN;  -- Exit if the score is out of range  
    END  
	select * from student_degree_view
    -- If all validations pass  
    PRINT 'Validation successful. All data is valid.';  
END;  
GO

EXEC ValidateStudentResult   -- Example parameters


GO
CREATE OR ALTER PROCEDURE sp_StudentFinalResultsByCourse
AS
BEGIN
    SELECT * FROM V_StudentFinalResultsByCourse;
END;
GO
Execute sp_StudentFinalResultsByCourse
--2---------
Go
CREATE OR ALTER PROCEDURE sp_ExamDetailsByTrackBranchIntakeDepartment
AS
BEGIN
    SELECT * FROM V_ExamDetailsByTrackBranchIntakeDepartment;
END;
GO 
execute  sp_ExamDetailsByTrackBranchIntakeDepartment
--3---------------------
Go
CREATE OR ALTER PROCEDURE sp_AllowExamOptions
AS
BEGIN
    SELECT * FROM V_AllowExamOptions;
END;
GO
execute  sp_AllowExamOptions
--4------------------------
--5------------------------
Go
CREATE OR ALTER PROCEDURE sp_StudentsEnrolledInCourses
AS
BEGIN
    SELECT * FROM V_StudentsEnrolledInCourses;
END;
GO
execute  sp_StudentsEnrolledInCourses

--6--------------------------------
Go
CREATE OR ALTER PROCEDURE sp_InstructorsTeachingCourses
AS
BEGIN
    SELECT * FROM V_InstructorsTeachingCourses;
END;
GO
execute  sp_InstructorsTeachingCourses



