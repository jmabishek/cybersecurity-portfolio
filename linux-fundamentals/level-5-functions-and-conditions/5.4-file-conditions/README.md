# 🦾 Level 5.4 — File Conditions & the `fcd` Mini-Boss

> **Hero:** Iron Man (Linux & Bash) · **Level 5:** Functions & Conditions — *complete* <br>
> **Date:** 24 May 2026 · **Status:** ✅ Sub-level cleared + capstone built

**In one line:** I learned the three "does this exist?" sensors — `-f`, `-d`, `-e` — then used them to build `fcd`, a function that finds a folder and walks you into it, debugging three very different real failures along the way.

---

## 🏢 The idea, in my own analogy

I picture the three file-test sensors as **security desks in an office building:**

> - **`-f` — is it a file?** The **first-floor biometric desk.** It only recognises its own people — the floor staff, the *files*. Show it a director and it draws a blank.
> - **`-d` — is it a directory?** The **digital department upstairs**, where the *directors* sit. It only waves through people with director credentials — the *folders*.
> - **`-e` — does it exist at all?** The **front desk / emergency squad.** They see *everyone*, every floor, even the levels nobody else knows about. They don't ask *what* you are — only *whether you're here.*

The one rule that falls straight out of it:

> **`-f` and `-d` each recognise only their own type. `-e` recognises everything.**

---

## 🔍 The three sensors

| Sensor | Asks | True when… |
|--------|------|------------|
| `-f` | *"Is this a regular file?"* | the name is a file |
| `-d` | *"Is this a directory?"* | the name is a folder |
| `-e` | *"Does this exist **at all**?"* | anything by that name is there |

All three drop into the same `if [ ... ]` shape I already knew — only the test inside the brackets changes:

```bash
if [ -d "myfolder" ]; then echo "folder exists"; else echo "no folder"; fi
```

**One distinction I locked in:** these are a **direct check**, not a **search**. `[ -e "myfolder" ]` asks *"is there a `myfolder` right **here**?"* — one glance at the current directory. It does **not** sweep the whole system. That sweep is a different weapon, `find`, parked for its own session.

---

## ⚔️ The mini-boss: building `fcd` from scratch

The Level 5 capstone: build a function that takes a name and, if it's a folder, walks you into it — while handling every way it could go wrong.

```bash
fcd() {
    if [ -z "$1" ]; then                 # no name given? ask, then bail
        echo "please give me a name"
        return
    fi
    if [ -e "$1" ]; then                 # does it exist here at all?
        if [ -d "$1" ]; then             # ...and is it a folder?
            cd "$1"                      # yes — go in
            echo "Found '$1' — moving you in now"
        else
            echo "$1 is not a directory" # exists, but it's a file
        fi
    else
        echo "$1 not found"              # nothing by that name
    fi
}
```

**Four situations, four honest answers:**

| You type | `fcd` says |
|----------|------------|
| `fcd` *(nothing)* | `please give me a name` |
| `fcd missing` | `missing not found` |
| `fcd notes.txt` | `notes.txt is not a directory` |
| `fcd logo` | `Found 'logo' — moving you in now` *(and you're inside)* |

I deliberately went one branch **beyond the brief.** The spec only asked for "found → `cd`, not found → say so." I split *"not found"* from *"found, but it's a file"* — so the function never lies about **why** it didn't move you.

---

## 🐛 Three bugs I hit — and how I read them

It didn't work first try. The interesting part is *how each failure announced itself*, because all three looked similar and had completely different causes.

**1 · The silent miss**
An early version checked `-e` but had **no `else`**. So when the name didn't exist, the function said… nothing. Total silence.
> **Lesson:** silence isn't "broken" — it's *a branch with no voice.* A path through your code with no `echo` runs quietly. Adding the `else` turned the silence into `not found`.

**2 · The location trap**
`fcd myfolder` kept returning `not found` — but `myfolder` definitely existed! The catch: I was standing in `~/temp`, while `myfolder` lived in `~/cybersecurity-portfolio`.
> **Lesson:** `fcd` checks the *current* directory only. *"Is it here?"* depends entirely on where **here** is. Running `pwd` before declaring "it failed" is the fix — and this is exactly why a *system-wide* search needs `find`, not `-e`.

**3 · The permission wall**
`fcd logo` returned `cd: logo: Permission denied`. My function wasn't broken at all — `-d` correctly saw that `logo` **is** a folder and tried to enter. The **operating system** blocked it, because `logo` had no execute permission. A quick `chmod` to restore the execute bit, and `fcd logo` walked right in.
> **Lesson:** a passing `-d` does **not** guarantee `cd` succeeds — *existence* and *permission* are two separate gates. (That second gate is Captain America's turf: Level 3 permissions, showing up live.)

---

## 📋 Quick reference

```bash
# The three file sensors
[ -f "$x" ]    # true if $x is a file
[ -d "$x" ]    # true if $x is a directory
[ -e "$x" ]    # true if $x exists (file OR directory)

# Guard pattern — bail early on empty input
[ -z "$1" ] && { echo "give me a name"; return; }
```

---

## 🎯 What this demonstrates

- **Defensive function design** — empty input, missing target, wrong-type target, and success each get a distinct, truthful message.
- **Precise failure reading** — telling apart a silent logic gap, an environment/location issue, and an OS permission block: three different root causes hiding behind one symptom ("it didn't work").
- **Cross-level thinking** — file tests (5.4) + functions and guards (5.1–5.2) + permissions (Level 3) combined into one working tool.

---

## 🔗 Connections forward

- **`find` (next):** the recursive, whole-system version of "does this exist?" — where `-e` checks one room, `find` searches the entire building.
- **🐍 Python (Bruce Banner):** the same checks return as `os.path.isfile()`, `os.path.isdir()`, `os.path.exists()` — same thinking, new syntax.
- **🛡️ Security (Captain America):** real scripts confirm a file exists *before* reading it; assuming a missing file is there is how scripts crash mid-investigation.

---

*Level 5 — Functions & Conditions: **complete.** Next stop → Level 6, Loops.*
