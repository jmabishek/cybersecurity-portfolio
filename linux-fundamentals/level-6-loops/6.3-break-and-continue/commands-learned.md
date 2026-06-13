# Level 6.3 — Break and Continue · Day 1 — Commands Learned

**Date:** 13 June 2026
**Status:** 🟡 In progress — core concepts owned, Pattern 2 cleared, 5 patterns pending for Day 2

---

## break — kill the loop immediately

```bash
for i in 1 2 3 4 5 6
do
    if [ "$i" -eq "3" ]; then
        break
    fi
    echo "$i"
done
# Output: 1 2
```

`break` ends the loop the moment the condition is true. Remaining items in the list are discarded. Execution jumps to the line after `done`. Works identically in for, while, and any nested loop.

---

## continue — skip the current pass only

```bash
for i in 1 2 3 4 5 6
do
    if [ "$i" -eq "3" ]; then
        continue
    fi
    echo "$i"
done
# Output: 1 2 4 5 6
```

`continue` skips one item and the loop keeps running. Loop is still alive. Can be used multiple times in one loop.

**break vs continue:**
- break = loop is dead
- continue = loop is alive, one item ignored

---

## Multiple continues + break in one loop

```bash
for i in 1 2 3 4 5 6 7 8 9 10
do
    if [ "$i" -eq "3" ]; then continue; fi
    if [ "$i" -eq "5" ]; then continue; fi
    if [ "$i" -eq "8" ]; then break; fi
    echo "$i"
done
# Output: 1 2 4 6 7
```

Multiple continues allowed. Break ends everything. Whichever condition fires first on a given pass wins.

---

## The while + continue trap — the rule that cost hours

```bash
# WRONG — infinite loop
x=1
while [ "$x" -le "6" ]; do
    if [ "$x" -eq "3" ]; then
        continue          # x never increments, freezes on 3 forever
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
        x=$((x+1))        # step forward first
        continue          # then skip
    fi
    echo "$x"
    x=$((x+1))
done
```

In a `for` loop the counter moves on its own (conveyor belt). In a `while` loop the counter is manual (walking and counting). If `continue` fires before incrementing, the counter never moves and the loop freezes on the same value forever. Ctrl+C is the only exit.

**Rule:** Every `continue` branch in a `while` loop needs its own increment before it fires.

Discovered by triggering the infinite loop multiple times and fixing it by hand.

---

## $0 — what it actually holds

```bash
echo $0
# /usr/bin/bash       (when running with: source boss1.sh)
```

`$0` is the name of whatever is running the script. With `source`, that's the current shell — `/usr/bin/bash` — not the script name. So comparing a filename to `$0` to "skip myself" never matches.

**Workaround:** set a global variable at the top of the script with the script's own name, and compare against that instead.

---

## Variable scope — discovered through bugs

```bash
# ERROR — local only works inside a function
for file in *
do
    local ss="boss1.sh"   # bash: local: can only be used in a function
done
```

```bash
# ERROR — ss set inside classify() is invisible to the loop
classify() {
    ss="boss1.sh"
    ...
}
for file in *
do
    if [[ "$file" == "$ss" ]]; then   # $ss is empty here
        ...
done
```

```bash
# CORRECT — ss declared at top level, visible everywhere
ss="boss1.sh"
classify() { ... }
for file in *
do
    if [[ "$file" == "$ss" ]]; then
        continue
    fi
    classify "$file"
done
```

**Rule:** Where you define a variable decides who can see it. Top of script = global. Inside function = private to that function.

---

## continue cannot live inside a function

```bash
# WRONG — continue inside the function does nothing useful
classify() {
    local file="$1"
    if [[ "$file" == "$ss" ]]; then
        continue          # function returns, but loop keeps going
    fi
    ...
}
```

```bash
# CORRECT — continue lives in the loop, not the function
classify() { ... }        # function only does work

for file in *
do
    if [[ "$file" == "$ss" ]]; then
        continue          # loop controls flow
    fi
    classify "$file"
done
```

`continue` only affects the loop it's directly inside. Inside a function it does not propagate to the outer loop. Function does the work. Loop controls flow. Same separation as Level 6.2c.

---

## Skip by position vs skip by property

Two ways to use `continue`:

**Skip by position** — you know exactly which value to skip.
```bash
if [ "$i" -eq "3" ]; then continue; fi
```
Used for numbers, counts, specific indexes.

**Skip by property/pattern** — you don't know in advance.
```bash
if [[ "$file" == *.sh ]]; then continue; fi
```
Used for files, real-world data, SOC work. Describe what to skip, the loop matches every item against the rule.

In real scripts skip-by-property is far more common.

---

## Arrays — introduced minimally (full topic in Level 7)

```bash
files=(*)              # pack every file into a numbered list
count=${#files[@]}     # how many items are in the list
file="${files[$i]}"    # grab the item at position $i
```

An array is a numbered list of items. Position 0, position 1, position 2... `*` grabs every file, `( )` packs them into the list.

Used here only because making a `while` loop walk a folder requires walking by index — and that needs an array. Full coverage is Level 7.

---

## Programs written today

### bk.sh — for loop with break

```bash
for i in 1 2 3 4 5 6
do
    if [ "$i" -eq "3" ]; then
        break
    fi
    echo "$i"
done
```
First contact with `break`. Loop stops at 3.

---

### bk.sh v2 — for loop with continue

```bash
for i in 1 2 3 4 5 6
do
    if [ "$i" -eq "3" ]; then
        continue
    fi
    echo "$i"
done
```
3 skipped, rest printed.

---

### bkw.sh — while loop with break

```bash
x=1
while [ "$x" -le "6" ]; do
    if [ "$x" -eq "3" ]; then
        break
    fi
    echo "$x"
    x=$((x+1))
done
```
Confirmed `break` behaves identically in while.

---

### bkw.sh v2 — while + continue (infinite loop debugged)

```bash
i=1
while [ "$i" -le "10" ]; do
    if [ "$i" -eq 3 ]; then
        i=$((i+1))
        continue
    fi
    if [ "$i" -eq 5 ]; then
        i=$((i+1))
        continue
    fi
    if [ "$i" -eq 8 ]; then
        break
    fi
    echo "$i"
    i=$((i+1))
done
# Output: 1 2 4 6 7
```
Multiple continues + one break in a while loop. Each continue branch has its own increment. Locked in the while+continue rule permanently.

---

### boss1.sh refactor (for loop version) — Pattern 2 fix

```bash
ss="boss1.sh"

classify() {
    local file="$1"
    if [ -f "$file" ]; then
        if [[ "$file" == *.sh ]]; then
            echo "found shell file >>>>$file<<<<"
            mv "$file" shell-files
        elif [[ "$file" == *.log ]]; then
            echo "found log file >>>>$file<<<<"
            mv "$file" log-files
        else
            echo "found unknown file >>>>$file<<<<"
            mv "$file" unknown-files
        fi
    fi
}

for file in *
do
    if [[ "$file" == "$ss" ]]; then
        continue
    else
        classify "$file"
    fi
done
```

Fixes the Boss 1 limitation from Level 6.2c — the classify script no longer moves itself. Took multiple wrong attempts (continue inside function, `$0` mismatch, scope errors) to land on the working version. The bugs taught more than the fix did.

---

### boss1.sh while version — same job, while + array

```bash
ss="boss1.sh"

classify() { ... }   # same function as above

files=(*)
count=${#files[@]}
i=0

while [ $i -lt $count ]; do
    file="${files[$i]}"
    if [[ "$file" == "$ss" ]]; then
        i=$((i+1))
        continue
    fi
    classify "$file"
    i=$((i+1))
done
```

Same logic as the for version, but walked by counter instead of glob expansion. Demonstrates that `for file in *` is the right tool here — `while` needs an array detour to do the same job. Choice of loop follows the data shape.

---

## Key rules to always remember

- `break` kills the loop. `continue` skips one pass. They work the same in for and while.
- Multiple continues + one break in the same loop is legal and useful.
- In a `while` loop, increment the counter BEFORE every `continue` — or the loop freezes.
- `$0` is `/usr/bin/bash` when sourced. Use a manual variable to identify the script.
- `local` is function-only. Outside a function = error.
- A function's variables are invisible outside unless declared at the top of the script.
- `continue` only affects the loop it's directly in — never put it inside a function.
- Two flavors of skip: by position (known index) or by property (pattern match). Property is more common in real work.
- `for file in *` walks files naturally. Use `while` only when you need a counter or sentinel.

---

## Integration status — patterns from resume prompt

- [x] **Pattern 2** — continue in classify (skip self) — DONE
- [ ] Pattern 1 — break in while monitoring loop
- [ ] Pattern 3 — break in nested loop on critical error
- [ ] Pattern 4 — continue with pattern matching
- [ ] Pattern 5 — break in flexible monitor
- [ ] Pattern 6 — while true + sentinel break

---

## Resume tomorrow from here

Pattern 1: a while-loop file monitor that breaks immediately when a critical file goes missing. Building on Boss 2 / Boss 3 from Level 6.2c.
