-- DDL Statements for CodeJudge Relational Schema

-- 1. Academic Core
CREATE TABLE batches (
    batch_id INTEGER PRIMARY KEY,
    batch_code VARCHAR(50) UNIQUE NOT NULL,
    program VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    batch_status VARCHAR(20) CHECK (batch_status IN ('Active', 'Completed', 'Upcoming'))
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY,
    course_code VARCHAR(50) UNIQUE NOT NULL,
    course_title VARCHAR(200) NOT NULL,
    course_status VARCHAR(20) DEFAULT 'Active',
    credit_hours INTEGER CHECK (credit_hours > 0)
);

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    roll_number VARCHAR(50) UNIQUE NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    batch_id INTEGER,
    admission_date DATE,
    enrollment_status VARCHAR(20) DEFAULT 'Enrolled',
    graduation_year INTEGER,
    FOREIGN KEY (batch_id) REFERENCES batches(batch_id)
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrolled_on DATE,
    enrollment_status VARCHAR(20),
    final_grade VARCHAR(5),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    UNIQUE (student_id, course_id)
);

-- 2. Evaluation Engine
CREATE TABLE problems (
    problem_id INTEGER PRIMARY KEY,
    course_id INTEGER NOT NULL,
    problem_code VARCHAR(50) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    difficulty VARCHAR(20) CHECK (difficulty IN ('Easy', 'Medium', 'Hard')),
    max_score INTEGER NOT NULL CHECK (max_score > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE test_cases (
    test_case_id INTEGER PRIMARY KEY,
    problem_id INTEGER NOT NULL,
    case_no INTEGER NOT NULL,
    input_label TEXT,
    expected_output_label TEXT,
    points INTEGER NOT NULL CHECK (points >= 0),
    is_hidden BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id),
    UNIQUE (problem_id, case_no)
);

CREATE TABLE contests (
    contest_id INTEGER PRIMARY KEY,
    course_id INTEGER NOT NULL,
    contest_title VARCHAR(200) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    contest_status VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE contest_problems (
    contest_id INTEGER NOT NULL,
    problem_id INTEGER NOT NULL,
    problem_order INTEGER,
    PRIMARY KEY (contest_id, problem_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id),
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id)
);

CREATE TABLE submissions (
    submission_id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    problem_id INTEGER NOT NULL,
    contest_id INTEGER,
    language VARCHAR(50) NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    score INTEGER DEFAULT 0,
    runtime_ms INTEGER,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (problem_id) REFERENCES problems(problem_id),
    FOREIGN KEY (contest_id) REFERENCES contests(contest_id)
);

CREATE TABLE test_results (
    result_id INTEGER PRIMARY KEY,
    submission_id INTEGER NOT NULL,
    test_case_id INTEGER NOT NULL,
    result_status VARCHAR(50),
    runtime_ms INTEGER,
    memory_kb INTEGER,
    awarded_points INTEGER DEFAULT 0,
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id),
    FOREIGN KEY (test_case_id) REFERENCES test_cases(test_case_id),
    UNIQUE (submission_id, test_case_id)
);

-- 3. Operations & Logs
CREATE TABLE sessions (
    session_id INTEGER PRIMARY KEY,
    course_id INTEGER NOT NULL,
    session_title VARCHAR(200),
    session_date DATE NOT NULL,
    session_type VARCHAR(50),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY,
    session_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    attendance_status VARCHAR(20) CHECK (attendance_status IN ('Present', 'Absent', 'Late')),
    marked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (session_id) REFERENCES sessions(session_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    UNIQUE (session_id, student_id)
);

CREATE TABLE regrade_requests (
    request_id INTEGER PRIMARY KEY,
    submission_id INTEGER NOT NULL,
    student_id INTEGER NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT NOT NULL,
    request_status VARCHAR(20) DEFAULT 'Pending',
    resolved_at TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE plagiarism_flags (
    flag_id INTEGER PRIMARY KEY,
    submission_id INTEGER NOT NULL,
    matched_submission_id INTEGER NOT NULL,
    similarity_score DECIMAL(5,2) CHECK (similarity_score BETWEEN 0 AND 100),
    flag_status VARCHAR(20) DEFAULT 'Under Review',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (submission_id) REFERENCES submissions(submission_id),
    FOREIGN KEY (matched_submission_id) REFERENCES submissions(submission_id)
);
