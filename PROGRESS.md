# Progress Snapshot — Resume Point

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
