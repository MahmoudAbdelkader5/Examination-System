CREATE OR ALTER FUNCTION GetTotalDeForStudentExam
    (@student_id INT,  
     @exam_id INT)  
RETURNS NVARCHAR(100)  
AS  
BEGIN  
    DECLARE @result NVARCHAR(100);  
    DECLARE @totalDegree INT;  
    DECLARE @totalDegreeRequired INT;  
    DECLARE @passingDegree INT;  

  
    IF @student_id <= 0 OR @exam_id <= 0  
    BEGIN  
        SET @result = 'Invalid input. Student ID and Exam ID must be greater than zero.';  
        RETURN @result;  
    END  

    IF NOT EXISTS (SELECT 1 FROM Exam_Student WHERE student_id = @student_id AND exam_id = @exam_id)  
    BEGIN  
        SET @result = 'Student ID and Exam ID pair does not exist in Exam_Student table.';  
        RETURN @result;  
    END  

 
    SELECT @totalDegree = ISNULL(final_result, 0)  
    FROM Exam_Student  
    WHERE student_id = @student_id AND exam_id = @exam_id;  

 
    SELECT @totalDegreeRequired = ISNULL(SUM(mark), 0)  
    FROM Exam_Question  
    WHERE exam_ID = @exam_id;  

 
    SET @passingDegree = @totalDegreeRequired * 0.5;  


    IF @totalDegree >= @passingDegree  
    BEGIN  
        SET @result = CONCAT(@totalDegree, ' : ', @totalDegreeRequired, ' - Pass');  
    END  
    ELSE  
    BEGIN  
        SET @result = CONCAT(@totalDegree, ' : ', @totalDegreeRequired, ' - Fail');  
    END  

    RETURN @result;  
END;