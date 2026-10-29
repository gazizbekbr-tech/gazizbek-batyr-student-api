#!/bin/bash
# Part 2 / Task 2.1 - repository initialization (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
cd "$(dirname "$0")/../gazizbek-batyr-student-api" || exit 1

section "Task 2.1 Repository initialization - Batyr Gazizbek"
run "git init -b main"
run 'git config user.name "Batyr Gazizbek"'
run 'git config user.email "343244434+gazizbekbr-tech@users.noreply.github.com"'
run "git config --get user.name; git config --get user.email"
run "touch logs/.gitkeep"
run "cat > .gitignore <<'GI'
# Gradle and build output
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar

# IDE and OS files
.idea/
*.iml
.vscode/
out/
.DS_Store

# Logs and reports generated at runtime
logs/*.log
logs/*.txt
!logs/.gitkeep

# Secrets: environment files, passwords, credentials
.env
*.env
!.env.example
*.pem
*.key

# Local Jenkins data
jenkins_home/
GI"
run "cat .gitignore"
run "git status --short"
run "git add ."
run "git status --short"
run "git check-ignore -v logs/Gazizbek_Batyr_system_report.log"
run 'git commit -q -m "Initial commit: Gazizbek Batyr Student API" && git log --oneline'
run "git show --stat --format='%h %an <%ae>%n%s' HEAD | head -40"
