# Level 6.2b — Bash Loops & Automation · Commands Learned
**Date:** Between first while session and nested loops session
**Status:** ✅ Complete — the bridge between basics and advanced work

---

## Why this session existed

After the basic while loop session I was not satisfied. The loops worked
but felt mechanical — counters and file creation, nothing that looked like
real security automation. This session was self-directed: I decided to go
deeper before moving forward. The goal was to combine for loops, while loops,
functions, pattern matching, and file operations into tools that actually do
something useful.

---

## New concept — `[[ ]]` double brackets

```bash
[[ "$f" == *.sh ]]     # pattern match — works
[[ "$f" == "*.sh" ]]   # WRONG — * becomes literal, kills the wildcard
```

`[[ ]]` is the upgraded test. Safer than `[ ]`, handles spaces and empty
values cleanly, and supports pattern matching.

`==` inside `[[ ]]` means "matches." With a plain string on the right it
is an exact match. With a pattern on the right it matches the shape.

**The critical quoting rule:**
- Quote the LEFT side: `"$f"`
- Leave the RIGHT side (pattern) unquoted: `*.sh`
- Quoting the pattern kills the wildcard — this caused real data loss

---

## The two different `*` symbols

```bash
for f in *              # shell glob — builds a real list from disk
[[ "$f" == *.sh ]]     # pattern test — checks shape of a string
```

Same symbol. Two completely different jobs. The glob reaches into the
folder before the loop runs. The pattern test never touches the disk.

---

## `&&` vs `;` — the dangerous difference

```bash
[[ "$f" == *.sh ]]; rm "$f"    # DANGEROUS — rm runs always
[[ "$f" == *.sh ]] && rm "$f"  # SAFE — rm only runs if match succeeds
```

- `;` runs the next command no matter what happened before
- `&&` runs the next command only if the previous succeeded
- `||` runs the next command only if the previous failed

This distinction caused real file loss before it was understood.

---

## Programs written this session

### Program 1 — for + while in one script
```bash
for file in file1 file2 file3
do
    echo "--- checking $file ---"
    count=1
    while [ $count -le 3 ]
    do
        echo "  step $count inside $file"
        count=$((count + 1))
    done
done
```
for walks the known list. while runs the scan passes per file.
Outer items × inner items = total iterations.

### Program 2 — Cleanup tool v1 (hardcoded name protection)
```bash
repeat() {
  local any="$1"
  if [ "$any" = "ss.sh" ] || [ "$any" = "rr.sh" ]; then
      echo "found shell file $any"
  elif [ -f "$any" ]; then
      rm -r "$any"; echo "file $any deleted"
  elif [ -d "$any" ]; then
      rm -r "$any"; echo "$any folder deleted"
  fi
}
for abhi in *; do repeat "$abhi"; done
```
Problem: only protects named files. A new .sh file would be deleted.

### Program 3 — Cleanup tool v2 (pattern protection + dry-run)
```bash
cleanup() {
  local target="$1"
  local mode="$2"

  if [[ "$target" == *.sh ]]; then
    echo "PROTECTED: $target"
    return
  fi

  if [ -f "$target" ] || [ -d "$target" ]; then
    if [ "$mode" = "go" ]; then
      rm -r "$target"
      echo "DELETED: $target"
    else
      echo "would delete: $target"
    fi
  fi
}

# dry run first — never delete blindly
for item in *; do cleanup "$item" dry; done

# only run this when the list looks correct
# for item in *; do cleanup "$item" go; done
```

Two improvements over v1:
- Pattern protects ANY .sh file, not just named ones
- Dry-run shows what would happen before anything is deleted

---

## Bugs hit and fixed — all discovered personally

1. **Quoted pattern data loss** — `[[ "$any" == "*.sh" ]]` quoted the
   pattern. The `*` became literal. Every .sh file failed the protect
   check and was deleted. Lesson: never quote the pattern side.
2. **Variable scope confusion** — `repeat "$@"` passed the shell's empty
   args. `repeat "$any"` passed the function's private variable. Only
   `repeat "$abhi"` passed the loop variable correctly.
3. **The lying echo** — success messages printed even when rm failed.
   Gate messages: `if rm ...; then echo done; fi`
4. **Ghost variables** — source kept stale values alive between runs.
   Use `./script.sh` for a clean shell.

---

## Key professional rules locked in

- Never run a destructive loop without a dry-run first
- Always leave pattern unquoted in `[[ ]]` tests
- Use `&&` not `;` after a test before a dangerous command
- The loop variable holds ONE item — `$@` holds ALL of them
- `local` keeps function variables private and prevents leaks
