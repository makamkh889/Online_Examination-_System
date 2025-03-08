---------------------------select Stored procedures--------------------
use [ITI_Examination_System]
go
--------------Exam generation-------------
create procedure ExamGeneration
@sart_time time,
@start_date date,
@duration float,
@total_point int,
@courseName nvarchar(50)
as
begin 
  declare @courseId int
  select @courseId=course_id 
  from Course where course_name=@courseName

  insert into Exam(exam_start_time,exam_start_date,exam_duration,exam_total_point,course_id)
  values (@sart_time,@start_date,@duration,@total_point,@courseId)
end


exec ExamGeneration '10:00:00.0000000','2025-07-10',2,100,'Database Systems'

go
---------Exam Answers----------
CREATE PROCEDURE Get_Exam_Answers
@ExamId int
as
begin
    select question_head,question_body,question_answer
	from Question_Exam qe
	join Question q on qe.question_id=q.question_id
	where Exam_id=@ExamId
end

exec Get_Exam_Answers 1

go
----correct Answers of student to this exam-------------
CREATE PROCEDURE Exam_Correction_for_each_student
    @examId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @studentId INT, @questionId INT, @quePoints INT, @AnsStu NVARCHAR(100), @queAns NVARCHAR(100);

    DECLARE answer_cursor CURSOR FOR
    SELECT sa.student_id, sa.question_id, q.question_points, sa.AnswersStudent, q.question_answer
    FROM [dbo].[Student_Answer] sa
    INNER JOIN [dbo].[Question] q ON sa.question_id = q.question_id
    WHERE sa.exam_id = @examId;

    OPEN answer_cursor;
    
    FETCH NEXT FROM answer_cursor INTO @studentId, @questionId, @quePoints, @AnsStu, @queAns;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN

        UPDATE [dbo].[Student_Answer]
        SET student_que_grade = CASE 
                                    WHEN @AnsStu = @queAns THEN @quePoints 
                                    ELSE 0 
                                END
        WHERE student_id = @studentId AND exam_id = @examId AND question_id = @questionId;

        FETCH NEXT FROM answer_cursor INTO @studentId, @questionId, @quePoints, @AnsStu, @queAns;
    END;

    CLOSE answer_cursor;
    DEALLOCATE answer_cursor;

    PRINT 'Exam correction completed for exam ID: ' + CAST(@examId AS NVARCHAR(10));
END;


EXEC Exam_Correction_for_each_student @examId = 2;

go
---Report that returns the students information according to Department No parameter.
CREATE PROCEDURE GetStudentsByDepartment
    @DepartmentID INT
AS
BEGIN
    SELECT 
        s.student_id,
        u.user_name,
        u.email,
        u.phone,
        u.user_dob,
        u.user_Address,
        u.gender,
        t.track_name,
        d.department_name
    FROM Student s
    JOIN Users u ON s.user_ssn = u.user_ssn
    JOIN Track t ON s.track_id = t.track_id
    JOIN Department d ON t.department_id = d.department_id
    WHERE d.department_id = @DepartmentID;
END;

EXEC GetStudentsByDepartment @DepartmentID = 1;

go

--Report that takes the student ID and returns the grades of the student in all courses.
CREATE PROCEDURE GetStudentGrades
    @StudentID INT
AS
BEGIN
    SELECT 
        s.student_id,
        u.user_name,
        c.course_name,
        sc.student_course_grade
    FROM Student_Course sc
    JOIN Student s ON sc.student_id = s.student_id
    JOIN Users u ON s.user_ssn = u.user_ssn
    JOIN Course c ON sc.course_id = c.course_id
    WHERE s.student_id = @StudentID;
END;

EXEC GetStudentGrades @StudentID = 2;


go 

---Report that takes the instructor ID and returns the name of the courses that he teaches and the number of students per course.
CREATE PROCEDURE GetInstructorCoursesWithStudentCount
    @InstructorID INT
AS
BEGIN
    SELECT 
        i.instructor_id,
        u.user_name AS instructor_name,
        c.course_name,
        COUNT(sc.student_id) AS student_count
    FROM Instructor_Course ic
    JOIN Instructor i ON ic.instructor_id = i.instructor_id
    JOIN Users u ON i.user_ssn = u.user_ssn
    JOIN Course c ON ic.course_id = c.course_id
    LEFT JOIN Student_Course sc ON c.course_id = sc.course_id
    WHERE i.instructor_id = @InstructorID
    GROUP BY i.instructor_id, u.user_name, c.course_name;
END;

EXEC GetInstructorCoursesWithStudentCount @InstructorID = 1;

go
----Report that takes course ID and returns its topics.
CREATE PROCEDURE GetCourseTopics
    @CourseID INT
AS
BEGIN
    SELECT 
        c.course_id,
        c.course_name,
        t.topic_id,
        t.topic_name
    FROM Course c
    JOIN Topic t ON c.course_id = t.course_id
    WHERE c.course_id = @CourseID;
END;

EXEC GetCourseTopics @CourseID = 1;

go
--Report that takes exam number and returns Questions in it.
-----It take Exam Id and get question in it-----
CREATE PROCEDURE GetExamQuestions
    @ExamID INT
AS
BEGIN
    SELECT 
        e.exam_id,
        q.question_id,
        q.question_head,
        q.question_body,
        q.question_answer,
        q.question_points
    FROM Exam e
    JOIN Question_Exam qe ON e.exam_id = qe.exam_id
    JOIN Question q ON qe.question_id = q.question_id
    WHERE e.exam_id = @ExamID;
END;


EXEC GetExamQuestions @ExamID = 1;

go
-----get Exam by knowing his time and course then get question in it------
CREATE PROCEDURE Get_Questions_from_Exam
    @ExamDate DATE,
    @CourseName VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Find the specific exam ID for the given date and course
    DECLARE @ExamID INT;
    SELECT @ExamID = e.exam_id
    FROM Exam e
    JOIN Course c ON e.course_id = c.course_id
    WHERE e.exam_start_date = @ExamDate
    AND c.course_name = @CourseName;

    -- Retrieve questions for the specific exam
    SELECT q.question_id, q.question_head, q.question_body, q.question_answer, q.question_points
    FROM Question q
    JOIN Question_Exam qe ON q.question_id = qe.question_id 
    WHERE qe.exam_id = @ExamID;
END;

EXEC Get_Questions_from_Exam '2025-06-10', 'Database Systems';



go
-----Report that takes exam number and the student ID then returns 
---the Questions in this exam with the student answers.
CREATE PROCEDURE GetExamQuestionsWithStudentAnswers
    @ExamID INT,
    @StudentID INT
AS
BEGIN
    SELECT 
        e.exam_id,
        q.question_id,
        q.question_head,
        q.question_body,
        q.question_answer AS Correct_Answer,
        sa.AnswersStudent AS Student_Answer,
        sa.student_que_grade AS Student_Grade
    FROM Exam e
    JOIN Question_Exam qe ON e.exam_id = qe.exam_id
    JOIN Question q ON qe.question_id = q.question_id
    LEFT JOIN Student_Answer sa ON q.question_id = sa.question_id 
                                  AND sa.exam_id = e.exam_id
                                  AND sa.student_id = @StudentID
    WHERE e.exam_id = @ExamID;
END;


EXEC GetExamQuestionsWithStudentAnswers @ExamID = 1, @StudentID = 1;


go
-------Student Answer---------
create procedure Getstudent_answers
@ssn int,
@examId int
as
begin 
     declare @studentid int
	 select @studentid=student_id
	 from [dbo].[Student]
	 where user_ssn=@ssn

     select AnswersStudent
	 from [dbo].[Student_Answer] SA
	 where student_id=@studentid
end
exec Getstudent_answers 1,1
