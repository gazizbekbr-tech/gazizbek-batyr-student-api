#!/bin/bash
# Part 3 / Task 3.4 - API testing with curl (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
cd "$(dirname "$0")/../gazizbek-batyr-student-api" || exit 1
export BASE=http://localhost:8091/api/gazizbek-batyr/students
J='-H "Content-Type: application/json"'
W='-w "\nHTTP status: %{http_code}\n"'

section "Task 3.4 Individual API testing - Batyr Gazizbek"
run 'echo $BASE'
run "curl -s $W http://localhost:8091/"
section "1. Create a student with my name"
run "curl -s -i -X POST \$BASE $J -d '{\"firstName\":\"Batyr\",\"lastName\":\"Gazizbek\",\"email\":\"batyr.gazizbek.api-test@student.kz\",\"groupName\":\"IT2-2301\",\"course\":3}'"
ID=$(curl -s "$BASE" | jq '[.[] | select(.email=="batyr.gazizbek.api-test@student.kz")][0].id')
export ID
section "2. Retrieve all students"
run "curl -s \$BASE | jq ."
run "curl -s -o /dev/null -w 'HTTP status: %{http_code}\\n' \$BASE"
section "3. Retrieve one student by ID (ID=$ID)"
run "curl -s $W \$BASE/\$ID"
section "4. Update the student's information"
run "curl -s $W -X PUT \$BASE/\$ID $J -d '{\"firstName\":\"Batyr\",\"lastName\":\"Gazizbek\",\"email\":\"batyr.gazizbek.updated@student.kz\",\"groupName\":\"IT2-2301\",\"course\":4}'"
run "curl -s $W \$BASE/\$ID"
section "5. Delete the student"
run "curl -s -i -X DELETE \$BASE/\$ID"
section "6. Requests for a nonexistent student"
run "curl -s $W \$BASE/\$ID"
run "curl -s $W -X PUT \$BASE/9999 $J -d '{\"firstName\":\"Batyr\",\"lastName\":\"Gazizbek\",\"email\":\"x@student.kz\",\"groupName\":\"IT2-2301\",\"course\":1}'"
run "curl -s $W -X DELETE \$BASE/9999"
section "7. Validation error (extra check)"
run "curl -s $W -X POST \$BASE $J -d '{\"firstName\":\"\",\"lastName\":\"Gazizbek\",\"email\":\"wrong\",\"groupName\":\"IT2-2301\",\"course\":9}'"
