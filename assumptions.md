Database Design Assumptions

During the transition from the raw data dictionary to the normalized relational schema, the following logical assumptions were made:

1.  **Staging Tables Not Explicitly Modeled in Core DDL:** Tables like `raw_student_import` and `operation_requests` are treated as temporary staging/administrative tracking tables. They are excluded from the core normalized DDL to maintain strict referential integrity.
2.  **Unique Identifiers:** It is assumed that `email` and `roll_number` in the `students` table are strictly unique per individual across the entire institution. 
3.  **Submission Context:** A submission can exist outside of a contest (e.g., standard practice). Therefore, `contest_id` in the `submissions` table is nullable.
4.  **Composite Constraints:** It is assumed a student can only be marked present/absent for a single session once, justifying the `UNIQUE (session_id, student_id)` constraint in the `attendance` table. Similarly, a student can only have one active/completed enrollment record per course at a time.
5.  **Data Types:** Standard ANSI SQL data types (`VARCHAR`, `INTEGER`, `TIMESTAMP`, `BOOLEAN`) were chosen. Depending on the final RDBMS used (MySQL, PostgreSQL, SQLite), these might be auto-translated by the engine (e.g., SQLite storing BOOLEAN as integer 0/1).
