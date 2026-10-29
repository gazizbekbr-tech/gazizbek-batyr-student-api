# gazizbek-batyr-student-api

Spring Boot CRUD REST API for students. DevOps midterm project of **Batyr Gazizbek**.

Project status: full CRUD (create, read, update, delete) is implemented and documented with curl examples by Batyr Gazizbek.

| Item            | Value                            |
|-----------------|----------------------------------|
| Student         | Batyr Gazizbek                   |
| Group           | IT2-2301                         |
| Student ID      | 38091                            |
| Repository      | gazizbek-batyr-student-api       |
| Base API path   | `/api/gazizbek-batyr/students`   |
| Application port| 8091                             |

Midterm evidence: [docs/REPORT.md](docs/REPORT.md) - defense notes: [docs/DEFENSE_QA.md](docs/DEFENSE_QA.md)

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
├── jenkins/      Local Jenkins: controller (JCasC) + Docker build agent
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

## curl examples

```bash
BASE=http://localhost:8091/api/gazizbek-batyr/students

# create
curl -i -X POST $BASE -H 'Content-Type: application/json' \
  -d '{"firstName":"Batyr","lastName":"Gazizbek","email":"batyr.g@student.kz","groupName":"IT2-2301","course":3}'
# read all / read one
curl -s $BASE
curl -s $BASE/1
# update
curl -i -X PUT $BASE/1 -H 'Content-Type: application/json' \
  -d '{"firstName":"Batyr","lastName":"Gazizbek","email":"batyr.g@student.kz","groupName":"IT2-2301","course":4}'
# delete
curl -i -X DELETE $BASE/1
```

## Build and test

```bash
./gradlew clean test bootJar
```

## System report script

```bash
./scripts/Gazizbek_Batyr_system_report.sh
```

The report is printed to the terminal and appended to `logs/Gazizbek_Batyr_system_report.log`.

## Docker

```bash
# multi-stage build: JDK + Gradle in the build stage, JRE only in the runtime stage
docker build --build-arg APP_VERSION=1.1.0 -t gazizbek-batyr-student-api:v1.1-gazizbek-batyr .
```

## Docker Compose (application + PostgreSQL)

```bash
cp .env.example .env          # then set your own POSTGRES_PASSWORD
docker compose up -d --build
docker compose ps
```

- Compose project: `gazizbek-batyr-student-api`
- Services: `gazizbek-batyr-app` (port 8091) and `gazizbek-batyr-db` (PostgreSQL 17 with `pg_isready` health check)
- Named volume `gazizbek-batyr-pgdata` keeps the database between restarts, network `gazizbek-batyr-net`
- The application connects to `jdbc:postgresql://gazizbek-batyr-db:5432/...` - the service name,
  because inside a container `localhost` is the container itself.

## Jenkins CI

```bash
./jenkins/start-jenkins.sh    # controller on http://localhost:8080 + Docker build agent
```

- Job `Gazizbek_Batyr_Student_API` (multibranch pipeline, builds `main` and `test/*` branches)
- Stages: Checkout -> Build -> Test -> Docker Build -> Verify (`Jenkinsfile`)
- Trigger: `pollSCM('* * * * *')`, Jenkins checks GitHub every minute and starts a build for a new commit.
  A GitHub webhook would need a public Jenkins URL; this Jenkins runs on localhost, so polling is used.
- The smoke-test database password is stored in Jenkins Credentials (`gazizbek-batyr-verify-db-password`).

**CI vs CD.** Continuous Integration: every commit is automatically built and tested (here: compile,
tests, Docker image, smoke test), so problems are found right after the change. Continuous Delivery
keeps every successful build ready to release, but a person presses the button; Continuous Deployment
goes one step further and releases every successful build to production automatically. This project
implements CI only.

## Secrets

`.env` files, passwords and database credentials are never committed (see `.gitignore`).
Git keeps every version forever, so a pushed password stays in the history and in every clone,
and a public repository is scanned by bots within minutes. Use `.env.example` with placeholders,
environment variables and Jenkins Credentials instead.
