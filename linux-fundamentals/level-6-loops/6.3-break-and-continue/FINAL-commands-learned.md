# Level 6.3 — Break and Continue · Commands Learned (Final)

**Date completed:** 18 June 2026
**Status:** ✅ Complete — all 6 patterns owned and tested

---

## Core concepts

### break — kill the loop immediately

```bash
for i in 1 2 3 4 5 6; do
    if [ "$i" -eq "3" ]; then
        break
    fi
    echo "$i"
done
# Output: 1 2
```

`break` ends the loop the moment the condition is true. Remaining items are discarded. Execution jumps to the line after `done`. Works identically in `for`, `while`, and nested loops.

---

### continue — skip the current pass only

```bash
for i in 1 2 3 4 5 6; do
    if [ "$i" -eq "3" ]; then
        continue
    fi
    echo "$i"
done
# Output: 1 2 4 5 6
```

`continue` skips one item. Loop stays alive. Can be used multiple times in one loop.

**The one-line rule:**
- `break` = loop is dead
- `continue` = loop is alive, one pass ignored

---

### Multiple continues + break in one loop

```bash
for i in 1 2 3 4 5 6 7 8 9 10; do
    if [ "$i" -eq "3" ]; then continue; fi
    if [ "$i" -eq "5" ]; then continue; fi
    if [ "$i" -eq "8" ]; then break; fi
    echo "$i"
done
# Output: 1 2 4 6 7
```

Multiple continues are legal. Break ends everything. Whichever condition fires first on a given pass wins.

---

### The while + continue trap

```bash
# WRONG — infinite loop, freezes on 3 forever
x=1
while [ "$x" -le "6" ]; do
    if [ "$x" -eq "3" ]; then
        continue          # x never increments
    fi
    echo "$x"
    x=$((x+1))
done
```

```bash
# CORRECT — increment BEFORE continue
x=1
while [ "$x" -le "6" ]; do
    if [ "$x" -eq "3" ]; then
        x=$((x+1))        # move forward first
        continue          # then skip
    fi
    echo "$x"
    x=$((x+1))
done
```

In a `for` loop the counter moves automatically. In a `while` loop the counter is manual. If `continue` fires before the increment, the loop freezes on the same value forever.

**Rule:** Every `continue` branch in a `while` loop needs its own increment before it fires.

---

## The 6 Patterns

### Pattern 2 · continue — skip protected files (by exact name)

```bash
ss="boss1.sh"

for file in *; do
    if [[ "$file" == "$ss" ]]; then
        continue
    fi
    classify "$file"
done
```

Skip one known file by exact name. Everything else gets processed. Used to protect scripts from moving themselves.

**Key discovery:** `continue` cannot live inside a function. It only affects the loop it is directly inside. Function does the work. Loop controls flow.

---

### Pattern 1 · break — monitor, alarm on missing

```bash
for file in notes.txt report.txt secret.txt; do
    if [ ! -f "$file" ]; then
        echo "ALARM: $file is missing — stopping check"
        break
    fi
    echo "$file — found, all good"
done
```

Loop through a known list of critical files. The moment one is missing — alarm and stop. Used in file integrity monitoring. Every remaining file is abandoned when break fires.

**`! -f` means:** NOT a file. The `!` flips any condition.

---

### Pattern 3 · break — alarm on critical content

```bash
for file in notes.txt report.txt secret.txt; do
    if [ ! -f "$file" ]; then
        echo "skipping — $file not found"
        continue
    fi
    if grep -q "CRITICAL" "$file"; then
        echo "ALARM: Critical content found in $file — halting"
        break
    fi
    echo "$file — checked, all clear"
done
```

File exists but contains something dangerous → break immediately. The upgrade from Pattern 1: the loop goes **inside** the file, not just checks its existence.

**`grep -q`** — searches inside a file quietly. Returns yes or no. Full grep coverage in Text Processing (Hawkeye).

Two conditions in one loop:
- First `if` — file missing → continue
- Second `if` — dangerous content → break

---

### Pattern 4 · continue — skip files by pattern

```bash
for file in *; do
    if [[ "$file" == *.sh ]]; then
        echo "$file — shell file, skipping"
        continue
    fi
    echo "$file — regular file, checking"
done
```

Skip an entire **category** of files by shape of name — not by exact name. `*.sh` catches every shell file automatically without knowing their names in advance.

**Pattern vs exact name:**
- Pattern 2 → skip `boss1.sh` specifically
- Pattern 4 → skip anything ending in `.sh`

**`[[ "$file" == *.sh ]]`** — double brackets for pattern matching. Quote the left side. Never quote the right side pattern or `*` becomes literal.

Common patterns:
- `*.sh` → all shell files
- `*.log` → all log files
- `temp_*` → anything starting with temp

---

### Pattern 5 · break — flexible monitor, many arguments

```bash
for file in "$@"; do
    if [ -f "$file" ]; then
        echo "checking: $file exists"
    else
        echo "ALARM: $file missing"
    fi
done
```

Run as: `source script.sh notes.txt report.txt fakefile.txt secret.txt`

`$@` = every argument passed at runtime. The script does not know the list in advance. Any number of files. Same script handles all of them.

**Hardcoded list vs `$@`:**
- Hardcoded → edit the script every time you need a different list
- `$@` → pass the list at runtime, script stays unchanged

Professional term: **reusability**.

---

### Pattern 6 · break — always-on production monitor

```bash
while true; do
    if [ -f "secret.txt" ]; then
        echo "all clear — secret.txt present"
    else
        echo "ALARM: secret.txt gone — halting"
        break
    fi
    sleep 3
done
```

Never stops unless something goes wrong or you force-stop it with `Ctrl+C`. Checks every 3 seconds. The moment the file disappears — alarm fires and break ends the monitor.

**`while true`** — condition is always true. Loop runs forever by design.

**`sleep 3`** — breathing gap between checks. Without it the loop hammers the CPU thousands of times per second. Always include sleep in production monitors.

**`Ctrl+C`** — manual emergency stop for any infinite loop.

---

## for vs while — the choosing rule

| Situation | Use |
|---|---|
| Known list of files, names, arguments | `for` |
| Unknown duration, watching a condition | `while` |
| Monitoring with time intervals | `while true` + `sleep` |
| Walking a folder | `for file in *` |
| Counting passes | `while` with counter |

`break` and `continue` work identically in both. The loop type follows the data shape, not the other way around.

---

## Variable and scope rules locked in

```bash
# $0 is unreliable with source
echo $0   # returns /usr/bin/bash — not the script name

# local is function-only
local x="hello"   # ERROR outside a function

# Top-level = global, function-level = private
ss="boss1.sh"     # visible everywhere
classify() {
    local file="$1"   # private to classify only
}
```

---

## Key rules — always remember

- `break` kills the loop. `continue` skips one pass. Both work the same in `for` and `while`.
- In a `while` loop — increment the counter BEFORE every `continue` or the loop freezes.
- `continue` only affects the loop it is directly in. Never put it inside a function.
- `$0` is the shell name when sourced. Use a manual variable for script identity.
- `local` is function-only. Top of script = global. Inside function = private.
- Two flavors of skip: by position (exact value) or by property (pattern). Property is more common in real security work.
- `for file in *` is the natural tool for walking a folder. `while` needs an array detour for the same job.
- Always include `sleep` in `while true` monitors.
- `$@` makes any script reusable — the list comes from outside at runtime.
- `! -f` flips any file condition. Not a file = does not exist.
