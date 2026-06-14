# Level 6.3 — Day 2: Array Refactor (Pattern 2, scaled)

**Date:** 14 June 2026
**Status:** In progress — Pattern 2 refined & scaled. Patterns 1, 3, 4, 5, 6 pending.

## What I built
Replaced the 6 separate || conditions with one protected ARRAY + a nested
while loop. Same job — now scales to any number of protected files. Adding a
7th name means editing only the array, never the loop.

secure=("boss1.sh" "admin.co" "admin.sh" "auth.sh" "boss2.sh" "log.sh")
cu="${#secure[@]}"

# outer while walks files[] by index i
file="${files[$i]}"
    skip=0
    j=0
    while [ "$j" -le "$cu" ]; do
        key="${secure[j]}"
        if [[ "$file" == "$key" ]]; then
            skip=1
            break
        fi
        j=$((j+1))
    done
    if [ "$skip" -eq "1" ]; then
        i=$((i+1)); continue
    else
        classify "$file"
    fi
    i=$((i+1))

## Discovered today (minute ones included)
- Bare $secure returns ONLY element 0 — must loop the array to check every name.
- Nested while needs its OWN count (cu="${#secure[@]}") and its OWN counter j,
  separate from the outer i.
- Inner loop needs its own j=$((j+1)) or it freezes — Day 1's while+continue
  rule, now appearing in nested form.
- The skip flag carries the inner loop's result OUT. The outer loop can't see
  the inner break otherwise. skip=0 before the inner loop, skip=1 on match.
- unknown-files was accidentally a zero-byte FILE, not a directory -> -f passed
  it to classify -> "same file" mv error. Fix: rm then mkdir. A file cannot be
  converted to a directory; chmod does NOT change type.
- mkdir on an existing name fails with "File exists" — the error itself tells why.
- Directories auto-skip classify because -f matches regular files only.
- Prediction miss, caught honestly: boss2.sh is IN the protected list (skip, not
  classify); directories fail -f (ignored, not moved).

## Note for tomorrow
Loop still uses -le with ${#array[@]} -> runs one index PAST the end. Harmless
now (empty $file fails -f, nothing happens), but tighten to -lt when I revisit.

## Patterns status
[x] Pattern 2 — continue skip-by-name, scaled with array + break + nested while
[ ] Pattern 1 — break in while monitor (next session)
[ ] Patterns 3, 4, 5, 6 — pending
