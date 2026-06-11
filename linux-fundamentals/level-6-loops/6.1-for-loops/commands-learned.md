# Level 6.1 — `for` Loops · Commands Learned

## The `for` loop
```bash
for VAR in LIST
do
    # body — runs once per item, VAR holds the current item
done
```
- `for` names a loop variable; `in` is followed by the list to walk.
- `do` / `done` bracket the body — same idea as `then` / `fi` around an `if`.
- Each pass, `VAR` holds **one** item from the list, in order, until the list runs out.
- `for VAR in "$@"` walks every argument handed to a function, one at a time.

## Argument tools used inside loops
- `"$@"` — all arguments, as **separate items** (a row, not one string).
- `$#` — the **count** of arguments (for "how many?" — no-args guard, >5 warning).
- the **loop variable** (e.g. `$item`) — the **single** argument being handled this pass.
- `"$*"` — the all-in-one-string sibling of `$@` *(noted, not used yet)*.

## Previous-level commands, now used inside loops
- `if` / `elif` / `else`, `-e` / `-f` / `-d`, `-eq` / `-gt` — classify and guard each item.
- `mkdir -p` — create folders; `-p` means create-if-missing, no error if it exists.
- `mv` — relocate files/folders.
- `ls FOLDER` — list a folder's contents without `cd`-ing into it.
- variables — hold config (e.g. bin names) so logic stays fixed and settings move.
- `start="$(pwd)"` + `cd "$start"` — capture a location and return to it portably.

## New commands fused into loops (today)
- `cp` — copy one file into each destination (used in `seed`).
- `chmod` — set permissions on each item as the loop walks (used in `triage`).
- `rm -r` — remove a folder and everything inside it (used in `triage`).
- `folder/*` — glob the contents of a **named** directory, not just the current
  one. Matches come back WITH the path attached (`testzone/25`), which is exactly
  why `cp`/`chmod`/`rm` can act on each item.
- `"$1"/*` vs `"$@"/*` — the `/*` attaches to the **last** argument only, so for a
  single target folder use `"$1"/*`.
- **nested `for`** — a `for` inside a `for`. The inner list points at the *outer*
  loop variable + `/*` (`for target in "$folder"/*`), chaining the loop variables
  downward.

## Worked example 1 — `sweep` (classify & create)
```bash
sweep() {
    if [ "$#" -eq 0 ]; then echo "no value given"; return; fi
    for item in "$@"; do
        if [ -e "$item" ]; then
            if [ -d "$item" ]; then echo "$item is online"
            elif [ -f "$item" ]; then echo "$item is a file, not a subsystem"
            fi
        else
            mkdir -p "$item"
            echo "$item newly created"
        fi
    done
}
```

## Worked example 2 — `org` (sort into bins)
```bash
org() {
    filebin="files"
    dirbin="folders"
    if [ "$#" -eq 0 ]; then echo "no input given"; return; fi
    mkdir -p "$filebin" "$dirbin"
    if [ "$#" -gt 5 ]; then echo "heads up: more than 5 items"; fi
    for item in "$@"; do
        if [ -e "$item" ]; then
            if [ -f "$item" ]; then mv "$item" "$filebin"; echo "$item -> $filebin"
            elif [ -d "$item" ]; then mv "$item" "$dirbin"; echo "$item -> $dirbin"
            fi
        else
            echo "can't find $item, skipping"
        fi
    done
    echo "contents of $filebin:"; ls "$filebin"
    echo "contents of $dirbin:"; ls "$dirbin"
    echo "sorting done"
}
```

## Worked example 3 — `seed` (fan-out: copy one file into many folders)
Pattern: loop over **destinations**, deliver the same starter file into each.
The "is the starter file even here?" check sits at the **top** (fail fast) so it
never fails noisily inside every folder.
```bash
seed() {
    if [ "$#" -eq 0 ]; then
        echo "no input given"
    elif [ -f "demo.txt" ]; then
        echo "starter file is present"
    else
        echo "starter file not found"
        return
    fi
    for board in "$@"
    do
        if [ -d "$board" ]; then
            cp demo.txt "$board"
        else
            mkdir -p "$board"
            echo "$board has been created"
            cp demo.txt "$board"
        fi
        ls -R "$board"
    done
}
```

## Worked example 4 — `triage` / `cleanup` (two fates + nested loop)
Pattern: walk a folder's contents; each item gets one of two fates — a **file**
is locked down (`chmod`), a **folder** is removed (`rm -r`). Started single-folder,
then wrapped in an outer loop so it cleans **multiple** folders in one run.
```bash
cleanup() {
    if [ "$#" -eq 0 ]; then echo "no target given"; return; fi
    for folder in "$@"
    do
        for target in "$folder"/*
        do
            if [ -f "$target" ]; then
                echo "detected a file $target"
                chmod 700 "$target"
                echo "$target can only be accessed by admin"
            elif [ -d "$target" ]; then
                echo "detected a folder $target"
                rm -r "$target"
                echo "$target has been removed"
            fi
        done
    done
}
```

## Gotchas learned the hard way
- **`$@` vs the loop variable** — inside the loop use the loop variable (the one current item). `"$@"` in a test passes many words at once → `[: too many arguments`.
- **A loop variable keeps its last value** after `done`.
- **A variable holds one value** — each assignment overwrites the last (no appending).

## More gotchas (today)
- **`folder/*` was never in the roadmap** — only `*.txt` in the current directory
  had been taught. Globbing into a *named* directory (`"$folder"/*`) was the
  missing piece that cost ~2 hours; once found, it unlocked the whole boss.
- **Empty glob survives as literal text** — `folder/*` on an empty folder hands the
  loop the literal string `folder/*` *once*; the `-f`/`-d` guards quietly absorb it.
- **Globs skip hidden/dotfiles** — `*` never matches `.bashrc` and friends. A real
  blind spot for a security tool, since dotfiles are where secrets and malware hide.
- **`"$@"/*` globs only the LAST argument** — for a single target folder, `"$1"/*`
  is the honest form.
- **Delete vs descend** — if the tool *removes* a folder, its depth is irrelevant
  (destroyed, never entered). Descending into *unknown* depth is `find`'s job, not
  a taller stack of loops.
