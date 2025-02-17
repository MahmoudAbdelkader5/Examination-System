-- Create Exam Manually
exec proc_CreateExamManually
  @type ='normal',
  @instructor_id =2,
  @crs_id =3

--assign exam to class
exec proc_AssignExamToClass 
    @exam_id =13,
	@track_id =1,
	@branch_id =3,
	@intake_id =5,
	@start_time='10:00:00' ,
	@end_time ='11:00:00',
	@exam_date ='2025-05-10'


--assign question to exam
exec  proc_AssignQueToExam
  @exam_id =13,
  @question_id =7,
  @mark =10

exec proc_AssignQueToExam
  @exam_id =13,
  @question_id =8,
  @mark =10

exec proc_AssignQueToExam
  @exam_id =13,
  @question_id =10,
  @mark =10
  

--assign student to exam 
exec proc_AssignStudentToExam
     @StudentId = 1,  
     @ExamId =13

	
exec Student.proc_SolveQuestion
    @student_id =1,
	@exam_id =13,
	@question_id =7,
	@stud_ans ='false'

exec Student.proc_SolveQuestion
    @student_id =1,
	@exam_id =13,
	@question_id =8,
	@stud_ans ='2'

exec Student.proc_SolveQuestion
    @student_id =1,
	@exam_id =13,
	@question_id =10,
	@stud_ans ='3'

--Get Final Result
select Student.GetTotalDeForStudentExam(1,13)	



------------------------------------------------------------------------



