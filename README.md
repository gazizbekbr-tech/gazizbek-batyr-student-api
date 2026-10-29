# gazizbek-batyr-student-api

Spring Boot CRUD REST API for students. DevOps midterm project of **Batyr Gazizbek**.

Project status: initial version with create, read and delete operations.

| Item            | Value                            |
|-----------------|----------------------------------|
| Student         | Batyr Gazizbek                   |
| Group           | IT2-2301                         |
| Student ID      | 38091                            |
| Repository      | gazizbek-batyr-student-api       |
| Base API path   | `/api/gazizbek-batyr/students`   |
| Application port| 8091                             |

## Tech stack

- Java 21, Spring Boot 4 (Web MVC, Data JPA, Validation, Actuator)
- Gradle (wrapper included: `./gradlew`)
- PostgreSQL in production, H2 in-memory database for automated tests

## Project structure

```
gazizbek-batyr-student-api/
├── scripts/      Bash scripts (system report)
├── logs/         Script output logs (not committed)
├── backups/      File backups
├── src/          Spring Boot application and tests
├── Dockerfile
├── docker-compose.yml
├── Jenkinsfile
├── build.gradle
└── README.md
```

## API

| Method | URL                                   | Description           |
|--------|---------------------------------------|-----------------------|
| GET    | `/`                                   | Student / version info|
| GET    | `/api/gazizbek-batyr/students`        | List all students     |
| GET    | `/api/gazizbek-batyr/students/{id}`   | Get one student       |
| POST   | `/api/gazizbek-batyr/students`        | Create a student      |
| PUT    | `/api/gazizbek-batyr/students/{id}`   | Update a student      |
| DELETE | `/api/gazizbek-batyr/students/{id}`   | Delete a student      |

A missing student returns `404 Not Found` with a JSON error body.

## Change log

### Student update operation (feature/gazizbek-batyr-crud, author: Batyr Gazizbek)

- Added `PUT /api/gazizbek-batyr/students/{id}` which replaces first name, last name,
  email, group and course of an existing student.
- The request body is validated (`@Valid`): empty names, invalid emails or a course
  outside 1-4 return `400 Bad Request`.
- Updating a student that does not exist returns `404 Not Found`; changing the email
  to one that already belongs to another student returns `409 Conflict`.
- Covered by `updatesStudent` and `updateOfMissingStudentReturns404` tests.

## Build and test

```bash
./gradlew clean test bootJar
```

## System report script

```bash
./scripts/Gazizbek_Batyr_system_report.sh
```

The report is printed to the terminal and appended to `logs/Gazizbek_Batyr_system_report.log`.
