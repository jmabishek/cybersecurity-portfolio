# Cybersecurity Roadmap — Progress

**Last updated:** 21 May 2026
**Current hero:** 🦾 Iron Man (Linux & Bash)
**Current level:** Level 5 — Functions & Conditions
**Current focus:** Combination practice complete → Sub-Level 5.4 (File Conditions) next

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

## Current state — 17 May 2026

5.3 closed today. Bigger than the original roadmap scope — earned two extra concepts that weren't planned:

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
