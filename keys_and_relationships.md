# Keys and Constraints Reasoning

To enforce data integrity from a DBMS perspective, the following keys and constraints are applied to the CodeJudge schema:

## Primary & Candidate Keys
* **Primary Keys (PK):** Surrogate keys like `student_id`, `course_id`, and `submission_id` are used as primary keys. They provide a stable, indexed, and immutable integer reference for foreign keys, shielding the database from cascading updates if a real-world identifier changes.
* **Candidate/Alternate Keys (AK):** Columns like `roll_number` and `email` in the `students` table, or `course_code` in `courses`. These must be `UNIQUE` to prevent real-world duplication (e.g., two students cannot share an email), even though they are not used as the primary indexing key.

## Foreign Keys (FK)
* Foreign keys establish referential integrity. For example, `student_id` in `submissions` references `students(student_id)`. This ensures that a submission cannot exist for a non-existent student, preventing orphaned records.

## Composite Keys
* **`enrollments (student_id, course_id)`**: Used as a unique constraint to ensure a student cannot be enrolled in the exact same course multiple times simultaneously.
* **`contest_problems (contest_id, problem_id)`**: Acts as the primary key for the mapping table, ensuring a specific problem is only added to a specific contest once.

## Constraints
* **`NOT NULL`**: Applied to critical fields where absence of data makes the record invalid from a business logic standpoint (e.g., `full_name` or `email` in `students`; `problem_code` in `problems`).
* **`UNIQUE`**: Enforces business rules on candidate keys (e.g., `batch_code` must be unique).
* **`CHECK`**: Restricts the domain of possible values. For example, `enrollment_status` might have a CHECK constraint ensuring it only accepts 'Active', 'Completed', or 'Dropped', preventing garbage data from entering the system.
