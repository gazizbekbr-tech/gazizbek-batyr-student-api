# Defense questions - short answers (Batyr Gazizbek)

Examples refer to this project where possible.

## Linux

**What is Linux, and why is it used in DevOps?** An open-source Unix-like OS. Most servers, containers
(Docker images are Linux), CI agents and clouds run it; it is scriptable, stable and free.

**Purpose of `pwd`?** Prints the current (working) directory.

**Absolute vs relative path?** Absolute starts at `/` (`/home/batyr/projects/app`), relative starts from the
current directory (`scripts/run.sh`, `../logs`).

**`mkdir` vs `mkdir -p`?** `-p` creates missing parent directories and does not fail if the directory exists.

**Create an empty file?** `touch file.log` (or `> file.log`).

**`cp` vs `mv`?** `cp` copies (original stays), `mv` moves or renames (original disappears).

**List hidden files?** `ls -a` / `ls -la` (hidden files start with a dot, e.g. `.gitignore`).

**Search for a word in a file?** `grep -n 'Gazizbek' file.log` (`-i` ignore case, `-c` count, `-r` recursive).

**Search a log for your surname and save the result?**
`grep -n 'Gazizbek' logs/Gazizbek_Batyr_system_report.log > logs/Gazizbek_Batyr_log_analysis.txt`

**Last five lines of a log?** `tail -n 5 file.log` (`tail -f` follows new lines).

**`>` vs `>>`?** `>` overwrites the file, `>>` appends to it.

**Check available disk space?** `df -h` (per filesystem), `du -sh dir` (size of a directory).

**What does `free -h` show?** Total, used, free, shared, buff/cache and available RAM, plus swap, in human units.

**What is a process, how to list them?** A running program with its own PID, memory and state.
`ps aux`, `top`/`htop`, `pgrep -a java`.

**Find and terminate a process by PID?** `ps aux | grep java` or `pgrep java` to get the PID, then
`kill PID` (SIGTERM, graceful), `kill -9 PID` (SIGKILL) only if it does not stop.

**Purpose of the shebang `#!/bin/bash`?** First line that tells the kernel which interpreter runs the script
when it is started as `./script.sh`.

**Make a Bash script executable?** `chmod +x script.sh` (or `chmod 744`/`755`), then `./script.sh`.

**What does `chmod` do?** Changes permission bits (read/write/execute) for owner, group and others.

**Meaning of 755?** owner `rwx` (7), group `r-x` (5), others `r-x` (5). My script uses 744: owner `rwx`,
group and others read only.

**Pass arguments to a Bash script?** `./script.sh a b` -> `$1`, `$2`; `$@` all, `$#` count, `$0` script name.
My report script takes an optional log path as `$1`.

## Git and GitHub

**Git vs GitHub?** Git is the version-control tool on your machine; GitHub is a hosting service for Git
repositories with web UI, pull requests, issues, Actions.

**`git init`?** Creates a new repository (`.git` folder) in the current directory.

**Working directory vs staging area vs repository?** Working directory = files you edit; staging area (index) =
changes selected with `git add` for the next commit; repository = committed snapshots in `.git`.

**`git status`?** Current branch, staged changes, unstaged changes, untracked files, ahead/behind remote.

**`git add`?** Moves changes into the staging area.

**`git commit`?** Saves the staged snapshot to history with author, date, message and a hash.

**Why meaningful commit messages?** History explains *what* and *why*; easier review, debugging (`git log`,
`git bisect`), reverting and release notes.

**What is a branch, why use them?** A movable pointer to a line of commits. Work on features/fixes in
isolation without breaking `main`, then merge (e.g. `feature/gazizbek-batyr-crud`).

**Create and switch to a branch?** `git switch -c feature/x` (or `git checkout -b feature/x`).

**What is a merge conflict, why?** Two branches changed the same lines (or one deleted a file the other
changed) and Git cannot decide automatically. In my project both branches changed the `Project status:` line.

**Resolve a conflict in README.md?** Open the file, choose/combine the text between `<<<<<<<`, `=======`,
`>>>>>>>`, remove the markers, `git add README.md`, `git commit`.

**`git merge` vs `git rebase`?** Merge joins histories with a merge commit (history kept as it happened);
rebase replays your commits on top of another branch (linear history, rewrites commit hashes - do not rebase
shared branches).

**`git fetch` vs `git pull`?** `fetch` downloads remote commits without changing your branch; `pull` = fetch + merge (or rebase).

**`git push`?** Uploads local commits/branches/tags to the remote.

**Git tag, project version?** A named pointer to a specific commit, e.g. `v1.0-gazizbek-batyr`; used to mark
releases (`git tag -a v1.0 -m ...`, `git push origin v1.0`).

**Commit vs tag?** A commit is a snapshot; a tag is a fixed label on a commit (branches move, tags do not).

**Purpose of `.gitignore`?** Lists files Git must not track: build output, logs, IDE files, `.env`/secrets.

**Why not commit passwords and `.env`?** History is permanent and copied to every clone; public repos are
scanned by bots; secrets differ per environment. Use `.env.example`, env variables, Jenkins Credentials.

**Local code differs from GitHub - how to sync safely?** `git status`, `git fetch`, compare with
`git log --oneline HEAD..origin/main` and `origin/main..HEAD`, `git diff origin/main`; commit or `git stash`
local work, then `git pull --rebase` (or merge), resolve conflicts, run tests, `git push`. Never `push --force` on shared branches.

## Docker

**What is Docker, why useful?** A platform to package an app with its runtime and dependencies into an image
and run it as an isolated container: same environment on every machine and in CI, fast start, easy rollback.

**Image vs container?** Image = read-only template (layers). Container = a running (or stopped) instance of an image with its own writable layer.

**`docker build`?** Builds an image from a Dockerfile and context: `docker build -t gazizbek-batyr-student-api:v1.0-gazizbek-batyr .`

**`FROM`?** Sets the base image of a stage (`FROM eclipse-temurin:21-jre`); every Dockerfile starts with it.

**`WORKDIR`?** Sets (and creates) the working directory for following instructions and for the container.

**`RUN` vs `CMD`?** `RUN` executes at build time and creates a layer (`RUN ./gradlew bootJar`); `CMD` is the
default command at container start and can be overridden by `docker run ... <cmd>` (I use `ENTRYPOINT`).

**`COPY` vs `ADD`?** Both copy files into the image; `ADD` can also download URLs and auto-extract tar archives. Prefer `COPY`.

**`EXPOSE`?** Documents the port the app listens on (8091); publishing still needs `-p`/`ports:`.

**Multi-stage build, advantage?** Several `FROM` stages; build tools (JDK, Gradle) stay in the build stage and
only the jar is copied into a small JRE image -> smaller, safer image.

**Run a container mapping 8080 to 8080?** `docker run -d -p 8080:8080 image` (host:container). Mine: `-p 8091:8091`.

**Execute a command in a running container?** `docker exec -it gazizbek-batyr-app sh` or `docker exec gazizbek-batyr-app java -version`.

**View logs?** `docker logs gazizbek-batyr-app` (`-f` follow, `--tail 20`); `docker compose logs`.

**`docker stop` vs `docker rm`?** `stop` gracefully stops the container (it still exists, can be started);
`rm` deletes a stopped container (`rm -f` stops and deletes).

**What is Docker Compose, why here?** Describes multi-container apps in one YAML: app + PostgreSQL with env,
volume, network, health check; one command `docker compose up -d`.

**Purpose of `docker-compose.yml`?** Declarative definition of services, networks, volumes and their configuration.

**Docker volume, why for PostgreSQL?** Storage managed by Docker outside the container's writable layer; the
database survives `docker compose down` and container re-creation.

**Network vs volume?** Network connects containers (DNS by service name); volume stores data persistently.

**Health check, how it helps with PostgreSQL?** A command Docker runs periodically (`pg_isready`); the
container becomes `healthy` only when the DB accepts connections, so the app starts with
`depends_on: condition: service_healthy`.

**Why the service name and not localhost?** Inside the app container `localhost` is the app container itself.
Compose puts both on one network where Docker DNS resolves the service name `gazizbek-batyr-db` to the DB container.

**How to pass DB credentials to a Spring Boot container?** Environment variables
(`SPRING_DATASOURCE_URL/USERNAME/PASSWORD`) from a non-committed `.env`, Docker/Kubernetes secrets, or CI
credentials - never hard-coded in the image or the repo.

**Spring Boot container cannot connect to PostgreSQL - troubleshooting?** `docker compose ps` (DB healthy?),
`docker logs` of both, check `SPRING_DATASOURCE_URL` host = service name and port 5432, same network
(`docker network inspect`), `docker exec app getent hosts gazizbek-batyr-db`, correct user/password/db name,
DB ready before app (health check), `psql` inside the DB container.

## Jenkins / CI

**What is CI?** Developers integrate changes often; each commit is automatically built and tested.

**CI vs Continuous Deployment / Delivery vs Deployment?** Delivery: every passing build is releasable, a person
approves the release. Deployment: every passing build is released to production automatically.

**Why run tests before deploying?** To catch bugs before users see them; a failing test stops the pipeline so
broken code is never packaged or deployed.

**What is a Jenkinsfile?** Pipeline-as-code file in the repo describing stages and steps; versioned with the code.

**What is a Jenkins job?** A configured task in Jenkins (source, trigger, pipeline) that produces builds; mine
is `Gazizbek_Batyr_Student_API` (multibranch).

**Declarative vs Scripted pipeline?** Declarative: structured `pipeline { agent; stages; post }`, easier,
validated. Scripted: free Groovy `node { ... }`, more flexible, harder to read.

**Checkout stage?** Gets the source of the exact commit from GitHub into the workspace (`checkout scm`).

**Build stage?** Compiles the application (`./gradlew clean compileJava`) - proves the code compiles.

**Test stage?** Runs automated tests (`./gradlew test`) and publishes JUnit results.

**Stop the pipeline when tests fail?** Run tests in an `sh` step: a non-zero exit code fails the stage and
later stages are skipped (shown in Task 4.3). Do not wrap it in `catchError`/`|| true`.

**What happens when a stage fails?** The build is marked FAILURE, remaining stages are skipped, `post { failure/always }` blocks run.

**Controller vs agent?** Controller = UI, configuration, scheduling; agent = machine/container that executes
builds. My controller has 0 executors, builds run on `gazizbek-batyr-docker-agent`.

**Why a Docker-capable agent?** `docker build` needs the Docker CLI and access to a Docker engine (socket) on
the machine where the step runs.

**Jenkins Credentials, why?** Encrypted store for passwords, tokens, SSH keys; injected with
`withCredentials`, masked as `****` in logs, never stored in the repo.

**Private GitHub repo checkout?** Add a GitHub personal access token (Username with password) or an SSH key
(deploy key) in Jenkins Credentials and select it in the job's Git source.

**Build trigger, webhook?** What starts a build: manual, `pollSCM` (Jenkins asks Git periodically), cron,
webhook (GitHub sends an HTTP POST to `JENKINS_URL/github-webhook/` on push, needs a reachable Jenkins).
I use `pollSCM('* * * * *')` because Jenkins runs on localhost.

**Console output information?** Who/what started the build, checked-out commit, every command and its output,
test results, errors with exit codes, final status (SUCCESS/FAILURE).

**Investigate a failed Gradle build in Jenkins?** Read the console from the first error, check the test report,
reproduce locally with the same command (`./gradlew clean test --stacktrace`), check JDK version and dependencies on the agent.

**Pipeline compiles but fails at Docker image creation?** Read the Docker Build stage log: Docker CLI present
(`docker version`), access to the socket (permissions/group), daemon running, Dockerfile path and context,
`.dockerignore` not excluding needed files, base image pull/network, disk space. Reproduce with the same
`docker build` on the agent.
