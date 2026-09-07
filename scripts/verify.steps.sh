# The gates CI runs, in order. `step "<name>" <command...>` stops at the first failure. Keep identical to CI.
step "diff is clean of whitespace errors" git diff --check
step "fast-run.sh parses" bash -n fast-run/fast-run.sh
step "compose file is valid" docker compose -f fast-run/docker-compose.yml config -q
