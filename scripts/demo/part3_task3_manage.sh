#!/bin/bash
# Part 3 / Task 3.3 - container management and data persistence (Batyr Gazizbek)
source "$(dirname "$0")/_demo.sh"
cd "$(dirname "$0")/../gazizbek-batyr-student-api" || exit 1
export BASE=http://localhost:8091/api/gazizbek-batyr/students
wait_app() { for i in $(seq 1 40); do curl -sf http://localhost:8091/actuator/health >/dev/null && return; sleep 1; done; }

section "Task 3.3 Container management - Batyr Gazizbek"
run "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'"
run "docker logs --tail 8 gazizbek-batyr-app 2>&1 | cut -c1-200"
run "docker inspect gazizbek-batyr-app --format 'Name: {{.Name}}{{println}}Image: {{.Config.Image}}{{println}}State: {{.State.Status}} (started {{.State.StartedAt}}){{println}}RestartPolicy: {{.HostConfig.RestartPolicy.Name}}{{println}}Ports: {{json .NetworkSettings.Ports}}{{println}}Networks: {{range \$k,\$v := .NetworkSettings.Networks}}{{\$k}} ip={{\$v.IPAddress}} aliases={{\$v.DNSNames}}{{end}}'"
run "docker inspect gazizbek-batyr-app --format '{{range .Config.Env}}{{println .}}{{end}}' | grep -v PASSWORD   # password hidden on purpose"
run "docker inspect gazizbek-batyr-postgres --format 'Mounts: {{range .Mounts}}{{.Type}} {{.Name}} -> {{.Destination}}{{end}}{{println}}Health: {{.State.Health.Status}}'"
run "docker exec gazizbek-batyr-app sh -c 'whoami; java -version 2>&1 | head -1; ls -l /app; echo STUDENT_NAME=\$STUDENT_NAME'"

section "Stop and restart the application service"
run "docker compose stop gazizbek-batyr-app"
run "docker compose ps -a --format 'table {{.Name}}\t{{.Status}}'"
run "curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8091/ || echo 'application is not reachable (stopped)'"
run "docker compose start gazizbek-batyr-app"
wait_app
run "docker compose ps --format 'table {{.Name}}\t{{.Status}}'"
run "docker compose restart gazizbek-batyr-app"
wait_app
run "curl -s http://localhost:8091/; echo"

section "PostgreSQL data persists after restarting the services"
run "curl -s -o /dev/null -w 'HTTP %{http_code}\n' -X POST \$BASE -H 'Content-Type: application/json' -d '{\"firstName\":\"Persistence\",\"lastName\":\"Check Gazizbek\",\"email\":\"persistence.gazizbek@student.kz\",\"groupName\":\"IT2-2301\",\"course\":3}'"
run "docker exec gazizbek-batyr-postgres psql -U gazizbek_batyr -d gazizbek_batyr_db -c 'SELECT id, first_name, last_name, email FROM students ORDER BY id;'"
run "docker compose down     # removes containers and network, keeps the named volume"
run "docker ps -a --filter name=gazizbek-batyr --format '{{.Names}}' | wc -l"
run "docker volume ls --filter name=gazizbek-batyr-pgdata"
run "docker compose up -d 2>&1 | tail -4"
wait_app
run "docker logs gazizbek-batyr-app 2>&1 | grep -E 'seed skipped|Seeded' | cut -c1-200"
run "curl -s \$BASE | jq -c '.[] | {id, firstName, lastName, email}'"
