# Sub Level 5.1 — Bash Functions

**Status:** Complete  
**Date:** 15 May 2026  
**Hero:** 🦾 Iron Man (Linux & Bash)

## Concepts Mastered

| # | Concept | Syntax |
|---|---|---|
| 1 | Function structure | `name() { body; }` |
| 2 | Define vs call | Define stores; call executes the stored definition |
| 3 | Positional arguments | `$1` `$2` `$3` ... |
| 4 | All arguments | `$@` (works for 0 to infinite args) |
| 5 | Argument count | `$#` |
| 6 | Quoting inside body | `"$1"` protects the value |
| 7 | Quoting at call site | `"multi word"` keeps it as ONE argument |
| 8 | Local variables | `local var=value` |
| 9 | Command substitution | `$(command)` |
| 10 | Default values | `${1:-fallback}` |
| 11 | Empty-arg trick | `func "" "real_value"` |

## Syntax Quick Reference

```bash
# Basic function
greet() { echo "Hello $1"; }

# Multiple arguments and count
roster() { echo "Team: $@ (count: $#)"; }

# Local variables
profile() {
  local name=$1
  local city=$2
  echo "$name from $city"
}

# Command substitution
report() {
  local t=$(date)
  echo "Time: $t"
}

# Default values
connect() { echo "Connecting to ${1:-localhost} on port ${2:-22}"; }
```

## Final Boss Function — Session Logger

A real-world function combining all 11 concepts:

```bash
session() {
  local t=$(date)
  echo "=== Session started ==="
  echo "Operator: ${1:-$(whoami)}"
  echo "Task: ${2:-general work}"
  echo "Start time: $t"
  echo "Total inputs: $#"
  echo "All inputs: $@"
  echo "==="
}

# Test calls
session abhi "vulnerability scan"
session abhi
session
session "" "incident response"
session abhi "log review" priority1 internal urgent
```

## Snapshot vs Live Behavior

```bash
# SNAPSHOT — captured once at assignment, frozen
today=$(date)
echo $today    # always shows original time

# LIVE — re-runs on every function call
myfunc() { echo "$(date)"; }
myfunc         # fresh time each call
```

**Rule:** `$()` itself is not a snapshot. It just means *"run this command and substitute output here, now."* The snapshot behavior comes from **assigning to a variable**. Inside a function body, `$()` re-runs on every call because the body re-executes each call.

## ${...} vs $(...) — Two Different Worlds

| Wrapper | Purpose |
|---|---|
| `$( ... )` | Run a command, give back its output |
| `${ ... }` | Look up a variable, with optional rules like defaults |

Confusing them produces "command not found" errors. Both can be nested: `${1:-$(whoami)}` means "look up `$1`, but if empty, run `whoami` and use that output."
