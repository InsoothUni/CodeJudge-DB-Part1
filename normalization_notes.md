# Normalization Reasoning

The target design for the CodeJudge database aligns with the **Third Normal Form (3NF)**, ensuring that every non-key attribute is mutually independent and fully dependent on the primary key.

## Examples of Repeated or Redundant Data in Raw Format
1.  **Staging Imports:** In `raw_student_import`, the `batch_code` is repeated for every student. If a batch name needs to change, it would require updating multiple rows, causing update anomalies.
2.  **Test Results vs. Submissions:** If submission `status` and total `score` were tracked at the `test_results` level instead of the `submissions` level, the same total score would be redundantly stored across every single test case execution for that submission.
3.  **Contest Problems:** Without a mapping table, storing contest details directly inside the `problems` table would mean a problem could only ever belong to one contest, or contest details would have to be duplicated if the problem was reused.

## How Separating Data Improves Design
1.  **`enrollments` Table:** By separating student and course data and linking them via `enrollments`, we avoid a massive, unscalable denormalized table where course details are duplicated for every student taking them.
2.  **`contest_problems` Table:** This resolves the Many-to-Many (M:N) relationship between contests and problems, allowing one contest to have many problems, and one problem to appear in multiple contests without data duplication.

## Examples of Functional Dependency
1.  **Full Dependency:** In `courses`, the `course_title` and `credit_hours` are fully functionally dependent on the `course_id`.
2.  **Transitive Dependency Prevention:** If `students` contained a column for `batch_start_date`, that date would be functionally dependent on `batch_id`, not `student_id`. Moving `start_date` to the `batches` table removes this transitive dependency, satisfying 3NF.

## Trade-Offs Made
To achieve 3NF, the database relies heavily on joins (e.g., getting a student's contest scores requires joining `students` -> `submissions` -> `contests`). This prioritizes data integrity and write-speed over read-speed. If reporting becomes too slow, materialized views might be required later.
