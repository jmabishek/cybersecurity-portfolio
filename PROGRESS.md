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
