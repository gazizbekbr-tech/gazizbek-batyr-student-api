#!/bin/bash
#
# Gazizbek_Batyr_system_report.sh
# System monitoring report for the DevOps midterm project of Batyr Gazizbek.
# Prints the report to the terminal and appends it to the personal log file.
#
# Usage: ./scripts/Gazizbek_Batyr_system_report.sh [log_file]

STUDENT_NAME="Batyr Gazizbek"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_FILE="${1:-$SCRIPT_DIR/../logs/Gazizbek_Batyr_system_report.log}"

mkdir -p "$(dirname "$LOG_FILE")"

os_name() {
    if [ -r /etc/os-release ]; then
        . /etc/os-release && echo "$PRETTY_NAME"
    elif command -v sw_vers >/dev/null 2>&1; then
        echo "$(sw_vers -productName) $(sw_vers -productVersion)"
    else
        uname -s
    fi
}

cpu_info() {
    if command -v lscpu >/dev/null 2>&1; then
        lscpu | grep -E '^(Architecture|CPU\(s\)|Model name|Vendor ID|Thread\(s\) per core)'
    else
        echo "Model name: $(sysctl -n machdep.cpu.brand_string 2>/dev/null)"
        echo "CPU(s):     $(sysctl -n hw.ncpu 2>/dev/null)"
    fi
}

memory_info() {
    if command -v free >/dev/null 2>&1; then
        free -h
    else
        echo "Total memory: $(( $(sysctl -n hw.memsize) / 1024 / 1024 / 1024 )) GiB"
        vm_stat | head -5
    fi
}

report() {
    echo "=================================================="
    echo " System report - $STUDENT_NAME"
    echo "=================================================="
    echo "Student full name : $STUDENT_NAME"
    echo "Date and time     : $(date '+%Y-%m-%d %H:%M:%S %Z')"
    echo "Username          : $(whoami)"
    echo "Hostname          : $(hostname)"
    echo "Operating system  : $(os_name)"
    echo "Kernel            : $(uname -s) $(uname -r) ($(uname -m))"
    echo
    echo "---- CPU information ----"
    cpu_info
    echo
    echo "---- Memory information ----"
    memory_info
    echo
    echo "---- Disk usage ----"
    df -h
    echo
    echo "---- Available disk space on / ----"
    df -hP / | awk 'NR==1 {printf "%-24s %8s %10s %6s\n", "Filesystem", "Size", "Available", "Use%"}
                    NR==2 {printf "%-24s %8s %10s %6s\n", $1, $2, $4, $5}'
    echo
    echo "Report finished for $STUDENT_NAME"
    echo
}

# tee -a: show the output on the screen and append (>>) it to the log file
report | tee -a "$LOG_FILE"

echo "Report saved to: $LOG_FILE"
