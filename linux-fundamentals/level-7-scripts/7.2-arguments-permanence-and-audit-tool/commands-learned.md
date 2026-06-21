# Level 7.2–7.4 — Arguments, Permanence & the Audit Tool · Commands Learned

**Date:** 21 June 2026
**Status:** ✅ Complete — script arguments, permanence/global access, and a working audit tool. Two refinements parked for next session (fresh-vs-append report, true 24h filter with `find`).

---

## 7.2 — SCRIPT ARGUMENTS

A script is a recipe. `$1`, `$2` are blank slots in it. The words typed after the script name are the ingredients. The recipe never changes; the ingredients do. This is why arguments exist: **one script, reused on any input, without ever opening the file again.**

### `$1` `$2` — positional arguments

```bash
#!/bin/bash
echo "Hello $1, you are $2 years old"
```
```bash
./greet.sh abhi 21      # Hello abhi, you are 21 years old
./greet.sh ravi 45      # Hello ravi, you are 45 years old
```
`$1` = first word after the command, `$2` = second. Same script, different values — the template holds, only the output changes.

### `$@` — all arguments at once
```bash
echo "given arguments: $@"
# ./args.sh a b c d   ->  given arguments: a b c d
```
Grabs every argument together, however many. Use when the count isn't known in advance.

### `$#` — count of arguments
```bash
echo "count: $#"
# ./args.sh 1 2 3 4   ->  count: 4
```
Counts how many arguments were passed (words split by spaces). The foundation of input validation — check the count before doing anything.

### Variations I went through
- **An empty string is still an argument.** `./args.sh "" hello` → `$1` is empty but it IS present; the quotes make it a real (empty) value, so `$@` and `$#` still count it. A common silent bug.
- Extra arguments beyond what the script reads are simply ignored.
- A variable as an argument: `as="ss"; ./args.sh "$as"` → `$1` becomes `ss`.
- **The label must match what the code does.** I had `echo "First argument: $@"` — but `$@` is ALL arguments. A lying label confuses whoever reads it later. Fixed every label to tell the truth.

---

## 7.3 — MAKING SCRIPTS PERMANENT & GLOBAL

Goal: run my script by name from anywhere, not just `./script` inside one folder.

### `echo $PATH` — the shell's list of toolboxes
```bash
echo $PATH
# /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:...
```
A bare command name is searched ONLY in these folders, left to right, first match wins — nowhere else. That's why `ls`, `cd`, `cat` work everywhere.

### `./script` vs bare `script`
`./greet.sh` = "it's right HERE in this folder, don't search." Bare `greet.sh` = "go search the PATH toolboxes." My current folder is never on PATH automatically.

### `mkdir ~/bin` + `mv` — a personal scripts folder
```bash
mkdir ~/bin
mv greet.sh ~/bin/
```
`~/bin` is my own folder — no `sudo` (I own my home). `bin` is convention, not law; `~/tools`, `~/asdf`, anything works.

### `export PATH=$PATH:~/bin` — add a folder to PATH
```bash
export PATH=$PATH:~/bin
greet.sh abhi 21        # now works from anywhere
```
Reads as: set PATH to (everything it already holds) + `:` + my folder. The `$PATH` in the middle PRESERVES every existing toolbox. Dropping it (`PATH=~/bin`) would WIPE the whole list and break `ls`, `cd`, everything.

**But this is temporary** — it lives only in the current terminal. Closed the terminal, reopened → `command not found`. Proven.

### `~/.bashrc` — making it permanent
Put the export line at the bottom of `~/.bashrc`. It runs automatically on every new terminal, so PATH re-adds `~/bin` on every startup. **PATH = reach** (works anywhere); **`.bashrc` = memory** (survives restart). Two separate wins.

### `source ~/.bashrc` (my `sb` alias) — reload without restarting
```bash
source ~/.bashrc
```
Re-runs `.bashrc` in the CURRENT shell, so changes apply immediately.

**source vs execute (key insight):**
- `source script` → runs in the CURRENT shell. Variables, functions, PATH changes persist.
- `./script` → runs in a CHILD shell that exits when done. Its changes die with it.

### `which` — verify where a command resolves
```bash
which greet.sh
# /home/abhi/bin/greet.sh
```
Walks the same PATH list and reports the exact file that would run. Security use: if `which ls` showed `/tmp/ls` instead of `/usr/bin/ls`, the command's been hijacked.

### Variations / bugs I went through
- **`greet,sh` vs `greet.sh`** — a comma typo gives `command not found`, the SAME message as a real PATH miss. Two causes look identical: not on PATH, or misspelled. Check both.
- **PATH holds FOLDERS, not files.** I added `~/bin1/testdemo.sh` (the file) to PATH — didn't work. PATH points at the folder; the shell looks INSIDE it.
- Folder names are arbitrary (`bin1`, `asdf` all worked) — convention vs mechanism.

---

## NEW COMMANDS LEARNED TODAY (used to build the tool)

### `wc -l` — count lines
```bash
ls | wc -l        # 16
```
`wc` = word count; `-l` = lines only. Piped after `ls`, it counts files. (Found it after `count` turned out not to be a real command.)

### `date +FORMAT` — formatted date
```bash
date +%d-%m-%y    # 21-06-26
```
Builds a date string for filenames. **Watch the `%`** — typing `$m` instead of `%m` gave `21--26` (the `$m` expanded to nothing). `%d` day, `%m` month, `%y` year.

### `>` and `>>` — output redirection
```bash
ls > file.txt     # overwrite: replaces contents
ls >> file.txt    # append: adds to the end
```
`>` starts fresh, `>>` piles on. `|` (pipe) sends output to a COMMAND; `>` sends it to a FILE. Different jobs.

### `touch` — create an empty file
```bash
touch report.txt
```

---

## THE FUNCTION TRAP (cost me the most time)

### `local` only works inside a function
```bash
local file="$1"   # bash: local: can only be used in a function
```
At top level this errors and leaves the variable empty. Fixing it meant wrapping the logic in a function — which created the next bug.

### A defined function does nothing until it's CALLED
```bash
# WRONG — function defined but never called. ./audit.sh does NOTHING.
audit() { ... }

# CORRECT — call it, passing the script's argument in
audit() { ... }
audit "$1"
```
A function is a recipe on the shelf — writing it doesn't cook the meal. **This is also why `source audit.sh` ran but `./audit.sh` stayed silent:** source loaded the function into my shell where I called it by hand; the executable defined it and exited without ever calling it. Fix = `audit "$1"` at the bottom (outside the function).

---

## TOOL BUILT TODAY — `audit.sh` (directory security auditor)

```bash
#!/bin/bash
audit() {
    local file="$1"
    if [ -d "$file" ]; then
        touch $(date +%d-%m-%y).txt
        echo "---->>>>> AUDIT REPORT OF $file <<<<<-----"      >> $(date +%d-%m-%y).txt
        echo "list of files and folders"                       >> $(date +%d-%m-%y).txt
        ls "$file"/* | wc -l                                   >> $(date +%d-%m-%y).txt
        echo "------ LIST OF FILES BY MODIFICATION TIME ------" >> $(date +%d-%m-%y).txt
        ls -lt "$file"/*                                       >> $(date +%d-%m-%y).txt
        echo "----- completed the audit of $file -----"
    else
        echo "*** $file not found ***"
    fi
}

audit "$1"
```

**What it does:** takes a directory as an argument, confirms it exists (`-d`), then writes a dated report with the file count and a permission-rich, time-sorted listing, and prints a completion message. Runs two ways: `./audit.sh <dir>` and — because it lives in `~/bin` — plain `audit <dir>` from anywhere.

**Pieces combined:** `$1` (7.2) · `-d` test (Level 5) · `ls -lt` permissions+time · `ls | wc -l` count · `date` filename · `>>` redirection · function + call (today).

---

## KEY RULES TO ALWAYS REMEMBER

- `$1 $2` grab arguments by position; `$@` grabs all; `$#` counts them.
- An empty string `""` still counts as an argument. Validate input.
- A bare command name is searched ONLY in `$PATH` folders, first match wins. `./` = "right here, don't search."
- PATH holds FOLDERS, never files.
- `export PATH=...` in a terminal is TEMPORARY. Put it in `~/.bashrc` to make it permanent.
- PATH = reach (anywhere); `.bashrc` = memory (survives restart).
- `source` runs in the current shell (changes stick); `./execute` runs in a child shell (changes die).
- `which cmd` shows the exact file a command resolves to — verify, don't assume.
- `local` is function-only.
- **A defined function does nothing until you CALL it.**
- `>` overwrites, `>>` appends. `|` pipes to a command, `>` redirects to a file.
- "command not found" = not on PATH OR misspelled. Check both.

---

## KNOWN REFINEMENTS FOR NEXT SESSION

1. The report uses `>>` (append), so repeated runs pile up. Change the FIRST write to `>` so each run starts fresh.
2. "Modified in the last 24 hours" is currently `ls -lt` (sorted, not filtered). For a true 24h window, use `find` with `-mtime` / `-mmin`.
