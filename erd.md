# Entity Relationship Diagram (ERD)

```mermaid
erDiagram
    BATCHES ||--o{ STUDENTS : "contains"
    COURSES ||--o{ ENROLLMENTS : "has"
    STUDENTS ||--o{ ENROLLMENTS : "makes"
    
    COURSES ||--o{ PROBLEMS : "contains"
    COURSES ||--o{ CONTESTS : "hosts"
    COURSES ||--o{ SESSIONS : "schedules"
    
    PROBLEMS ||--o{ TEST_CASES : "evaluated by"
    PROBLEMS ||--o{ CONTEST_PROBLEMS : "included in"
    CONTESTS ||--o{ CONTEST_PROBLEMS : "features"
    
    STUDENTS ||--o{ SUBMISSIONS : "submits"
    PROBLEMS ||--o{ SUBMISSIONS : "receives"
    CONTESTS ||--o{ SUBMISSIONS : "tracks"
    
    SUBMISSIONS ||--o{ TEST_RESULTS : "generates"
    TEST_CASES ||--o{ TEST_RESULTS : "yields"
    
    SESSIONS ||--o{ ATTENDANCE : "records"
    STUDENTS ||--o{ ATTENDANCE : "marks"
    
    SUBMISSIONS ||--o{ REGRADE_REQUESTS : "subject to"
    STUDENTS ||--o{ REGRADE_REQUESTS : "raises"
    
    SUBMISSIONS ||--o{ PLAGIARISM_FLAGS : "flagged as"
    SUBMISSIONS ||--o{ PLAGIARISM_FLAGS : "matched against"
