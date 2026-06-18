# 🦾 Level 6.3 — Day 3: Pattern 1 — break in a while monitor
**Date:** 15 June 2026  
**Status:** 🟡 In progress — Pattern 1 shape built (break-scope open). Pattern 2 recalled. Patterns 3, 4, 5, 6 pending.
---
## 🎯 What I Built
Two things. First, **rebuilt the Day-2 boss2.sh protect/skip machine entirely from
memory** as a recall drill — and debugged the full cascade to get it running again
(see Discovered). Then the real prize: a **file-integrity monitor** for Pattern 1.
Outer `while` = the rounds. Inner `for` = walk every critical file this round.
Missing file → ALERT + `break`.
```bash
list=("kk" "ll" "test1.sh")     # the critical files to watch
cc="${#list[@]}"                # how many — count of the array

i=1
while [ "$i" -le "$cc" ]; do          # OUTER — one pass per round
    for j in "${list[@]}"; do         # INNER — every critical file, in full
        if [ -e "$j" ]; then
            echo "round $i -->> $j is present"
        else
            echo "round $i -->> $j is ***missing***"
            break                     # alarm — stop checking this round
        fi
    done
    i=$((i+1))
done
```
Present-path verified: every file reports present, round after round.
---
## 🔍 Discovered Today
- **`-eq` vs `==`**: `-eq` compares **numbers**, `==` compares **text**. Filenames are text → use `==`. `-eq` on a filename throws *arithmetic syntax error* (bash tries to do math on the name).
- **break vs continue**: `break` = abort now + raise the alarm; `continue` = skip this one, keep going. `break` exits only the **inner** loop.
- **`"${list[@]}"` — the big unlock.** `$` = fetch · `{}` = boundary · `[]` = which slot · `@` = all slots · `""` = keep each item whole.
- Bare `$list` returns **element 0 only** — why `for j in "$list"` printed "kk" three times.
- **`${...}` ≠ `$(...)`** — curly braces = *value of a variable*; parentheses = *run a command*. `$(list)` made bash hunt for a program called `list` → "command not found".
- `${#list[@]}` = **count** of elements (my `cc`, Day-2's `cu`). `${list[@]:1:2}` = **slice**. `${list[-1]}` = **last**.
- **Matching vs existence**: a monitor walks the *list* asking "is each file present?" (existence); boss2.sh walks the *directory* comparing to a list (matching). Mirror images — I kept reaching for matching when I needed existence.
- Looping with `"${list[@]}"` uses **no index**, so the off-by-one can't even happen in that shape.
---
## ⚠️ Note for Tomorrow
- My monitor's `break` stops only the **inner** for-loop — the outer monitor keeps running. Pattern 1 wants the **whole monitor** to stop on a missing file. Fix with `break 2`, or the Day-2 **flag pattern** (set flag inside, break inner, outer reads flag and breaks too).
- **Verify the alarm on a REAL missing file** — e.g. `list=("kk" "ll" "zz")`. So far it only fired on the off-by-one ghost (now fixed with `-lt`).
---
## 📍 Patterns Status
- [x] **Pattern 2** — `continue` skip-by-name (scaled Day 2; rebuilt from memory Day 3)
- [~] **Pattern 1** — `break` in a while monitor — *shape built, break-scope open*
- [ ] **Patterns 3, 4, 5, 6** — pending
