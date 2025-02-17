-- 1. Departments
INSERT INTO Department (Name) VALUES 
('Computer Science'),
('Information Technology'),
('Software Engineering'),
('Artificial Intelligence'),
('Cybersecurity');

-- 2. Branches
INSERT INTO Branch (Name, Location) VALUES 
('Cairo', 'Downtown Cairo'),
('Alexandria', 'Miami'),
('BaniSuef', 'Smart Village Bani_Suef'),
('Mansoura', 'El-Mansoura'),
('Aswan', 'Aswan City');

-- 3. Intakes
INSERT INTO intake (Name, start_date, end_date, Year, IsActive) VALUES 
('Intake 43', '2020-08-01', '2021-04-30', 2020, 0),
('Intake 44', '2021-08-01', '2022-04-30', 2021, 0),
('Intake 45', '2022-08-01', '2023-05-31', 2022, 0),
('Intake 46', '2023-09-01', '2024-02-28', 2023, 0),
('Intake 47', '2024-09-01', '2025-05-31', 2024, 1);


-- 4. Tracks
INSERT INTO track (Name, Dept_Id) VALUES 
('Full Stack', 3),
('Mobile Dev', 3),
('DevOps', 2),
('Data Science', 3),
('AI Engineer', 4);


-- 5. Classes
INSERT INTO Class(Track_Id, Intake_Id, Branch_Id)
values
(1, 5,3),
(2, 2,1),
(3, 3,2),
(4, 1,4),
(5, 4,5)

-- 6. Courses
INSERT INTO Course (C_Name, Description, max_degree, min_degree) VALUES 
('HTML & CSS', 'Web Fundamentals', 100, 50),
('JavaScript', 'Programming Basics', 100, 50),
('c#','C# Course For Beginers',100,70),
('OOP','OOP For Advanced',100,60),
('React.js', 'Frontend Framework', 100, 50),
('Node.js', 'Backend Development', 100, 50),
('Database', 'SQL Fundamentals', 100, 50);

-- 7. CourseTrack
INSERT INTO Course_Track(Course_Id, Track_Id)
values 
(1,1),
(2,1),
(3,1),
(4,1),
(7,1),
(5,1),
(6,1)

-- 8. Instructors
INSERT INTO Instructor(Ins_Name, Salary, Address, Phone,Ins_UserName,Ins_Password,  is_trainning_manager) VALUES 
('Ahmed Ali', 15000, 'Cairo', '01012345678', 'ahmed.ali', '123456', 0),
('Sara Mohamed', 16000, 'Alex', '01123456789', 'sara.m', '123456', 0),
('Mohamed Hassan', 17000, 'Giza', '01234567890', 'mohamed.h', '123456', 1),
('Nour Ahmed', 15500, 'Cairo', '01345678901', 'nour.a', '123456', 0),
('Hossam Ali', 16500, 'Alex', '01456789012', 'hossam.a', '123456', 0);

-- 9. Students
INSERT INTO student (fname, lname, Email, Phone, birth_date, st_UserName, st_Password, Track_Id, Intake_Id, Branch_Id) VALUES 
('Youssef', 'Ahmed', 'youssef@test.com', '01112345678', '2000-01-15', 'youssef.a', '123456', 1, 5,3),
('Nada', 'Mohamed', 'nada@test.com', '01223456789', '2001-03-20', 'nada.m', '123456', 2, 2, 1),
('Omar', 'Hassan', 'omar@test.com', '01334567890', '2000-06-10', 'omar.h', '123456', 3,3,2),
('Menna', 'Ali', 'menna@test.com', '01445678901', '2001-09-05', 'menna.a', '123456', 4,1,4),
('Khaled', 'Ibrahim', 'khaled@test.com', '01556789012', '2000-12-25', 'khaled.i', '123456',5,4,5);


-- 10. Questions
INSERT INTO Question (Que_Text, Type, Course_Id) VALUES 
('What is HTML?', 'Multiple choice', 1),
('Is JavaScript case-sensitive?', 'True & False', 2),
('Which of the following is not a React hook?', 'True & False', 5), 
('Explain Node.js architecture', 'Text', 6),
('What is a primary key?', 'Multiple choice', 7),
('What is the purpose of the using statement in C#?','Multiple choice',3),
('In C#, the string type is a value type.','True & False',3),
('Which of the following is used to declare a constant in C#?','Multiple choice',3),
('What is the default value of a Boolean type in C#?','Multiple choice',3),
('Which of the following data types can store a decimal value in C#?','Multiple choice',3);



INSERT INTO TrueFalseQuestion (Que_Id, CorrectAnswer) VALUES
(2, 'false'),
(3, 'false'),
(7, 'false');

-- Inserting choices for "What is HTML?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(1, 1, 'Hyper Text Markup Language', 1),
(1, 2, 'Hyper Transfer Markup Language', 0),
(1, 3, 'Hyper Text Modeling Language', 0);

-- Inserting choices for "What is a primary key?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(5, 1, 'A unique identifier for a record in a table', 1),
(5, 2, 'A field that is nullable', 0),
(5, 3, 'A foreign key reference to another table', 0);

-- Inserting choices for "What is the purpose of the using statement in C#?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(6, 1, 'To import namespaces', 0),
(6, 2, 'To automatically dispose of resources', 1),
(6, 3, 'To declare a constant value', 0);


-- Inserting choices for "Which of the following is used to declare a constant in C#?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(8, 1, 'constant', 0),
(8, 2, 'const', 1),
(8, 3, 'readonly', 0);

-- Inserting choices for "What is the default value of a Boolean type in C#?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(9, 1, 'True', 0),
(9, 2, 'False', 1),
(9, 3, '0', 0);


-- Inserting choices for "Which of the following data types can store a decimal value in C#?"
INSERT INTO MCQQuestionChoices (Que_Id, Choice_Id, Choice_Text, IsCorrect) 
VALUES 
(10, 1, 'int', 0),
(10, 2, 'double', 1),
(10, 3, 'char', 0);


INSERT INTO TextQuestion (Que_Id, CorrectAnswer) VALUES 
(4, 'Node.js uses an')

-- 12. Exams
INSERT INTO Exam (type, instructor_id,course_id) VALUES 
('Normal', 1,1),
('Normal', 2,2),
('Corrective', 1,3),
('Normal', 3,4),
('Normal', 4,1);


--16 allowance option
INSERT INTO ExmAllowanceOptions (Exam_Id, AllowanceOptions)  
VALUES (1, 'Extra Time');  

INSERT INTO ExmAllowanceOptions (Exam_Id, AllowanceOptions)  
VALUES (1, 'Calculator Allowed');  

INSERT INTO ExmAllowanceOptions (Exam_Id, AllowanceOptions)  
VALUES (2, 'Open Book');  

INSERT INTO ExmAllowanceOptions (Exam_Id, AllowanceOptions)  
VALUES (2, 'Extra Breaks');  

INSERT INTO ExmAllowanceOptions (Exam_Id, AllowanceOptions)  
VALUES (3, 'Assistance Allowed');

--17 Instructor_course
INSERT INTO Instructor_course (Ins_ID, Course_Id, Year)  
VALUES (1, 1, 2024);  

INSERT INTO Instructor_course (Ins_ID, Course_Id, Year)  
VALUES (2, 3, 2024);  

