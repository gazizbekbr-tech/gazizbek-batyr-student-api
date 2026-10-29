# Terminal demonstration scripts

These scripts produced the transcripts in `docs/evidence/`. Each one prints a shell prompt and the
command before running it, so the output reads like a terminal session.

- `part1_*.sh` were run inside an Ubuntu 24.04 container as user `batyr`
  (`docker run --pid=host -v <parent folder>:/home/batyr/projects ...`), with the project at
  `~/projects/gazizbek-batyr-student-api`.
- The other scripts (and `r.sh`, which runs its arguments as demonstrated commands) expect to sit in a
  folder next to the project, i.e. `<parent>/.demo/` with the project in `<parent>/gazizbek-batyr-student-api/`.
- `_demo.sh` holds the shared `run` / `section` helpers.
