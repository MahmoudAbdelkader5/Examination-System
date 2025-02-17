CREATE OR ALTER TRIGGER trg_CheckTotalMarkInsteadOf  
ON Exam_Question  
INSTEAD OF INSERT  
AS  
BEGIN  
    BEGIN TRY  
        DECLARE @exam_id INT;  
        DECLARE @course_id INT;  
        DECLARE @total_mark INT;  
        DECLARE @max_degree INT;  

        -- Ensure we handle multiple rows in the inserted table.  
        SELECT @exam_id = exam_id FROM inserted;  

        -- Fetch the course_id based on the given exam_id  
        SELECT @course_id = course_id  
        FROM Exam  
        WHERE Exam_Id = @exam_id;  

        -- Fetch the maximum degree for the course  
        SELECT @max_degree = max_degree  
        FROM Course  
        WHERE CourseID = @course_id;  

        -- Compute current total marks from Exam_Question for the exam_id  
        SELECT @total_mark = ISNULL(SUM(mark), 0)  
        FROM Exam_Question  
        WHERE exam_id = @exam_id;  

        -- Add new marks from the inserted records  
        SELECT @total_mark = @total_mark + ISNULL(SUM(mark), 0)  
        FROM inserted;  

        -- Check if the total marks exceed the maximum allowed  
        IF @total_mark > @max_degree  
        BEGIN  
            RAISERROR('Total mark exceeds the maximum degree for the course.', 16, 1);  
            ROLLBACK TRANSACTION;   
        END  
        ELSE  
        BEGIN  
            -- Insert the new records into Exam_Question  
            INSERT INTO Exam_Question (exam_id, Question_id, mark)  
            SELECT exam_id, Question_id, mark   
            FROM inserted;  
        END  
    END TRY  
    BEGIN CATCH  
        -- Handle errors and roll back the transaction  
        PRINT 'Error in trigger trg_CheckTotalMarkInsteadOf. Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR)   
              + ', Message: ' + ERROR_MESSAGE();  
        IF @@TRANCOUNT > 0  
            ROLLBACK TRANSACTION; -- Roll back the transaction in case of an error  
    END CATCH;  
END;
----------------------------------------------------------------------------
 --Students can see the exam and do it only on the specified time. 
CREATE or alter TRIGGER EnforceExamTime
ON Answer
after insert 
AS
BEGIN
    DECLARE @examStartTime time;
    DECLARE @examEndTime time;
    DECLARE @examID int;

    SELECT @examID = exam_id FROM inserted;

    SELECT @examStartTime = start_time, @examEndTime = end_time
    FROM Exam_Class
    WHERE exam_id = @examID;
	end
   IF CAST(GETDATE() AS TIME) < @examStartTime OR CAST(GETDATE() AS TIME) > @examEndTime
    BEGIN
	        RAISERROR('can not assign exam in this time', 16, 1);

        ROLLBACK TRANSACTION;
    END
	----------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
CREATE TRIGGER EnforceOneCoursePerInstructorPerYear
ON Instructor_Course
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @instructorID INT;
    DECLARE @year INT;

    SELECT @instructorID = Ins_ID, @year = year FROM inserted;

    IF EXISTS (
        SELECT 1
        FROM Instructor_Course
        WHERE Ins_ID = @instructorID AND year = @year AND course_id <> (SELECT course_id FROM inserted)
    )
    BEGIN
        RAISERROR('An instructor cannot teach more than one course in a year.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;



-------------------------- trg_PreventInvalidInsertInTableAnswer
create or alter trigger trg_PreventInvalidInsert  
ON Answer  
INSTEAD OF INSERT  
AS  
BEGIN  
    DECLARE @exam_id INT;  
    DECLARE @student_id INT;  

    DECLARE inserted_cursor CURSOR FOR SELECT exam_id, student_id FROM inserted;  

    OPEN inserted_cursor;  
    FETCH NEXT FROM inserted_cursor INTO @exam_id, @student_id;  

    WHILE @@FETCH_STATUS = 0  
    BEGIN  
        IF EXISTS (  
            SELECT 1  
            FROM Exam_Student  
            WHERE exam_id = @exam_id AND student_id = @student_id  
        )  
        BEGIN  
            INSERT INTO Answer (student_id, exam_id, Question_id, student_ans, is_correct)  
            SELECT student_id, exam_id, Question_id, student_ans, is_correct  
            FROM inserted  
            WHERE exam_id = @exam_id AND student_id = @student_id;  
        END  
        ELSE  
        BEGIN  
		print 'You not Assigned To This Exam'
           -- RAISERROR('Cannot insert Answer: The student_id %d and exam_id %d must exist in the Exam_Student table.', 16, 1, @student_id, @exam_id);  
        END;  

        FETCH NEXT FROM inserted_cursor INTO @exam_id, @student_id;  
    END;  

    CLOSE inserted_cursor;  
    DEALLOCATE inserted_cursor;  
END;

------------------------------------ insert track ------------------------
CREATE OR ALTER TRIGGER InsertTrack  
ON track   
AFTER INSERT  
AS  
BEGIN  
    DECLARE @message NVARCHAR(MAX);  

    SELECT @message = STRING_AGG('Welcome to our track ' + Name, '; ')  
    FROM inserted;  

    PRINT @message;  
END;
------------------------------------ insert branch ------------------------

CREATE OR ALTER TRIGGER insert_branch  
ON branch   
AFTER INSERT  
AS  
BEGIN  
    DECLARE @message NVARCHAR(MAX);  

    -- Initialize the message  
    SET @message = '';  

    SELECT @message = STRING_AGG('Welcome to our branch: ' + Name, '; ')  
    FROM inserted;  

    PRINT @message;  
END;


-------------------------------- insert department------------------

CREATE OR ALTER TRIGGER insert_department  
ON Department   
AFTER INSERT  
AS  
BEGIN  
    DECLARE @message NVARCHAR(MAX);  

    -- Initialize the message  
    SET @message = '';  

    SELECT @message = STRING_AGG('Welcome to our Department: ' + Name, '; ')  
    FROM inserted;  

    PRINT @message; 
END;

------------------------------  -------------------------------- insert INTAKE------------------
CREATE OR ALTER TRIGGER insert_intake  
ON intake   
AFTER INSERT  
AS  
BEGIN  
    PRINT 'Welcome to our intake!';  

    DECLARE @message NVARCHAR(MAX);  

    SELECT @message = STRING_AGG('Welcome intake: ' + Name, '; ')  
    FROM inserted;  

    PRINT @message; 
END;
