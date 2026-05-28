# Schema Understanding & Entity Identification

This document outlines the purpose, structure, and entities of the CodeJudge database, bridging the raw platform exports into a relational design.

## 1. The Academic Core
* **`batches`**: Represents academic cohorts. 
    * **Identifiers**: `batch_id` (Primary Key). `batch_code` is a candidate key.
    * **Connections**: Parent table to `students`.
* **`courses`**: The catalog of offered subjects.
    * **Identifiers**: `course_id` (Primary Key). `course_code` uniquely identifies a course academically.
* **`students`**: The master data for individuals using the platform.
    * **Identifiers**: `student_id` (Primary Key). `roll_number` and `email` uniquely identify the student in the real world.
    * **Connections**: Links to `batches` via `batch_id` (Foreign Key).
* **`enrollments`**: Maps which students are taking which courses (M:N relationship resolver).
    * **Identifiers**: `enrollment_id` is the raw identifier. The combination of `student_id` + `course_id` acts as a composite key ensuring a student doesn't enroll in the same course twice.

## 2. The Evaluation Engine
* **`problems`**: The programming questions assigned to courses.
    * **Identifiers**: `problem_id` (Primary Key). `problem_code` is a unique readable identifier.
    * **Connections**: Belongs to `courses` via `course_id`.
* **`test_cases`**: The execution scenarios for problems.
    * **Connections**: Belongs to `problems` via `problem_id`. `problem_id` + `case_no` forms a logical composite key.
* **`contests`**: Time-bound evaluations linked to a specific course.
    * **Identifiers**: `contest_id` (Primary Key).
* **`contest_problems`**: A mapping table resolving the many-to-many relationship between contests and problems.
    * **Identifiers**: Composite key of `contest_id` + `problem_id`.
* **`submissions`**: Student code execution attempts.
    * **Connections**: Links to `student_id`, `problem_id`, and optionally `contest_id`.
* **`test_results`**: The micro-level results of a submission running against specific test cases.
    * **Identifiers**: Composite of `submission_id` + `test_case_id` ensures a test case is only recorded once per submission attempt.

## 3. Operations & Auditing
* **`sessions` & `attendance`**: Tracks live events. `sessions` belongs to `courses`, and `attendance` maps `sessions` to `students` (M:N).
* **`regrade_requests` & `plagiarism_flags`**: Audit tables linked back to `submissions`. `plagiarism_flags` uses a self-referencing relationship (submission matched against another submission).
* **`raw_student_import`**: A denormalized staging table. Data is repeated here (e.g., `batch_code` instead of an ID), requiring ETL to move into the normalized `students` table.
