# Level 6 — Loops · Commands Learned

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

## Gotchas learned the hard way
- **`$@` vs the loop variable** — inside the loop use the loop variable (the one current item). `"$@"` in a test passes many words at once → `[: too many arguments`.
- **A loop variable keeps its last value** after `done`.
- **A variable holds one value** — each assignment overwrites the last (no appending).
