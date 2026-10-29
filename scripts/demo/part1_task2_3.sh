#!/bin/bash
# Part 1 / Tasks 1.2 and 1.3 - system report, permissions and backup (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
cd ~/projects/gazizbek-batyr-student-api || exit 1

section "Task 1.2 System monitoring script - Batyr Gazizbek"
run "cat scripts/Gazizbek_Batyr_system_report.sh"
run "bash -n scripts/Gazizbek_Batyr_system_report.sh && echo 'Syntax OK'"
run "bash scripts/Gazizbek_Batyr_system_report.sh"
run "wc -l logs/Gazizbek_Batyr_system_report.log"

section "Task 1.3 Permissions and backup - Batyr Gazizbek"
run "ls -l scripts/Gazizbek_Batyr_system_report.sh"
run "chmod +x scripts/Gazizbek_Batyr_system_report.sh"
run "ls -l scripts/Gazizbek_Batyr_system_report.sh"
run "chmod 744 scripts/Gazizbek_Batyr_system_report.sh   # owner rwx, group r--, others r--"
run "ls -l scripts/Gazizbek_Batyr_system_report.sh"
run "stat -c '%A %a %U %n' scripts/Gazizbek_Batyr_system_report.sh"
run "./scripts/Gazizbek_Batyr_system_report.sh > /dev/null && echo 'Script runs as ./ (executable)'"
run "cp README.md backups/README_Gazizbek_Batyr_backup.md"
run "ls -l backups/"
run "diff README.md backups/README_Gazizbek_Batyr_backup.md && echo 'Backup is identical to README.md'"
run "sha256sum README.md backups/README_Gazizbek_Batyr_backup.md"
run "head -n 5 backups/README_Gazizbek_Batyr_backup.md"
