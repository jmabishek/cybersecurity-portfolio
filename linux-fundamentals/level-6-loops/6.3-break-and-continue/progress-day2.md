# 🦾 Level 6.3 — Day 2: Array Refactor (Pattern 2, Scaled)

**Date:** 14 June 2026  
**Status:** 🟡 In progress — Pattern 2 scaled. Patterns 1, 3, 4, 5, 6 pending.

---

## 🎯 What I Built

Replaced the **6 separate `||` conditions** with **one protected array + a nested
while loop**. Same behavior — but now it scales to any number of protected files.
Adding a 7th name means editing only the array. The loop never changes.

```bash
# Protected files — never moved. Add a name here; the loop below never changes.
secure=("boss1.sh" "admin.co" "admin.sh" "auth.sh" "boss2.sh" "log.sh")
cu="${#secure[@]}"

# Sort one file into shell-files / log-files / unknown-files
classify() {
    local file="$1"
    if [ -f "$file" ]; then
        if [[ "$file" == *.sh ]]; then
            echo "found shell file >>>>$file<<<<"
            mv "$file" shell-files
            echo "$file has been moved to ---->>>shell-files"
        elif [[ "$file" == *.log ]]; then
            echo "found log file >>>>$file<<<<"
            mv "$file" log-files
            echo "$file has been moved to ---->>>log-files"
        else
            echo "found unknown file >>>>$file<<<<"
            mv "$file" unknown-files
            echo "$file has been moved to ---->>>unknown-files"
        fi
    fi
}

files=(*)
count="${#files[@]}"
i=0

# OUTER loop — walk every file in the folder
while [ "$i" -le "$count" ]; do
    file="${files[$i]}"
    skip=0
    j=0

    # INNER loop — check this file against the entire protected list
    while [ "$j" -le "$cu" ]; do
        key="${secure[j]}"
        if [[ "$file" == "$key" ]]; then
            skip=1          # match found — flag it
            break           # no need to check the rest
        fi
        j=$((j+1))
    done

    # Flag decides the fate: protected -> skip, else classify
    if [ "$skip" -eq "1" ]; then
        i=$((i+1))
        continue
    else
        classify "$file"
    fi
    i=$((i+1))
done
```

---

## 🔍 Discovered Today

- Bare `$secure` returns **only element 0** — must loop the array to check every name.
- A nested `while` needs its **own count** (`cu="${#secure[@]}"`) and its **own counter** `j`, separate from the outer `i`.
- The inner loop needs its own `j=$((j+1))` or it freezes — Day 1's while+continue rule, now in nested form.
- The **skip flag** carries the inner loop's result OUT. The outer loop can't see the inner `break` otherwise. Set `skip=0` before the inner loop, `skip=1` on a match.
- `unknown-files` was accidentally a **zero-byte file**, not a directory → `-f` passed it to `classify` → "same file" `mv` error. Fix: `rm` then `mkdir`. A file cannot be converted into a directory; `chmod` does **not** change type.
- `mkdir` on an existing name fails with **"File exists"** — the error itself tells you why.
- Directories **auto-skip** `classify` because `-f` matches regular files only.
- Prediction miss, caught honestly: `boss2.sh` is IN the protected list (skip, not classify); directories fail `-f` (ignored, not moved).

---

## ⚠️ Note for Tomorrow

The loop still uses `-le` with `${#array[@]}`, so it runs **one index past the end**.
Harmless now (the empty `$file` fails `-f`, nothing happens), but tighten it to `-lt`
when I revisit.

---

## 📍 Patterns Status

- [x] **Pattern 2** — `continue` skip-by-name, now scaled with array + `break` + nested while
- [ ] **Pattern 1** — `break` in a while monitor *(next session)*
- [ ] **Patterns 3, 4, 5, 6** — pending
