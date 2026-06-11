# Level 6.2c — While Loops Nested · Commands Learned
**Date:** 11 June 2026
**Status:** ✅ Complete — nested loops, boss fights cleared, flexible monitoring tool built

---

## Nested loop combinations — all four

### for inside for
```bash
for server in server1 server2 server3
do
    for user in alice bob charlie
    do
        echo "user $user on $server"
    done
done
```
Outer items × inner items = total iterations.
3 servers × 3 users = 9 lines. Predict before running.

### while inside for (deep scan pattern)
```bash
for logfile in auth.log system.log error.log
do
    echo "--- scanning $logfile ---"
    pass=1
    while [ $pass -le 3 ]
    do
        echo "  pass $pass"
        pass=$((pass + 1))
    done
done
```
for walks the known list. while does the work per item.
Use when: you have a fixed list and need to scan each one deeply.

### for inside while (monitoring pattern)
```bash
round=1
while [ "$round" -le "3" ]
do
    echo "===== round $round ====="
    for log in auth.log system.log error.log
    do
        echo "  checking $log"
    done
    round=$((round + 1))
done
```
while keeps running. for checks each item every round.
Use when: you need to monitor a set of things repeatedly over time.
Real version adds `sleep 60` between rounds.

---

## Calling a function from inside a loop — the professional structure

### What you built before (loop does all the work)
```bash
for log in *
do
    # all the logic sitting here directly
done
```

### Professional version (function does the work, loop just walks)
```bash
scan_file() {
    local log="$1"
    # all logic here
}

for log in *
do
    scan_file "$log"
done
```

The loop has one job — walk the list.
The function has one job — handle one item.
They do not mix.

---

## Calling a function in an if — the rule that cost hours

```bash
# WRONG — [ ] cannot call a function
if [ check_file "$file" ]; then

# CORRECT — call the function naked, no brackets
if check_file "$file"; then
```

`[ ]` is for tests like `-f` and `-eq`. It cannot run a function.
When calling a function in an if — no brackets. The function returns
0 (success) or 1 (failure) and if reads that directly.

This single rule caused hours of debugging in Boss 2.
The error was: `bash: [: check_file: unary operator expected`

---

## ${@:2} — arguments starting from position 2

```bash
report() {
    local rounds="$1"
    # ${@:2} = everything from position 2 onward
    for file in "${@:2}"
    do
        echo "$file"
    done
}

report 3 auth.log system.log error.log
# $1 = 3
# ${@:2} = auth.log system.log error.log
```

Rules:
- `$1` = first argument (specific)
- `${@:2}` = all arguments from position 2 onward (the open-ended list)
- Specific arguments always come FIRST, open-ended list always LAST
- You cannot add another individual argument after `${@:2}`
- `$@` would include `$1` in the loop — wrong. Use `${@:2}` to skip it.

---

## Programs written this session

### Boss 1 — File Sorter (classify function + for loop)
```bash
classify() {
    local file="$1"
    if [ -d "$file" ]; then
        return  # skip directories silently
    elif [[ "$file" == *.sh ]]; then
        echo "$file --> SHELL SCRIPT"
        mv "$file" shell-files
    elif [[ "$file" == *.log ]]; then
        echo "$file --> LOG FILE"
        mv "$file" log-files
    else
        echo "$file --> UNKNOWN"
        mv "$file" unknown-files
    fi
}

for file in *
do
    classify "$file"
done
```
Extended beyond the assignment — physically moves files into folders.
Used test environment (new file boss1.sh) to protect working scripts.
Script moves itself into shell-files — noted as limitation, fix requires
`continue` (Level 6.3).

### Boss 2 — Monitoring Sentinel (check_file function + while + for inside)
```bash
check_file() {
    local file="$1"
    if [ -f "$file" ]; then
        return 0
    else
        return 1
    fi
}

count=1
while [ "$count" -le "3" ]
do
    for file in auth.log system.log error.log
    do
        if check_file "$file"; then
            echo "[ROUND $count] $file -- PRESENT"
        else
            echo "[ROUND $count] $file -- ALERT FILE MISSING"
        fi
    done
    count=$((count + 1))
done
```
Key fix: removed `[ ]` around function call in if.
Tested by deleting files mid-run — ALERT fires correctly.
3 rounds × 3 files = 9 lines. Predicted before running.

### Boss 3 — Flexible Monitor (${@:2} + while inside function)
```bash
report() {
    local files="${@:2}"
    count=1
    while [ "$count" -le "$1" ]; do
        for files in "${@:2}"
        do
            if [ -f "$files" ]; then
                echo "[ROUND $count] $files -- PRESENT"
            else
                echo "[ROUND $count] $files -- ALERT"
            fi
        done
        count=$((count + 1))
    done
}
```

Called as: `report 3 auth.log system.log error.log`
- `$1` controls how many rounds
- `${@:2}` is any number of files
- Works for 1 file or 20 files without changing the script
- Tested with 55 rounds — ran 55 times correctly
- Tested with missing files — ALERT fires per missing file

### pp.sh — Professional refactor of log scanner
```bash
scan_file() {
    local log="$1"
    if [ -d "$log" ]; then
        echo "$log is a directory"
    elif [[ "$log" == *.log ]]; then
        if [[ "$log" == error* ]]; then
            echo "for $log : error detected --->>> CRITICAL"
        elif [[ "$log" == system* ]]; then
            echo "for $log : no error detected --->>> NORMAL"
        else
            echo "nothing suspicious"
        fi
    else
        echo "$log is not a log file"
    fi
}

for log in *
do
    scan_file "$log"
done
```
Refactored from kk.sh — moved all logic into function.
Loop now has one job only: walk the list and call the function.
Built in new file (pp.sh) to protect the working original — test
environment principle applied independently.

---

## Key rules to always remember

- Predict total iterations before running: outer × inner
- `if function_name "$arg"` — no brackets when calling a function in if
- `${@:2}` skips `$1` and takes everything from position 2 onward
- Specific args first, open-ended list last — never reversed
- `[ ]` is for flags like `-f` `-eq`. Not for function calls.
- Loop variable holds ONE item. `${@:2}` holds ALL items from position 2.
- Test environment first — never edit a working script directly
- `sleep 60` turns a 3-round monitor into a real continuous monitor

---

## Three monitoring patterns — identified independently

- **Static log** → read once, move on. No loop needed per file.
- **Real-time log** → infinite while loop, keep watching continuously.
- **Periodic log** → timed while loop, check at intervals with sleep.

The loop choice follows the data behavior, not habit.
