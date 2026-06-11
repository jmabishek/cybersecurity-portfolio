# Level 6.2 — While Loops · Commands Learned
**Date:** Early June 2026
**Status:** ✅ Complete — moved to advanced session after first pass

---

## The `while` loop

```bash
while [ CONDITION ]; do
    # body
    counter=$((counter + 1))    # heartbeat — NEVER forget this
done
```

Three required parts:
- **Initialize** — set the counter before the loop
- **Test** — the condition checked every pass
- **Heartbeat** — the line that eventually makes the condition false

Forget the heartbeat → infinite loop. `Ctrl+C` is the emergency brake.

---

## Arithmetic — `$(( ))`

```bash
x=$((x + 1))      # correct — math happens
x=x+1             # WRONG — stores the text "x+1"
```

Bash treats everything as text unless wrapped in `$(( ))`.
No `$` needed on variables inside the double parentheses.

**Integer overflow:** counters max at ~9.2 quintillion (2^63 − 1),
then roll into negative numbers.

---

## Numeric comparison flags (inside `[ ]`)

| Flag | Meaning |
|------|---------|
| `-eq` | equal to |
| `-ne` | not equal to |
| `-gt` | greater than |
| `-lt` | less than |
| `-ge` | greater than or equal |
| `-le` | less than or equal |

---

## File and directory tests

```bash
[ -f "$x" ]    # true if $x is a file
[ -d "$x" ]    # true if $x is a directory
[ -e "$x" ]    # true if $x exists at all
```

---

## Programs written this session

### 1. Count up with step (odd numbers 1–55)
```bash
x=1
while [ "$x" -le "55" ]; do
    echo "$x"
    x=$((x + 2))
done
```

### 2. Foundation Layer — create files then folders
```bash
x=0
while [ "$x" -le "5" ]; do
    touch file"$x".txt
    echo "txt file $x created"
    x=$((x + 1))
done

d=0
while [ "$d" -le "5" ]; do
    mkdir -p box"$d"
    echo "folder $d created"
    d=$((d + 1))
done
```
Two separate counters — the second loop needs its own fresh `d=0`
or it never runs.

### 3. Inspector — existence check inside a loop
```bash
d=0
while [ "$d" -le "5" ]; do
    if [ -d "box$d" ]; then
        echo "box$d found"
    else
        echo "box$d missing"
    fi
    d=$((d + 1))
done
```

### 4. Combined removal — two separate ifs (both fire each pass)
```bash
x=0; d=0
while [ "$x" -le "5" ] && [ "$d" -le "5" ]; do
    if [ -f "file$x.txt" ]; then
        echo "file$x.txt detected"
        rm -r file"$x".txt
        echo "deleted file$x.txt"
    fi
    if [ -d "box$d" ]; then
        echo "found box$d"
        rm -r "box$d"
        echo "box$d removed"
    fi
    d=$((d + 1))
    x=$((x + 1))
done
```

### 5. repeat() — function + while + two arguments
```bash
repeat() {
    local word="$1"
    local times="$2"
    n=1
    while [ "$n" -le "$times" ]; do
        echo "printing $word - attempt $n - out of $times"
        n=$((n + 1))
    done
}
```

---

## Key rules discovered

- `&&` in a while condition stops the loop at the **shorter** range
- `elif` picks exactly ONE branch — two separate `if`s each fire independently
- `echo` is unconditional — it prints whether the previous command succeeded or not
- `source script.sh` keeps variables alive between runs (ghost variables)
- `./script.sh` spawns a new shell — no ghost variables
- Variable-in-name: `file$x` builds a different name each pass

---

## Why this session was not enough

After completing the basics I was not satisfied. The while loop worked
but I had not combined it with functions, pattern matching, or real
file operations in a way that felt professional. I went into a second
deeper session to fix that before moving to 6.3.
