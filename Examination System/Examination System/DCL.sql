--- Create login account for each user 

create login [Admin] with password ='1234'
create login TrainingManager with password ='1234'
create login Instructor with password ='1234'
create login Student with password ='1234'

--- Create Database users

create user [Admin] for login [Admin]
create user TrainingManager for login TrainingManager
create user Instructor for login Instructor
create user Student for login Student

--- Create Role
create role AdminRole;
create role TrainingManagerRole;
create role InstructorRole;
create role StudentRole;

--- Assign User To role 
alter role AdminRole add member [Admin]
alter role TrainingManagerRole add member TrainingManager
alter role InstructorRole add member Instructor
alter role StudentRole add member Student

--Admin Permissions
grant control on database::Examination_System to AdminRole

--remove all permission from user and specify stored procedure that can access it
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo To TrainingManager
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo To Instructor
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo To Student



grant execute on schema::Tr_Manager to TrainingManager;
grant execute on schema::Instructor to Instructor;
grant execute ,select on schema::Student to Student;




