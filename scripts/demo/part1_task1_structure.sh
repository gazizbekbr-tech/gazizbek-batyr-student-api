#!/bin/bash
# Part 1 / Task 1.1 - create the project structure with terminal commands (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
PROJECT=gazizbek-batyr-student-api

section "Task 1.1 Project structure - Batyr Gazizbek"
run "pwd"
run "mkdir -p $PROJECT/scripts $PROJECT/logs $PROJECT/backups $PROJECT/src"
run "cd $PROJECT"
run "touch Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md"
run "touch scripts/Gazizbek_Batyr_system_report.sh"
run "touch logs/Gazizbek_Batyr_system_report.log"
run "tree"
run 'for f in scripts logs backups src Dockerfile docker-compose.yml Jenkinsfile build.gradle README.md scripts/Gazizbek_Batyr_system_report.sh logs/Gazizbek_Batyr_system_report.log; do if [ -e "$f" ]; then echo "OK      $f"; else echo "MISSING $f"; fi; done'
run "ls -la . scripts logs"
