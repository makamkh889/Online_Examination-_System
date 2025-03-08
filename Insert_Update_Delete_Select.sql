use [ITI_Examination_System]
go
-----Get All users-----
CREATE PROCEDURE Get_Users
AS
BEGIN
    SELECT * FROM Users;
END;

EXEC Get_Users;
go
-----Get All Instractors-----
CREATE PROCEDURE Get_Instructor
AS
BEGIN
    SELECT *
    FROM Users U
    INNER JOIN Instructor I ON I.user_ssn = U.user_ssn;
END;

EXEC Get_Instructor;
go
-----Get All Instractors-----
CREATE PROCEDURE Get_Students
AS
BEGIN
    SELECT *
    FROM Users U
    INNER JOIN Student S ON S.user_ssn = U.user_ssn;
END;

EXEC Get_Students;

go 
--------get Instractors which in specif department-------
CREATE PROCEDURE Get_Instructors_By_Department
    @DepartmentName NVARCHAR(50)
AS
begin
    select U.user_ssn, U.user_name, U.email, U.phone, I.instructor_salary, I.instructor_degree
    from Users U
    INNER JOIN Instructor I ON U.user_ssn = I.user_ssn
    INNER JOIN Department D ON I.department_id = D.department_id
    WHERE D.department_name = @DepartmentName;
end;

EXEC Get_Instructors_By_Department @DepartmentName = 'Computer Science';



go
--------Add user------



go
-----------Add student---------
CREATE PROCEDURE AddStudent
     @p_student_id INT,
     @p_user_ssn BIGINT,
     @p_track_id INT
	 as
BEGIN
    INSERT INTO Student (Student_ID, user_ssn, track_id)
    VALUES (@p_student_id, @p_user_ssn, @p_track_id);
END;
