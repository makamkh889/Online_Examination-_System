create database ITI_Examination_System
go
use ITI_Examination_System

--------------------- user table-----------------------------------------
create table Users (
    user_ssn int primary key identity(1,1),  
    user_name varchar(100) not null,
    password varchar(255) not null,
    user_type varchar(20) not null CHECK (user_type IN ('student', 'instructor', 'Employee')),
    email varchar(100) unique not null,
	phone varchar(20),
	user_dob date,--date of birth ,
	user_Address varchar(100),
    gender varchar(10) CHECK (gender IN ('male', 'female', 'other'))
);

---------------------- Branch table-------------------------------
create table Branch (
    branch_id int primary key identity(1,1),
	branch_name nvarchar(50),
	branch_phone nvarchar(50),
	branch_city nvarchar(50),
);
------------------------------- instructor table------------------------------------
create table Instructor (
    instructor_id int primary key identity(1,1),
    instructor_salary decimal(10,2),
    instructor_degree varchar(50),
    department_id int,
	user_ssn INT UNIQUE,
    FOREIGN KEY (user_ssn) REFERENCES users(user_ssn) ON DELETE CASCADE,
);

---------------------- Department table-------------------------------
create table Department (
    department_id int primary key identity(1,1),
	department_name nvarchar(50),
	branch_id INT UNIQUE,
    FOREIGN KEY (branch_id) REFERENCES Branch(branch_id) ON DELETE CASCADE,
	manager_id INT UNIQUE,
    FOREIGN KEY (manager_id) REFERENCES Instructor(instructor_id) ON DELETE CASCADE
);

---------------------- Track table-------------------------------
create table Track (
    track_id int primary key identity(1,1),
	track_name nvarchar(50),
	department_id INT UNIQUE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE CASCADE
);

---------------------- student table-------------------------------
create table Student (
    student_id int primary key identity(1,1),

	user_ssn INT UNIQUE,
    FOREIGN KEY (user_ssn) REFERENCES users(user_ssn) ON DELETE CASCADE,
	track_id INT UNIQUE,
    FOREIGN KEY (track_id) REFERENCES Track(track_id) ON DELETE NO ACTION
);

----------------------------- course table---------------------------------------
create table Course (
    course_id int primary key identity(1,1),  
    course_name varchar(100) not null,
    course_duration bigint
);

insert into Course (course_name, course_duration) 
values 
('Database Systems', 40),
('Web Development', 60),
('Machine Learning', 50);

------------------ instructor_course table -------------------------------------
create table Instructor_Course (
    instructor_id int,
    course_id int,
    primary key (instructor_id, course_id),
    foreign key (instructor_id) references Instructor(instructor_id) on delete cascade,
    foreign key (course_id) references Course(course_id) on delete cascade
);

------------------- student_course table ----------------------------
create table Student_Course (
    student_id int,
    course_id int,
    student_course_grade int,
    primary key (student_id, course_id),
    foreign key (student_id) references Student(student_id) on delete cascade,
    foreign key (course_id) references Course(course_id) on delete cascade
);


--------------------- topic table--------------------------
create table Topic (
    topic_id int primary key identity(1,1),
    course_id int,
    topic_name varchar(255) not null,
    foreign key (course_id) references Course(course_id) on delete cascade
);

--------------------------------- exam table-------------------------------------
create table Exam (
    exam_id int primary key identity(1,1),
    exam_start_time time,
    exam_start_date date,
    exam_duration float,
    exam_total_point int,
    course_id int,
    foreign key (course_id) references Course(course_id) on delete cascade
);
insert into exam (exam_start_time, exam_start_date, exam_duration, exam_total_point, course_id) 
values 
('10:00:00', '2025-06-01', 1.5, 100, 1),
('14:00:00', '2025-06-02', 2.0, 100, 2);

-------------------------------- question table------------------------------------
create table Question (
    question_id int primary key identity(1,1),
    question_head varchar(255) not null,
    question_body text,
    question_answer varchar(255) not null,
    question_points int,
    course_id int,
    foreign key (course_id) references Course(course_id) on delete cascade
);
insert into Question (question_head, question_body, question_answer, question_points, course_id) 
values 
('What is SQL?', 'Explain the basic concept of SQL.', 'Structured Query Language', 10, 1),
('What is Normalization?', 'Describe the different types of normalization.', 'Process to reduce redundancy', 10, 1);


-------------------------Question_Exam table-----------------
create table Question_Exam(
question_id int,
foreign key (question_id) references Question (question_id), 
Exam_id int,
foreign key (exam_id) references Exam (exam_id)
);
------------------------ question_option table-------------------------------------
create table Question_Option (
    question_id int,
    question_option varchar(255),
    primary key (question_id, question_option),
    foreign key (question_id) references Question(question_id) on delete cascade
);
insert into Question_Option (question_id, question_option) 
values 
(1, 'Structured Query Language'),
(1, 'Sequential Query Logic'),
(1, 'Simple Query Language'),
(2, 'Process to reduce redundancy'),
(2, 'A type of SQL command');

--------------------- student_answer table------------------------
create table Student_Answer (
    student_id int,
    exam_id int,
    question_id int,
    AnswersStudent varchar(255),
    student_que_grade int,
    primary key (student_id, exam_id, question_id),
    foreign key (student_id) references Student(student_id) on delete NO ACTION,
    foreign key (exam_id) references Exam(exam_id) on delete NO ACTION,
    foreign key (question_id) references Question(question_id) on delete NO ACTION
);
----- TO MAKE IT Dafult 0------
ALTER TABLE Student_Answer
ADD CONSTRAINT DF_Student_Answer_Grade DEFAULT 0 FOR student_que_grade;



