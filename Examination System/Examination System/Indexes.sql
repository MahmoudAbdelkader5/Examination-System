-- Indexes on Intake table

-- Creates an index on the 'name' column to speed up queries filtering or sorting by intake name.
create nonclustered index IX_Intake_Name on intake(name);

-- Indexes on Branch Table

-- Improves performance when searching for branches by name.
create nonclustered index IX_Branch_Name on branch(name);

-- Indexes on Department Table

-- Helps with searching and sorting departments based on their name.
create nonclustered index IX_Department_Name on Department(name);

----------------------------------------------------------------------------
-- Indexes on Track Table

-- Speeds up queries filtering or sorting tracks by name.
create nonclustered index IX_Track_Name on Track(name);

-- Improves performance when filtering or joining tracks based on department ID.
create nonclustered index IX_Dept_id on Track(Dept_Id);

--------------------------------------------------------------------------
-- Indexes on Student Table

-- Index on student full name to optimize search and filtering operations.
create nonclustered index IX_Student_Name on Student(fname);

CREATE INDEX IX_Student_FullName ON student (fname ASC, lname ASC);
select fname,lname from Student
select fname+' '+lname as FullName from student

--------------------------------------------------------------------------------

-- Index on student birth date to speed up queries filtering students by birth date.
create nonclustered index IX_Student_birth_date on Student(birth_date);

-- Indexes on Course Table

-- Optimizes searches for courses by name.
create nonclustered index IX_Course_Name on Course(C_Name);

-- Indexes on Instructor Table

-- Improves query performance for retrieving instructors by name.
create nonclustered index IX_Instructor_Name on Instructor(Ins_Name);

-- Index on salary to enhance performance when filtering or sorting instructors by salary.
create nonclustered index IX_Instructor_salary on Instructor(salary);

-- Optimizes queries filtering instructors based on whether they are a training manager.
create nonclustered index IX_Instructor_is_trainning_manager on Instructor(is_trainning_manager);

-- Indexes on Instructor_Course Table

-- Enhances searches and filtering of instructor-course records based on the year.
create nonclustered index IX_Instructor_Course_Year on Instructor_course(year);

-- Indexes on Exam Table

-- Improves performance for filtering exams by type.
create nonclustered index IX_Exam_type on Exam(type);

-- Indexes on Exam_Class Table

-- Speeds up queries filtering exam classes based on exam ID, track ID, and start time.
create nonclustered index IX_Exam_Class_type on Exam_Class(exam_id,track_id,start_time);

-- Indexes on Question Table

-- Optimizes searches for questions based on their type.
create nonclustered index IX_Question_type on Question(type);

-- Indexes on Exam_Student Table

-- Improves query performance when filtering exam results by final result.
CREATE INDEX IX_Exam_Student_result ON Exam_Student (final_result asc);

-- Indexes on Answer Table

-- Speeds up lookups of answers by student ID.
create nonclustered index IX_Answer_student_id on Answer(student_id);

-- Enhances query performance for retrieving answers by question ID.
create nonclustered index IX_Answer_Question_id on Answer(Question_id);

-- Index on TrueFalseQuestion Table

-- Optimizes searches for true/false questions based on the correct answer.
create nonclustered index IX_TrueFalseQuestion_answer on TrueFalseQuestion(CorrectAnswer);

-- Index on Choices Table

-- Improves query performance for retrieving multiple-choice questions based on the correct answer.
create nonclustered index IX_Choices_answer on MCQQuestionChoices(IsCorrect);



