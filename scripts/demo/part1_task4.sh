#!/bin/bash
# Part 1 / Task 1.4 - process and log analysis (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
cd ~/projects/gazizbek-batyr-student-api || exit 1
LOG=logs/Gazizbek_Batyr_system_report.log
OUT=logs/Gazizbek_Batyr_log_analysis.txt

section "Task 1.4 Process and log analysis - Batyr Gazizbek"
run "ps aux --sort=-%mem | head -n 8 | cut -c1-150"
run "ps aux | grep -i '[j]ava' | cut -c1-150"
run "pgrep -a java | cut -c1-120"
run "JAVA_PID=\$(pgrep -f 'app.jar' | head -1); ps -o pid,user,%cpu,%mem,etime,cmd -p \$JAVA_PID | cut -c1-120"
run "tail -n 5 $LOG"
run "grep -n 'Gazizbek' $LOG"
run "grep -c 'Gazizbek' $LOG"
run "echo \"Log analysis for Batyr Gazizbek - \$(date '+%Y-%m-%d %H:%M:%S')\" > $OUT"
run "echo \"Search: grep -n 'Gazizbek' $LOG\" >> $OUT"
run "grep -n 'Gazizbek' $LOG >> $OUT"
run "echo \"Total matches: \$(grep -c 'Gazizbek' $LOG)\" >> $OUT"
run "cat $OUT"

section "Difference between > and >>"
run "echo 'first line'  > /tmp/redirect_demo_gazizbek.txt"
run "echo 'second line' > /tmp/redirect_demo_gazizbek.txt"
run "cat /tmp/redirect_demo_gazizbek.txt    # > overwrote the file, only the last line is left"
run "echo 'third line' >> /tmp/redirect_demo_gazizbek.txt"
run "cat /tmp/redirect_demo_gazizbek.txt    # >> appended to the end of the file"
run "cat >> $OUT <<'TXT'

Difference between > and >> (Batyr Gazizbek):
  >   redirects command output to a file and OVERWRITES it (the file is truncated
      first or created if it does not exist).
  >>  redirects command output to a file and APPENDS it to the end, the old
      content is kept. That is why the system report script uses tee -a (append)
      and the log keeps every run, while 'echo ... > file' started this analysis
      file from scratch.
TXT"
run "tail -n 9 $OUT"
