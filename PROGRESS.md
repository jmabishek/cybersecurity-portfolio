 Cybersecurity Roadmap — Progress


**Last updated:** 28 May 2026
**Current hero:** 🦾 Iron Man (Linux & Bash)
**Current level:** Level 6 — Loops
**Current focus:** `for`-loop fusion (Levels 1–5 folded into loops) → `while` / `break` next

---

## Progress at a glance

| Track | Progress | Estimate |
|---|---|---|
| Iron Man — Linux & Bash | 4 of 11 levels complete; Level 5 ~60% done | **~42%** |
| Overall Spine (8 heroes) | Hero 1 in progress; Git & English running alongside | **~5%** |

```
Iron Man (Linux & Bash)   ████████░░░░░░░░░░░░  ~42%
Overall Spine (8 heroes)  █░░░░░░░░░░░░░░░░░░░  ~5%
```

---

## The 8 Heroes — Roadmap Overview

| # | Hero | Domain | Status |
|---|---|---|---|
| 1 | 🦾 Iron Man | Linux & Bash | **In progress** (Level 5 of 11) |
| 2 | 🕸️ Spider-Man | Networking | Locked |
| 3 | 🛡️ Captain America | Security Concepts | Locked |
| 4 | 🗺️ Nick Fury | MITRE ATT&CK | Locked |
| 5 | 📝 Hawkeye | Text Processing | Locked |
| 6 | 🐍 Bruce Banner | Python | Locked |
| 7 | 🐙 J.A.R.V.I.S | Git & GitHub | Active alongside Iron Man |
| 8 | 🗣️ Black Widow | English | Active alongside Iron Man |

---

## Iron Man — Linux & Bash

### Completed levels
- ✅ **Level 1** — Terminal Basics
- ✅ **Level 2** — Files & Directories
- ✅ **Level 3** — Permissions
- ✅ **Level 4** — Variables & Environment

### Level 5 — Functions & Conditions *(in progress)*
- ✅ **5.1** — Functions (structure, positional args, `local`, command substitution, defaults)
- ✅ **5.2** — Conditions (`if`/`elif`/`else`, `=` / `!=`, `&&` / `||`, truth-value mechanic, block boundaries, precedence)
- ✅ **5.3** — Comparison Flags (`-eq -ne -gt -lt -ge -le`, `-z -n`; exit codes)
- ✅ **5.3 — Combination Practice** — functions × conditions × comparison flags *(21 May — detailed below)*
- ⏸ **5.4** — File Conditions (`-f`, `-d`, `-e`) ← **next**
- ⏸ **Level 5 Mini Boss** — build the `fcd` function from scratch

### Remaining levels in Iron Man
- Level 6 — Loops
- Level 7 — Scripts & Automation
- Level 8 — Process Management
- Level 9 — System Information
- Level 10 — Cron & Scheduling
- Level 11 — SSH & Remote Access

---

## Session Log

### 17 May 2026 — Sub-Level 5.3: Comparison Flags
- Closed 5.3, going beyond the planned scope with two earned concepts:
  - **Exit codes** as the real engine underneath `if` (the 5.2 "truth-value" was exit codes all along).
  - **Dead branches** and the distinction between *patching* code and *refactoring* it.
- **Mini boss:** access-gate script built across ~30 iterations, including a design-intent clarification step and two voluntary refactors (UX polish, then dead-branch removal).

### 21 May 2026 — Sub-Level 5.3: Combination Practice
**Goal:** turn the individual atoms from 5.1–5.3 into fluent, clean *combinations* — functions, conditions, and comparison flags working together.

**Breakthrough of the day:** learned multi-line entry at the terminal (the `>` continuation prompt) and the `nano` → `source` → run workflow. This removed a barrier that had forced everything onto single lines since 5.3.

**Patterns drilled — each built and edge-tested as its own function:**

| Pattern | Function built | Demonstrates |
|---|---|---|
| Guard clauses | `set_severity`, `check_access` | sequential `if`s + early `return` |
| Bounded range with `&&` | `check_score` | a numeric range checked in one `if` |
| Default values | `welcome` | `${1:-default}`, captured once into a `local` |
| Argument count | `pair` | `$#`, fail-fast when too few args |
| Combined empty + range guard | `check_level` | `-z` ∥ `-lt` ∥ `-gt` in one guard; order matters |
| Nested `if` | `access` | dependent precondition + inner routing |
| Boolean flag variable | `port_check` | remember state, decide once at the end |
| OR-of-AND split | `conn_risk` | two `elif` paths to the same result, no mixed operators |

*Also touched:* function-as-predicate and negation-via-`else`.

**Concepts deepened today:**
- **Exit codes** — `return 0` (success) vs `return 1` (failure) vs a bare `return`; why a rejection branch must report non-zero so a caller can detect it.
- **Numeric flags need real numbers** — feeding text to `-lt`/`-gt` triggers `integer expected`; the clean validation fix uses `[[ ]]` (deferred to 5.4+).
- **Assignment vs test rule** — assignment takes **no** spaces (`x="no"`), while `[ ]` **requires** spaces and the `$` (`[ "$x" = "yes" ]`). Two opposite rules that are easy to confuse.
- **Empty-unquoted-variable crash** — `[ $x = y ]` breaks when `x` is empty; always quote (`[ "$x" = y ]`).
- **Debugging technique** — when an error points at the closing `}`, removing it makes bash reveal the *real* (earlier) unclosed block — the reported line is where bash gave up, not where the bug is.
- **Meta-insight** — functions, conditions, flags, and guards are composable tools, not rival "correct ways." The bar is *correct **and** readable*; the skill is choosing the right shape for the requirement.

**Functions hand-written and tested this session (~12):** `check_user`, `greet`, `set_severity`, `check_access`, `check_age`, `check_score`, `welcome`, `pair`, `check_level`, `access`, `port_check`, `conn_risk`.

### Next session
- The **"functions talking to each other"** cluster: composition (one function calling another), function-as-predicate, command substitution `$(func)`, sequential `&&` chains, and predicate-then-classify.
- Then **5.4** (file conditions) → **Level 5 Mini Boss** (`fcd`) → **Level 6** (Loops).

---

## Portfolio structure

```
cybersecurity-portfolio/
├── PROGRESS.md
├── README.md
├── security-checklist.md
└── linux-fundamentals/
    ├── level-1-terminal-basics/
    ├── level-2-files-and-directories/
    ├── level-3-permissions/
    ├── level-4-variables-and-environment/
    └── level-5-functions-and-conditions/
        ├── 5.1-functions/
        ├── 5.2-conditions/
        ├── 5.3-comparison-flags/
        └── 5.3-combination-practice/   ← new (21 May)
```

---

## Effort summary

- **4 full Linux levels closed** — terminal basics through environment variables.
- **Level 5:** sub-levels 5.1, 5.2, and 5.3 closed, plus a full combination-practice phase.
- **~13 functions** hand-built and stress-tested across sessions; ~30-iteration debug trace documented on the 5.3 access-gate mini boss.
- **8 combination patterns** drilled to working code in a single session, each verified with deliberate edge-case tests (empty strings, out-of-range values, extra arguments, non-numeric input).
- **Quoting and variable discipline now reflexive** — verified under failure testing, not just happy-path runs.
- **Independent debugging** — diagnosed empty-variable crashes, exit-code mismatches, and unclosed-block syntax errors without being handed solutions.
- **Learning method** — experiment-first, analogy-anchored, one concept at a time, with every step explained back in plain English before moving on.# Progress Snapshot — Resume Point

## Status
Roadmap: Cybersecurity Spine (8 Heroes)
Currently on: Hero 1 — 🦾 Linux & Bash
Level 5 — Functions and Conditions
- Sub Level 5.1 (Functions): ✅ COMPLETE
- Sub Level 5.2 (Conditions / if-else): ⏳ NEXT
- Sub Level 5.3 (Comparison flags): pending
- Sub Level 5.4 (File conditions): pending
- Level 5 Mini Boss: build `fcd` function

## Concepts Already Owned (do NOT re-teach)
- Function structure: name() { body; }
- Define vs call
- Positional args: $1 $2 $3
- $@ (all args, any count from 0 to infinite)
- $# (arg count)
- Quoting at body level AND call-site level (two distinct layers)
- local variables — used by reflex now
- $() command substitution
- Snapshot vs live distinction (the strongest concept I own)
- ${1:-default} defaults — including $() inside defaults
- "" empty-arg trick

## My Learning Style — PLEASE FOLLOW
- ONE concept at a time, ONE command per response — no shopping lists
- Lane 1 (analogy + understanding) BEFORE Lane 2 (professional context) BEFORE practice
- Always explain a command in plain words BEFORE asking me to try it
- I learn by experimenting — give me hints, not solutions
- Verify understanding in my own words before moving on
- Connection bridges to other heroes (Spider-Man = Networking, Bruce Banner = Python, etc.)
- NO time pressure, NO invented urgency
- If I forgot something, praise the honesty and re-anchor — don't shame

## Reminders for Claude
- Do NOT skip sub-topics the spine lists, even if marked "you already know" — re-anchor them
- Flag snapshot vs live behavior explicitly whenever it appears
- Praise specifically (cite what I did), not generic "great job"
- Boss-fight pattern at end of each sub-level: small tasks first, then ONE combined task
- Verbal English checkpoint at end of each sub-level
- I appreciate the Lane 1 / Lane 2 structure — keep it

## What 5.2 Covers
- if [ condition ]; then ... ; else ... ; fi
- The shape and rhythm of conditional logic
- (Comparison flags -eq -gt -lt etc. come in 5.3, not 5.2 — don't mix them in)

Ready to start 5.2.

# Progress Tracker

**Last Updated:** 16 May 2026  
**Currently:** Hero 1 — 🦾 Linux & Bash → Sub Level 5.3 (starting)

## Roadmap — Cybersecurity Spine (8 Heroes)

1. 🦾 **Linux & Bash** (Iron Man) — *in progress*
2. 🕸️ Networking (Spider-Man) — pending
3. 🛡️ Security Concepts (Captain America) — pending
4. 🗺️ MITRE ATT&CK (Nick Fury) — pending
5. 📝 Text Processing (Hawkeye) — pending
6. 🐍 Python (Bruce Banner) — pending
7. 🐙 Git & GitHub (J.A.R.V.I.S) — pending
8. 🗣️ English (Black Widow) — pending

## Level 5 — Functions and Conditions

- [x] **5.1 Functions** — function structure, args, local, command substitution, defaults
- [x] **5.2 Conditions (if/else)** — basic shape, `=`/`!=`, one-branch, elif, `&&`/`||`, truth-value mechanic, block boundaries, precedence
- [ ] **5.3 Comparison Flags** — `-eq`, `-gt`, `-lt`, `-n`, `-z` *(next up)*
- [ ] **5.4 File Conditions** — `-f`, `-d`, `-e`
- [ ] **Level 5 Mini Boss** — build `fcd` function

## Previous Levels (Linux & Bash)

- [x] Level 1 — Terminal Basics
- [x] Level 2 — Files and Directories
- [x] Level 3 — Permissions
- [x] Level 4 — Variables and Environment

# Cybersecurity Roadmap — Progress

**Last updated:** 17 May 2026  
**Current hero:** 🦾 Iron Man (Linux & Bash)  
**Current level:** 5 — Functions and Conditions  
**Current sub-level:** 5.3 ✅ COMPLETE → consolidation practice before 5.4

---

## The 8 Heroes — Roadmap Overview

| # | Hero | Domain | Status |
|---|------|--------|--------|
| 1 | 🦾 Iron Man | Linux & Bash | **In progress** (Level 5 of 11) |
| 2 | 🕸️ Spider-Man | Networking | Locked |
| 3 | 🛡️ Captain America | Security Concepts | Locked |
| 4 | 🗺️ Nick Fury | MITRE ATT&CK | Locked |
| 5 | 📝 Hawkeye | Text Processing | Locked |
| 6 | 🐍 Bruce Banner | Python | Locked |
| 7 | 🐙 J.A.R.V.I.S | Git & GitHub | Active alongside Iron Man |
| 8 | 🗣️ Black Widow | English | Active alongside Iron Man |

---

## Iron Man — Linux & Bash Progress

### Completed levels
- ✅ **Level 1** — Terminal Basics
- ✅ **Level 2** — Files and Directories
- ✅ **Level 3** — Permissions
- ✅ **Level 4** — Variables and Environment

### Level 5 — Functions and Conditions (in progress)
- ✅ **5.1** — Functions
- ✅ **5.2** — Conditions (if / else / elif)
- ✅ **5.3** — Comparison Flags ← completed today
- ⏸ **5.4** — File Conditions (paused for consolidation practice)
- ⏸ **Level 5 Mini Boss** — Build `fcd` function from scratch

### Remaining levels in Iron Man
- Level 6 — Loops
- Level 7 — Scripts and Automation
- Level 8 — Process Management
- Level 9 — System Information
- Level 10 — Cron and Scheduling
- Level 11 — SSH and Remote Access

---

### Current state — 17 May 2026

- 5.3 closed today. Bigger than the original roadmap scope — earned two extra concepts that weren't planned:

- **Exit codes** as the real engine under `if` (the truth-value mechanic from 5.2 was exit codes all along)
- **Dead branches** and the refactoring-vs-patching distinction

Mini boss completed (access gate script) through ~30 iterations, including design-intent clarification with the tutor and two voluntary refactors (UX polish, then dead-branch removal).

### Tomorrow's focus — consolidation, not advancement

Practice the **structure** of 5.1 + 5.2 + 5.3 fluently before opening 5.4. Today's biggest realization: making code work is one skill; making code clean is another. The second one needs reps.

No new tools tomorrow. Just clean use of existing ones.

---

## Portfolio structure so far

```
cybersecurity-portfolio/
├── PROGRESS.md
├── README.md
├── security-checklist.md
└── linux-fundamentals/
    ├── level-1-terminal-basics/
    ├── level-2-files-and-directories/
    ├── level-3-permissions/
    ├── level-4-variables-and-environment/
    └── level-5-functions-and-conditions/
        ├── 5.1-functions/
        ├── 5.2-conditions/
        └── 5.3-comparison-flags/   ← new today
```

---

## Effort summary — Iron Man so far

- 4 full levels closed (terminal basics through environment variables)
- 3 of 4 sub-levels in Level 5 closed (5.1, 5.2, 5.3)
- 1 mini boss completed inside 5.3 (access gate, single-user design)
- ~30 iterations on the 5.3 boss script with full debug trace documented
- 5 levels documented with `commands-learned.md` + reflections format
- Quoting discipline now reflexive (verified under stress testing)
- Refactoring discipline introduced (dead-branch hunting + cascade simplification)

# PROGRESS — Resume Snapshot

**Saved:** 24 May 2026

# Resume point
- Hero 1 — 🦾 Iron Man (Linux & Bash) → **Level 5 (Functions & Conditions).**
- **Level 5 combination practice is FULLY CLOSED** — 5.1–5.3 atoms + Phase A (rearrangements) + Phase B (functions talking to each other).
- **Next: 5.4 — file conditions** (`-f`, `-d`, `-e`), then **Level 6 — Loops.**

---

## What we did today (24 May)
- Re-drilled all six **Phase A** patterns at **two arguments**.
- Ran a rapid-fire oral eval on all six Phase A patterns (my own analogies + real-world).
- Learned and practiced all six **Phase B** patterns ("functions talking to each other"), mostly by **extending my own login program** rather than starting fresh each time.

---

## Phase A — rearrangement patterns (OWN THESE — do not re-teach)
- **#3 Nested conditionals** — inner check only matters once the outer passed (precondition → refinement). *(Eval: clean pass — landed authentication-before-authorization.)*
- **#5 if–elif–else ladder (OR-of-AND split)** — mutually-exclusive cascade, FIRST match wins, rest skipped; several branches can land on the SAME outcome. *(Eval: my weakest — keep "many branches → one outcome" and "exactly one branch fires" in mind.)*
- **#7 Default parameter values** — `${1:-default}`; fill a fallback instead of rejecting.
- **#8 Argument-count / arity check** — `$#`; guards QUANTITY not content (an empty arg still counts).
- **#13 Boolean flag** — start a flag, several checks can flip it, decide ONCE at the end.
- **#14 Guard clause (empty + range)** — `[ -z "$x" ] || [ "$x" -lt LOW ] || [ "$x" -gt HIGH ]`; put `-z` FIRST so empty never hits the numeric tests; bail early.

## Phase B — functions talking to each other (NEW — own these)
**The unlock:** a function communicates on TWO channels — **exit code** (`return 0/1` = yes/no, read by `if`/`$?`) and **output** (`echo` = a value, captured by `$(...)`).
- **#2 Function-as-predicate** — `if my_func "$x"; then`; `[ ]` and functions are *both* just commands returning exit codes.
- **#4 One function calling another** — checker + actor (separation of concerns); args are handed over explicitly — each function has its own fresh `$1`/`$2`.
- **#6 Function in a compound condition** — `if predicate "$x" && [ test ]; then`; **no `;` before `&&`**, the only `;` is before `then`. (Untangled the old `validate_event` knot: push complex logic into a named predicate.)
- **#9 Command substitution** — `result=$(func)`; `echo` a VALUE (not `return` — return is number-only); capture a **clean bare token** so it stays reusable.
- **#12 Sequential `&&` chains** — `a && b && c`; the FLAT replacement for a tower of nested ifs; the idiom of build/deploy/CI pipelines. (Mechanic is obvious to me — the POINT is flattening nesting + knowing when to choose it over explicit ifs.)
- **#15 Predicate-then-classify** — classifier echoes a bare label (#9) + router branches on it (#5); separates "what is this?" from "what do I do about it?". (This is *why* bare tokens matter.)

---

## Concepts now owned (do NOT re-teach)
- **Two channels:** exit code (`return` / `if` / `$?`) vs output (`echo` / `$()`). `return` is number-only; for a value, echo + capture.
- `[ ]` and functions are both commands returning exit codes → they mix freely with `&&`.
- `&&` *inside* `if` = combine conditions; `&&` *between commands* = sequence with abort-on-first-failure.
- **Syntax:** space required before `]`; **no `;` before `&&`**; `;` before `then`; `{` opens a function body, `}` closes it.
- `=` is string compare, `-eq` is numeric (`"00"` ≠ `"0"` as strings, but `= 0` as numbers).
- Capture a clean **bare token** (not a sentence) so downstream code can branch on it.
- Declaring `local a/b` but then using `$1/$2` in the body is inconsistent — pick one; use self-documenting names.
- **bash ≠ Python here:** Python `return value` gives the value back; bash `return` is status only.

## Still parked for 5.4+
- Non-numeric input crashing `-eq`/`-lt`/`-gt` ("integer expected") — clean fix is `[[ ]]`, deferred to 5.4+.

---

## My learning style — PLEASE FOLLOW
- ONE concept at a time, ONE task per response. Grounded analogy for every NEW concept. Lead with a worked example and trace it.
- Lane 1 (analogy + understanding) → Lane 2 (professional context) → practice.
- I extend my EXISTING program from one-arg → two-arg rather than starting fresh (efficient; shows the delta). Only give a fresh scenario when you want to test transfer to a new context.
- I learn by experimenting — once I understand, give hints, not full solutions. Verify in my own words. Bridge to other heroes.
- NO invented urgency / deadlines; if time is short, do *less*, never faster. Praise specifically; if I forgot, re-anchor without shame.

## Reminders for Claude (lessons from today)
- For a pattern whose **mechanic I already own**, don't over-scaffold or hand me a hollow toy example — **lead with the POINT** (when & why to use it), and be honest that the mechanic is a combo of things I already know. *(This came up hard on #12.)*
- Confirm my design intent **before** grading my code.
- Flag any NEW operator/keyword before using it.
- Surface what's deferred honestly; don't claim "no gaps" without checking.
- Watch session length; offer clean pauses at milestones.

---

## Roadmap — the Spine (8 Heroes)
🦾 Linux & Bash → 🕸️ Networking → 🛡️ Security Concepts → 🗺️ MITRE ATT&CK → 📝 Text Processing → 🐍 Python → 🐙 Git & GitHub → 🗣️ English.
**Currently: Hero 1, Level 5 of 11 — next stop 5.4.** Git & English run alongside throughout.

## To resume in the new chat
Paste this, then we go straight to **5.4 — file conditions** (`-f` = is a file, `-d` = is a directory, `-e` = exists), then **Level 6 — Loops**. Teach 5.4 the same way: one concept, analogy, worked example, build-on practice.

### 24 May 2026 — Sub-Level 5.4 (File Conditions) + Level 5 Mini-Boss ✅
**Closed:** file conditions (`-f`, `-d`, `-e`) and the `fcd` capstone — Level 5 is done.

- **The three sensors** — proved each by hand: tested the empty case, created the target, retested, then ran the full cross-matrix (`-f` on a folder, `-d` on a file) to confirm each one fires only for its own type, while `-e` fires for anything.
- **Own analogy** — office-building security desks: `-f` = first-floor biometric (files only), `-d` = the directors' department (folders only), `-e` = front desk / emergency squad (sees everyone, every floor).
- **Mini-Boss — `fcd`** (built from scratch): empty-input guard (`-z` + `return`), existence check (`-e`), nested type check (`-d` → `cd` + confirm), plus separate honest messages for *file-not-folder* vs *not-found*. Went one branch beyond the brief.
- **Three real bugs, debugged independently:**
  1. *Silent miss* — a branch with no `echo` ran quietly; fixed by adding the `else`.
  2. *Location trap* — `fcd` checks the current directory only; the target lived elsewhere. Lesson: `pwd` before judging.
  3. *Permission wall* — a passing `-d` still failed `cd` (no execute permission); fixed with `chmod`. Existence and permission are separate gates (Level 3 callback).
- **New ground:** existence *check* vs *scan* — `-e` looks in one room; `find` (parked for later) searches the whole system.
- **Workflow shift:** moved to AI-assisted documentation — own the understanding and debugging myself, delegate the *arranging* of portfolio docs, then critically edit.


### 28 May 2026 — Level 6 (Loops): `for` deep-dive + two fusion mini-bosses ✅
**Goal:** open Level 6 with the `for` loop, then *fuse* it with every tool from Levels 1–5. By my own call: push `for` to its limits before touching `while`/`break`, so I'd feel the real *need* for them instead of learning them blind.

**Core concepts owned today:**
- **One item per pass** — `for x in "$@"` hands `x` a single argument each time around, in order, until the list runs out, then the loop ends.
- **A loop variable outlives the loop** — after `done` it still holds the final value (proved it live with `echo "$x"`).
- **Override, re-seen** — a variable is one box holding one value; each pass overwrites the last (watched `hello` get wiped by `apple`).
- **`$@` vs the loop variable vs `$#` (the breakthrough)** — `"$@"` is the whole *row* of arguments as separate items (NOT one string — that's `$*`, parked); the loop variable is the *one* I'm on; `$#` is the *count*. Reading `$@` in the body where I meant the current item caused a `[: too many arguments` storm — and that error was literally `$@` proving it expands to many separate words.
- **`source` vs `./` (bonus, from a bug)** — a sourced script runs in the current shell and sees its variables; `./` spawns a child that only inherits *exported* ones. Owned the concept; cut a ceremonial `export` once we saw it did nothing for an in-shell function.

**Mini-bosses cleared — 2:**
1. **Subsystem Sweep (`sweep`)** — loop over any number of names; classify each as existing-dir / existing-file / missing; create the missing ones; guard zero args. Fused `for` + `if`/`elif`/`else` + `-d`/`-f`/`-e` + `$#`/`-eq` + `mkdir`.
2. **Sorting Bay (`org`)** — sort a mixed list of files and folders into two bins, with a >5-item heads-up and a no-args guard. Fused `for` + conditions + `-f`/`-d` + `mv` + `mkdir -p` + variables + `ls` + navigation.

**Debugging & testing:**
- **~25-iteration grind** on `sweep`, reading each error and fixing it solo (misplaced `fi`/`done`, `[-z` spacing, `for "$@"` "not a valid identifier", and finally the `$@`-vs-loop-variable bug).
- **Same bug class, twice** — the morning's `enemy3` bug (loop advances `me`, body reads `$target`) reappeared as `$@` vs `test1`; recognized the shape the second time.
- **Stress-tested like a skeptic** — 13 args at once, existing + new mixed (the `964`-in-a-row case), decimals, leading zeros, re-runs to confirm "created" flips to "online".
- **Hardest part (honest):** the function failing *silently* on non-existent input — no error, no output, nothing to grab. Took a while to spot it was skipping quietly; lesson learned about announcing skips.
- **Resilience:** lost ~2 hours to an Ubuntu logout mid-session and **rebuilt the whole thing from memory.**

**Working with the AI tutor — mistakes caught & corrected:**
- Tutor over-ran a `source`/`./` tangent past its usefulness — I called it and we cut it.
- Tutor over-built an unfamiliar "backup rotation" scenario with vague wording ("that spot," "rotate aside") — I flagged it as straying; rescoped to a familiar sorter.
- Tutor's spec told me to `cd` into a bin and `ls` it; I'd already thought of the cleaner `ls <bin>` (no `cd`) but suppressed it to follow the spec — then surfaced that the instruction itself was the inefficiency. Takeaway: follow the spec by default, but voice a better way when I see one.

**What hit hardest (honest):** realizing *where* a `for` loop is the right shape and where it isn't — its limits are exactly what create the need for `while` and `break`. I want those tools now because I felt the gap, not because a tutorial said so.

**Refinements banked for next time:** `mkdir -p` already does the create-if-missing check (no `if -d` needed); pull config like bin names into variables and use them throughout; capture `start="$(pwd)"` and `cd "$start"` for a portable return instead of a hardcoded path; announce skipped items.

**Next session:**
- More `for`-loop fusion (bring in `cp`, `rm`, permissions, `pwd`/`cd`), then open **`while`** and **`break`/`continue`** — meeting them as the answer to the limits I hit today.
- Wire the variable-config habit into the build from the start, not after.

## 2026-05-29 — Level 6 (Loops): for-loop fusion complete

### Practice done today
- **Mini-Boss #3 `seed`** (fan-out pattern): copy one starter file into many
  folders. Fused `cp` into a for-loop. Fixed the missing-file guard by moving it
  to the TOP (fail-fast), instead of letting it fail per-folder inside the loop.
- **Mini-Boss #4 `triage` / `cleanup`** (two-fate pattern): walk a folder's
  contents — each item either locked down (`chmod`) or removed (`rm`).
  First fusion of `chmod` + `rm` into a loop. Extended it to multiple folders
  with a nested loop.

### Key insights locked in
- **`folder/*`** — a glob can be rooted at ANY named path, not just the current
  directory. Matches come back WITH the path prefix (`testzone/25`), which is
  exactly why `chmod`/`rm` could act on them. (Real roadmap gap — only `*.txt`
  in the current dir had been taught.)
- **Fail-fast guards** — a "whole job can't run" check (no args, missing source)
  belongs ONCE at the top, before the loop — not inside it firing per item.
- **Nested loops** — `for` inside `for`. Each deeper level points at the
  level-above's variable + `/*`: `"$@"` → `"$folder"/*` → `"$sub"/*`.
  Chain the loop variables downward.
- **`"$@"/*` only globs the LAST argument** → for a single target folder,
  use `"$1"/*`.
- **Delete vs descend** — if the tool removes folders, depth is irrelevant (the
  folder is destroyed, never entered). Descending into UNKNOWN depth is `find`'s
  job, not a taller stack of loops.
- **Empty glob survives as literal text** — `emptyfolder/*` with nothing inside
  hands the loop the literal string once; `-f`/`-d` guards neutralize it.
- **Globs skip hidden/dotfiles** — `*` never matches `.bashrc` etc.
  Security blind spot (dotfiles are where secrets and malware hide).

### Newly owned
- `folder/*` / `"$1"/*` / `"$folder"/*` — glob into a named directory
- nested `for` loops (loop-variable chaining)
- `cp`, `chmod`, `rm` fused into loops

### Status
- For-loop MECHANICS: complete. Ready for `while`.
- Patterns banked this arc: sweep (classify-create), org (sort-relocate),
  seed (fan-out), triage (two-fate).

### Parked / next
- **`$(())` arithmetic** — prerequisite for `while` counters (`x=$((x+1))`).
  Pick up as `while` needs it.
- `find` (unknown-depth descent), `nullglob`/`dotglob`, `?` and `[abc]` glob
  classes — later.

### Next stop
🦾 Level 6.2 — `while` loops (condition-driven, not list-driven).

===========================================
PROGRESS LOG — LINUX & BASH  (Iron Man / Foundation)
Covers: Day 1 (Level 6.2 while loops + combos)  →  Day 2 (for vs while, [[ ]] patterns)
===========================================


############################################################
# DAY 1 — Level 6 (Loops) → 6.2 while loops + combos w/ Levels 1–5
############################################################

--- CONCEPTS LEARNED ---
1.  while loop: initialize → test condition → change (heartbeat) → done
2.  Heartbeat line (i=$((i+1))) eventually makes the condition false and stops the loop. Forget it = infinite loop.
3.  $(( )) = arithmetic ("math goggles"). Bash treats things as TEXT unless wrapped in $(( )). i=i+1 stores "i+1"; i=$((i+1)) does the math. (No $ on vars inside.)
4.  Integer overflow: counter maxes at ~9.2 quintillion (2^63-1), then rolls into NEGATIVE numbers.
5.  Infinite loop: bad/missing heartbeat runs forever. Ctrl+C is the emergency brake.
6.  Patterns: count up, count down, step by N, sentinel (loop until a value flips), while true + break (previewed), while read line < file (previewed — the big one for logs).
7.  Variable-in-name: file$i / box$i builds a different name each pass.
8.  Two loops in a row need a fresh/reset counter, or the second never runs.
9.  ACTION vs REPORT are separate. A failing command does NOT stop the next line. echo "done" prints whether or not the real command worked. Gate it: if cmd; then echo done; fi
10. Ghost variables: `source script.sh` runs in your CURRENT shell, so variables survive across runs. A typo ($b) grabbed a stale value (5073). Fresh shell or `unset` clears it. `./script.sh` runs in a NEW shell = no ghosts (Level 7).
11. elif vs separate ifs: elif picks exactly ONE branch and skips the rest; two standalone ifs each fire independently.
12. && in a while condition stops at the SHORTER range.
13. Two loops can be merged into ONE (efficiency) with shared counters.
14. -f (is a file), -d (is a directory) tests used inside loops.
15. Quoting in tests: always "$var". Spaces required inside [ ].

--- QUESTIONS I EXPLORED ---
- What is $(( )) and why? → arithmetic expansion.
- Why did huge multiplications go negative? → integer overflow / rollover.
- Why did "deleted file471" print when rm failed? → echo is unconditional; nothing gated it.
- Why did the folder message print "5073" then later blank? → ghost variable from source; died in a fresh shell.
- Why was break mentioned early? → it's formally sub-level 6.3.
- elif vs separate if → discovered by running both.

--- PROGRAMS I WROTE (working) ---
# 1. while + step (odds 1..55)
x=1; while [ "$x" -le "55" ]; do echo "$x"; x=$((x + 2)); done

# 2. Foundation Layer: create files then folders
x=0
while [ "$x" -le "5" ]; do touch file"$x".txt; echo "txt file $x created"; x=$((x+1)); done
d=0
while [ "$d" -le "5" ]; do mkdir -p box"$d"; echo "folder $d created"; d=$((d+1)); done

# 3. Combined removal — two SEPARATE ifs (both fire each pass)
x=0; d=0
while [ "$x" -le "5" ] && [ "$d" -le "5" ]; do
    if [ -f "file$x.txt" ]; then echo "file$x.txt detected"; rm -r file"$x".txt; echo "deleted file$x.txt"; fi
    if [ -d "box$d" ]; then echo "found box$d"; rm -r "box$d"; echo "box$d removed"; fi
    d=$((d+1)); x=$((x+1))
done

--- PITFALLS I HIT MYSELF (★ = mine) ---
★ infinite loop / missing heartbeat
★ forgetting $(( )) for math
★ integer overflow
★ the lying echo (report != reality)
★ ghost variables from source
★ elif vs separate ifs


############################################################
# DAY 2 — for vs while, cleanup tool, [[ ]] pattern matching
############################################################

--- CONCEPTS LEARNED ---
1.  for vs while (the core distinction):
      for   = walk a KNOWN list (files/IPs/users); the list controls stopping → no infinite-loop risk, no heartbeat needed.
      while = repeat while a CONDITION holds; I manage the stop myself.
      MY RULE: "Use for when I already have the list. Use while when I'm watching a condition that changes."
2.  for needs no counter/heartbeat — the list ends the loop (contrast with Day 1's while).
3.  Off-by-one: where the counter STARTS + which test (-le vs -lt) decides the count. Started n=1 with -le → printed exactly N and read "attempt 1..N".
4.  Variable scope (lived it): inside a loop the LOOP variable holds each item. $@ pointed at nothing, $any was the function's PRIVATE local (invisible outside), $abhi (the loop var) was the right thing to pass → fixed "rm: missing operand".
5.  [[ ]] double brackets = a TRUE/FALSE test. Works in if, elif, AND while. Smarter + safer than single [ ] (handles spaces/empty, does pattern matching).
6.  == inside [[ ]] = "matches". With a pattern on the right it matches the SHAPE, not exact text.
7.  * wildcard in a pattern = "any run of characters". *.sh = "ends in .sh". Quote the LEFT side; leave the pattern UNQUOTED.
8.  THE BIG INSIGHT — two different *s:
      `for f in *`            → shell GLOB expansion: builds a REAL list of files from disk BEFORE the loop runs. (reaches into the folder)
      `[[ "$f" == *.sh ]]`   → PATTERN test: checks the SHAPE of one string already in hand; never touches the disk.
9.  Other wildcards exist: ? (one char), [abc] (one from a set), [a-z] (one in a range). Learn when a project needs them.

--- QUESTIONS I EXPLORED ---
- Learn [[ ]] / * / find now or later? → [[ ]] & patterns: learned in context (the best way), basically done. find: NOT a named level in my roadmap (a gap), high value for security → do it as a focused next session.
- Are [[ ]] only used in if? → No: if, elif, while — anywhere a yes/no is needed.
- Is the * in `for f in *` the same as in `*.sh`? → No — glob expansion vs shape test (see #8).

--- PROGRAMS I WROTE (working) ---
# 1. repeat — 2 args + while + counter (off-by-one fixed)
repeat() {
  local word="$1"; local times="$2"; n=1
  while [ "$n" -le "$times" ]; do
    echo "printing $word - at attempt $n - out of $times"
    n=$((n+1))
  done
}

# 2. Cleanup tool — for + function + if/elif + -f / -d + args
repeat() {
  local any="$1"
  if [ "$any" = "ss.sh" ] || [ "$any" = "rr.sh" ] || [ "$any" = "ll.sh" ] || [ "$any" = "jj.sh" ]; then
      echo "found shell file $any"
  elif [ -f "$any" ]; then
      echo "found file - $any"; rm -r "$any"; echo "file $any deleted"
  elif [ -d "$any" ]; then
      echo "found folder - $any"; rm -r "$any"; echo "$any folder deleted"
  fi
}
for abhi in *; do repeat "$abhi"; done

--- PITFALLS I HIT MYSELF (★ = mine) ---
★ off-by-one (counter started at 0 → printed N+1, and "attempt 0" looked wrong)
★ variable scope ($@ / $any vs the loop var $abhi) → "rm: missing operand"
★ DESTRUCTIVE loop with no safety — accidentally deleted shared/ and vault/. Lesson: never let a delete loop run blind.


############################################################
# CONSOLIDATED — WHERE I AM & NEXT UP
############################################################

--- BOSSES ---
[x] Builder / Stocker / Foundation Layer / Inspector / Teardown / Combined loop (Day 1)
[ ] Locksmith    - chmod 600 in a loop + ls -l verify
[ ] Vault Keeper - loop + function routing: cp->vault/ chmod600, mv->shared/ chmod644, else leave

--- NEXT UP ---
- Answer the open question: would `[[ "$f" == *.sh ]]` say YES if $f="hello.sh" but no such file exists? (tests glob-vs-pattern understanding)
- Upgrade the cleanup tool: replace the 4-name whitelist with a pattern → [[ "$any" == *.sh ]]
- Make the cleanup tool SAFE: a dry-run that prints "would delete X" before deleting anything
- 6.3 break / continue, then Level 6 mini-boss
- Level 7: Scripts (shebang #!/bin/bash, chmod +x, ./script.sh, $1 $2)
- find — focused session (security value; bridge into Text Processing / Hawkeye)
- Other wildcards: ?  [abc]  [a-z]

--- RESOURCES (Lane 2, for later) ---
mywiki.wooledge.org → BashGuide, BashPitfalls, BashFAQ

===========================================

# Progress Snapshot — 4 June 2026

## Session focus
Level 6 — Loops (nested loops, pattern matching, log scanner)

---

## Concepts learned today

### 1. [[ ]] and pattern matching
- [[ ]] is the upgraded test — handles patterns, safer than [ ]
- == inside [[ ]] means "matches"
- * wildcard means "any run of characters"
- Rule: quote the LEFT side, never quote the RIGHT side pattern
- [[ "$f" == *.sh ]] → works
- [[ "$f" == "*.sh" ]] → breaks — * becomes literal

### 2. && vs ; (the one that cost files before)
- ; runs the next command no matter what
- && runs the next command only if previous succeeded
- || runs the next command only if previous failed
- Dangerous: [[ "$f" == *.sh ]]; rm "$f" → deletes everything
- Safe: [[ "$f" == *.sh ]] && rm "$f" → deletes only matches

### 3. for + while together in one script
- for walks a known list — list controls the stop
- while repeats while condition holds — you control the stop
- for can never be infinite — list runs out
- while can be infinite if heartbeat is missing

### 4. Nested loops — all four combinations
- for inside for → check every user on every server
- while inside for → deep scan each item in a fixed list
- for inside while → continuous monitoring of a known list
- while inside while → condition-driven depth (not practiced today)

### 5. for inside while — professional monitoring pattern
- while = keeps running (the monitor)
- for inside = checks each server/file every round
- Real version uses sleep 60 between rounds
- Used in SOC for continuous server and log monitoring

### 6. When to choose which nesting
- for inside while = monitoring a set at time intervals
- while inside for = deep scanning each item in a fixed list once

---

## Programs built today

### Simple nested loop (for inside for)
3 servers × 3 users = 9 output lines
Proved: outer items × inner items = total iterations

### for + while together
for walked 3 log files
while ran 3 scan passes per file
Total: 9 pass lines + 3 headers = 12 lines

### Log scanner — kk.sh (self-built, extended beyond assignment)
- for loop walks every item in current directory
- if -d catches and skips directories
- else handles files only
- while runs one scan pass per file
- [[ ]] with patterns classifies: error* = CRITICAL, system* = NORMAL
- Non-log files reported correctly
- Directories identified and excluded using if -d / else structure

---

## Key discoveries made independently
- $(ls | wc -l) for counting files — learned from online, applied correctly
- $() vs = for command substitution — figured out through debugging
- local only works inside functions — hit this error, understood why
- $@ vs * — $@ needs arguments passed in, * uses current directory
- Space in list items splits them — "server 4" became two items
- count=$(ls | wc -l) made while run 7 times — self-diagnosed, fixed to count=1
- return stops entire script outside a function — switched to if/else structure

---

## Professional insight developed today
Three monitoring patterns identified independently:
- Static log → read once, move on
- Real-time log → infinite loop, keep watching  
- Periodic log → timed loop, check for changes

---

## Tomorrow
- Refactor kk.sh → move scan logic into a function, loop just calls it
- break and continue inside loops

# Cybersecurity Roadmap — Progress

**Last updated:** 11 June 2026
**Current hero:** 🦾 Iron Man (Linux & Bash)
**Current level:** Level 6 — Loops
**Current focus:** 6.3 — In progress (Pattern 2 done, Day 2)

---

## The 8 Heroes — Roadmap Overview

| # | Hero | Domain | Status |
|---|------|--------|--------|
| 1 | 🦾 Iron Man | Linux & Bash | **In progress** (Level 6 of 11) |
| 2 | 🕸️ Spider-Man | Networking | Locked |
| 3 | 🛡️ Captain America | Security Concepts | Locked |
| 4 | 🗺️ Nick Fury | MITRE ATT&CK | Locked |
| 5 | 📝 Hawkeye | Text Processing | Locked |
| 6 | 🐍 Bruce Banner | Python | Locked |
| 7 | 🐙 J.A.R.V.I.S | Git & GitHub | Active alongside Iron Man |
| 8 | 🗣️ Black Widow | English | Active alongside Iron Man |

---

## Iron Man — Linux & Bash Progress

### Completed levels
- ✅ **Level 1** — Terminal Basics
- ✅ **Level 2** — Files and Directories
- ✅ **Level 3** — Permissions
- ✅ **Level 4** — Variables and Environment
- ✅ **Level 5** — Functions and Conditions

### Level 6 — Loops (in progress)

- ✅ **6.1** — for loops: sweep, org, seed, triage — pushed to ceiling
- ✅ **6.2a** — while basics: counter, foundation layer, inspector,
  teardown, repeat() — 6 bugs caught independently
- ✅ **6.2b** — bash automation: [[ ]] pattern matching, && vs ;,
  dry-run safety, cleanup tool v1 and v2 — real data loss lesson
- ✅ **6.2c** — while nested: all four nested combinations, function
  refactor, ${@:2} flexible arguments, 3 boss fights cleared
- ⏳ **6.3** — break and continue ← next

### Remaining levels in Iron Man
- Level 7 — Scripts and Automation
- Level 8 — Process Management
- Level 9 — System Information
- Level 10 — Cron and Scheduling
- Level 11 — SSH and Remote Access

---

## Level 6 — Full Session Log

### 6.1 — for loops (29 May 2026)
Pushed the for loop to its limits before touching while. Built sweep
(classify and create), org (sort into bins), seed (fan-out copy), and
triage (two-fate: chmod or rm). First nested for loop. Discovered
folder/* glob into named directory — a roadmap gap that cost 2 hours
and became the most useful discovery of the session. Deliberately hit
the ceiling of for so the need for while was felt, not memorized.

### 6.2a — while basics (Early June 2026)
Learned the three-part structure: initialize, test, heartbeat. Built
five programs in sequence adding one layer each time. Six bugs caught
independently — infinite loop, missing $(( )), integer overflow, the
lying echo, ghost variables, elif vs separate if. Was not satisfied
after completing the basics. Made the decision to go deeper before
moving forward.

### 6.2b — bash automation (Early June 2026)
Self-directed deeper session. Combined for and while in one script.
Learned [[ ]] pattern matching, the critical quoting rule, the two
different meanings of *, && vs ; distinction. Built cleanup tool twice
— v1 with hardcoded protection, v2 with pattern protection and dry-run.
Lost real files to a quoted pattern — learned permanently. This session
was not on the roadmap. I created it because I was not satisfied.

### 6.2c — while nested (11 June 2026)
All four nested loop combinations practiced. Moved to professional
structure: loop walks, function works, they do not mix. Discovered that
[ ] cannot call a function in an if — no brackets on function calls.
Learned ${@:2} for flexible argument lists. Built three boss fights:
file sorter that physically moves files, monitoring sentinel with
PRESENT/ALERT per round, flexible monitor that takes any rounds and
any files as arguments. Identified three monitoring patterns: static,
real-time, periodic. Applied test environment principle independently
throughout.

---

## Effort summary — Level 6

- 4 sub-sessions across approximately 2.5 weeks
- 3 self-directed — went deeper when not satisfied, not because told to
- ~15 programs built and stress-tested
- 10+ bugs caught independently, root-caused without being handed answers
- Real data loss event — learned the quoted pattern rule permanently
- Professional structure (loop/function separation) adopted by reflex
- Test environment principle applied independently
- 3 boss fights cleared in 6.2c
- Flexible monitoring tool built: any rounds, any files, one script

---

## Portfolio structure

```
cybersecurity-portfolio/
├── PROGRESS.md
├── README.md
├── security-checklist.md
└── linux-fundamentals/
    ├── level-1-terminal-basics/
    ├── level-2-files-and-directories/
    ├── level-3-permissions/
    ├── level-4-variables-and-environment/
    ├── level-5-functions-and-conditions/
    │   ├── 5.1-functions/
    │   ├── 5.2-conditions/
    │   ├── 5.3-comparison-flags/
    │   └── 5.4-file-conditions/
    └── level-6-loops/
        ├── 6.1-for-loops/
        ├── 6.2a-while-basics/
        ├── 6.2b-bash-automation/
        └── 6.2c-while-nested/
```
