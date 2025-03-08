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
CREATE PROCEDURE Add_User
    @user_name VARCHAR(100),
    @password VARCHAR(255),
    @user_type VARCHAR(20),
    @email VARCHAR(100),
    @phone VARCHAR(20) = NULL,
    @user_dob DATE = NULL,
    @user_Address VARCHAR(100) = NULL,
    @gender VARCHAR(10)
AS
BEGIN

    IF EXISTS (SELECT 1 FROM Users WHERE email = @email)
    BEGIN
        PRINT 'Error: This email is already registered.';
        RETURN;
    END


    INSERT INTO Users (user_name, password, user_type, email, phone, user_dob, user_Address, gender)
    VALUES (@user_name, @password, @user_type, @email, @phone, @user_dob, @user_Address, @gender);

    PRINT 'User added successfully';
END;


EXEC Add_User  'Ali Ahmed','Ali@123','student','ali.ahmed@example.com','0123456789','2000-05-15',
     'Giza, Egypt','male';



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

go
------Delete the course------
CREATE PROCEDURE DeleteCourse
    @course_id INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Course WHERE course_id = @course_id)
    BEGIN
        PRINT 'Error: Course not found.';
        RETURN;
    END

    
    DELETE FROM Course WHERE course_id = @course_id;

    PRINT 'Course deleted successfully.';
END;

EXEC DeleteCourse  3;

go
---- Update the course---------
CREATE PROCEDURE UpdateCourse
    @course_id INT,
    @new_course_name VARCHAR(100),
    @new_course_duration INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Course WHERE course_id = @course_id)
    BEGIN
        PRINT 'Error: Course not found.';
        RETURN;
    END

    
    UPDATE Course
    SET course_name = @new_course_name,
        course_duration = @new_course_duration
    WHERE course_id = @course_id;

    PRINT 'Course updated successfully.';
END;


EXEC UpdateCourse  2, 'Advanced Web Development', 75;


go
 ---Update Student Grade for a Specific Question--------
CREATE PROCEDURE UpdateStudentGrade
    @student_id INT,
    @exam_id INT,
    @question_id INT,
    @new_grade INT
AS
BEGIN

    IF NOT EXISTS (SELECT 1 FROM Student_Answer 
                   WHERE student_id = @student_id 
                   AND exam_id = @exam_id 
                   AND question_id = @question_id)
    BEGIN
        PRINT 'Error: No answer found for this student in the specified exam and question.';
        RETURN;
    END

    UPDATE Student_Answer
    SET student_que_grade = @new_grade
    WHERE student_id = @student_id 
          AND exam_id = @exam_id 
          AND question_id = @question_id;

    PRINT 'Student grade updated successfully.';
END;

EXEC UpdateStudentGrade  1, 1,  2, 9;


go

