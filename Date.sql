-- Insert Users (General users with different roles)
INSERT INTO Users (user_name, password, user_type, email, phone, user_dob, user_Address, gender)
VALUES 
('John Doe', 'password123', 'instructor', 'john.doe@example.com', '1234567890', '1985-03-15', '123 Main St', 'male'),
('Jane Smith', 'securepass', 'student', 'jane.smith@example.com', '9876543210', '1998-07-22', '456 Elm St', 'female'),
('Michael Johnson', 'pass456', 'Employee', 'michael.johnson@example.com', '5556667777', '1990-05-10', '789 Oak St', 'male'),
('Emily Davis', 'mypassword', 'student', 'emily.davis@example.com', '4443332222', '2000-08-30', '101 Pine St', 'female');

-- Insert Branch
INSERT INTO Branch (branch_name, branch_phone, branch_city)
VALUES 
('Cairo Branch', '123456789', 'Cairo'),
('Alexandria Branch', '987654321', 'Alexandria'),
('Giza Branch', '555666777', 'Giza'),
('Mansoura Branch', '444333222', 'Mansoura');

-- Insert Instructor
INSERT INTO Instructor (instructor_salary, instructor_degree, department_id, user_ssn)
VALUES 
(15000.00, 'PhD in Computer Science', 1, 1),
(12000.00, 'MSc in IT', 2, 2),
(14000.00, 'PhD in AI', 3, 3),
(11000.00, 'MSc in Data Science', 4, 4);

-- Insert Department
INSERT INTO Department (department_name, branch_id, manager_id)
VALUES 
('Computer Science', 1, 1),
('Information Technology', 2, 2),
('Artificial Intelligence', 3, 3),
('Cybersecurity', 4, 4);

-- Insert Track
INSERT INTO Track (track_name, department_id)
VALUES 
('Software Engineering', 1),
('Data Science', 2),
('Machine Learning', 3),
('Network Security', 4);

-- Insert Student
INSERT INTO Student (user_ssn, track_id)
VALUES 
(2, 1),
(4, 2),
(1, 3),
(3, 4);

-- Insert Courses
INSERT INTO Course (course_name, course_duration)
VALUES 
('Database Systems', 40),
('Web Development', 60),
('Machine Learning', 50),
('Cybersecurity Essentials', 30),
('Parall programming', 40);
-- Insert Instructor_Course
INSERT INTO Instructor_Course (instructor_id, course_id)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(1,8);

-- Insert Student_Course
INSERT INTO Student_Course (student_id, course_id, student_course_grade)
VALUES 
(1, 1, 85),
(2, 2, 90),
(3, 3, 88),
(4, 4, 92);

-- Insert Topics
INSERT INTO Topic (course_id, topic_name)
VALUES 
(1, 'Normalization in Databases'),
(2, 'Frontend vs Backend Development'),
(3, 'Supervised vs Unsupervised Learning'),
(4, 'Cyber Attack Prevention');

-- Insert Exam
INSERT INTO Exam (exam_start_time, exam_start_date, exam_duration, exam_total_point, course_id)
VALUES 
('10:00:00', '2025-06-01', 1.5, 100, 1),
('14:00:00', '2025-06-02', 2.0, 100, 2),
('09:30:00', '2025-06-03', 1.8, 100, 3),
('16:00:00', '2025-06-04', 2.5, 100, 4);

-- Insert Questions
INSERT INTO Question (question_head, question_body, question_answer, question_points, course_id)
VALUES 
('What is SQL?', 'Explain the basic concept of SQL.', 'Structured Query Language', 10, 1),
('What is Normalization?', 'Describe the different types of normalization.', 'Process to reduce redundancy', 10, 1),
('What is a Web API?', 'Explain the purpose of a web API.', 'Interface for communication', 10, 2),
('Define Overfitting.', 'What does overfitting mean in machine learning?', 'High accuracy on training data but poor on new data', 10, 3);

-- Insert Question_Option
INSERT INTO Question_Option (question_id, question_option)
VALUES 
(1, 'Structured Query Language'),
(1, 'Sequential Query Logic'),
(1, 'Simple Query Language'),
(2, 'Process to reduce redundancy'),
(2, 'A type of SQL command'),
(3, 'An API for web services'),
(3, 'A web programming language'),
(4, 'Good generalization'),
(4, 'Poor generalization');

-- Insert Student_Answer
INSERT INTO Student_Answer (student_id, exam_id, question_id, AnswersStudent, student_que_grade)
VALUES 
(1, 1, 1, 'Structured Query Language', 10),
(2, 2, 2, 'Process to reduce redundancy', 9),
(3, 3, 3, 'An API for web services', 8),
(4, 4, 4, 'Poor generalization', 7);
