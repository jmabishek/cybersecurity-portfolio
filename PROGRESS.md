# PROGRESS.md — Cybersecurity Portfolio

**Hero:** 🦾 Iron Man — Linux & Bash
**Last updated:** 21 June 2026

---

## Current status

✅ **Level 6 — Loops — COMPLETE**
🟡 **Level 7 — Scripts and Automation — in progress** (7.1–7.4 done; Level 8 next)

---

## Level 6 — Full completion record

### 6.1 — for loops ✅
**Date:** 29 May 2026

Pushed the for loop to its ceiling before touching while — deliberately. Built four programs: sweep (classify and create), org (sort into bins), seed (fan-out copy), triage (two-fate: chmod or rm). First nested for loop. Discovered `folder/*` glob — a gap in the roadmap that cost 2 hours and became the most useful find of the session. Lost 2 hours to a Ubuntu logout mid-session and rebuilt everything from memory.

Key discovery: the limits of `for` are exactly what create the need for `while`. Felt the gap before learning the solution.

---

### 6.2a — while basics ✅
**Date:** Early June 2026

Learned the three-part structure: initialize, test, heartbeat. Built five programs in sequence, adding one layer each time. Six bugs caught and root-caused independently — infinite loop, missing `$(( ))`, integer overflow, the lying echo (report ≠ reality), ghost variables from source, elif vs separate if.

Was not satisfied after completing the basics. Decided to go deeper before moving on.

---

### 6.2b — bash automation ✅
**Date:** Early June 2026

Self-directed session — not on the roadmap. Combined `for` and `while` in one script. Learned `[[ ]]` pattern matching, the critical quoting rule (quote left, never quote the pattern), the two different meanings of `*` (glob expansion vs shape test), `&&` vs `;`. Built cleanup tool twice — v1 with hardcoded protection, v2 with pattern protection and dry-run mode. Lost real files to a quoted pattern. Learned that permanently.

---

### 6.2c — while nested ✅
**Date:** 11 June 2026

All four nested loop combinations practiced: for/for, while/for, for/while, while/while. Adopted professional structure by reflex — loop walks, function works, they do not mix. Discovered that `[ ]` cannot call a function in a condition. Learned `${@:2}` for flexible argument lists. Built three boss fights: file sorter that physically moves files, monitoring sentinel with PRESENT/ALERT per round, flexible monitor with any rounds and any files as arguments. Identified three monitoring patterns: static, real-time, periodic.

---

### 6.3 — break and continue ✅
**Date:** 13–18 June 2026
**Sessions:** 3 days

Completed all 6 patterns:

| Pattern | Type | Description | Status |
|---|---|---|---|
| Pattern 2 | continue | skip protected files by exact name | ✅ |
| Pattern 1 | break | alarm on missing file | ✅ |
| Pattern 3 | break | alarm on critical content inside file | ✅ |
| Pattern 4 | continue | skip files by pattern (`*.sh`, `*.log`) | ✅ |
| Pattern 5 | break | flexible monitor using `$@` | ✅ |
| Pattern 6 | while true | always-on production monitor | ✅ |

Key discoveries this section:
- `continue` cannot live inside a function — only affects the loop directly around it
- `$0` is unreliable with `source` — use a manual variable for script identity
- `local` is function-only — scope is determined by where you define, not where you use
- `while true` is a design choice, not a mistake — one exit condition, runs forever
- `$@` makes scripts reusable — list comes from outside at runtime
- `! -f` flips any file condition
- `grep -q` previewed — full coverage in Text Processing (Hawkeye)

Five-question knowledge test passed at the end of the section — all foundations confirmed solid.

---

## Level 6 — Effort summary

- 6 sub-sessions across approximately 3 weeks
- 3 sessions self-directed — went deeper when not satisfied, not because told to
- 15+ programs built and stress-tested
- 10+ bugs caught independently, root-caused without being handed answers
- Real data loss event in 6.2b — learned the quoted pattern rule permanently
- Professional loop/function separation adopted by reflex
- Test environment principle applied independently throughout
- All boss fights cleared

---

## Level 7 — Scripts and Automation (in progress)

### 7.1 — script foundations ✅
**Date:** ~20 June 2026

Shebang line (`#!/bin/bash`), `chmod +x`, running with `./script.sh`, nano navigation, comment headers. The chef analogy for the shebang — the line that tells the system which interpreter should read the file.

---

### 7.2 — script arguments ✅
**Date:** 21 June 2026

`$1`, `$2` (positional), `$@` (all arguments), `$#` (count). Same `$1` as Level 6 functions — wider scope. The recipe/ingredients picture: one script, any input, never editing the file. Key catch: an empty string `""` still counts as an argument. Started fixing labels to match what the code actually does.

---

### 7.3 — making scripts permanent & global ✅
**Date:** 21 June 2026

Moved scripts into `~/bin`, learned how `$PATH` resolves a bare command name (first match wins, search the list only), `export PATH=$PATH:~/bin`. Proved temporary-vs-permanent by hand — added to PATH, closed the terminal, watched it vanish, then anchored it in `~/.bashrc` and watched it survive. Distinction that clicked: **PATH = reach, `.bashrc` = memory.** Used `source` (my `sb` alias) to reload without restarting, and learned why source persists changes (current shell) while `./execute` does not (child shell). `which` to verify the exact file a command resolves to — also the defender's check for PATH hijacking.

Bugs that taught: comma typo gives the same "command not found" as a real PATH miss; PATH holds folders, not files; folder names are convention, not law.

---

### 7.4 — mini boss: the audit tool ✅
**Date:** 21 June 2026

Built `audit.sh` from a bare spec, no code handed to me — a directory auditor that takes a target as `$1`, validates it exists (`-d`), and writes a dated report (file count + permission-rich, time-sorted listing) with a completion message. Runs two ways: `./audit.sh <dir>` and global `audit <dir>` from `~/bin`.

Hardest part wasn't the commands — it was the engineering. `local` is function-only; a function defined but never called does nothing (why `source` ran it but `./audit.sh` sat silent until I added `audit "$1"` myself). New workhorse commands picked up along the way: `wc -l`, `date +FORMAT`, `>` vs `>>`, `touch`.

Two refinements parked for next session: switch the first write to `>` so each run starts fresh, and use `find` for a true 24-hour filter instead of `ls -lt` (sorted, not filtered).

**Honest read on today:** the conceptual hard work was already done in Levels 5–6. Today's real gap was *breadth* — the everyday tooling commands (`date`, `wc`, `find`, redirection) that building tools leans on constantly. Noticed it mid-build.

---

## Level 7 — Effort summary (so far)

- First tool built end-to-end from a written spec with zero code handed over
- Most of the work was engineering, not syntax — function call-vs-define, scope, source-vs-execute
- Self-managed the teaching process: pushed for the full spec, kept the pace honest
- Identified own gap correctly: breadth of everyday commands, not difficulty
- Tool committed to the repo alongside its documentation

---

## Portfolio structure — current

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
    ├── level-6-loops/
    │   ├── 6.1-for-loops/
    │   ├── 6.2a-while-basics/
    │   ├── 6.2b-bash-automation/
    │   ├── 6.2c-while-nested/
    │   └── 6.3-break-and-continue/
    └── level-7-scripts/
        ├── 7.1-script-foundations/
        └── 7.2-arguments-permanence-and-audit-tool/
```

---

## Roadmap — overall

| # | Hero | Domain | Status |
|---|---|---|---|
| 1 | 🦾 Iron Man | Linux & Bash | Level 7 in progress (7.1–7.4 done) |
| 2 | 🕸️ Spider-Man | Networking | Locked |
| 3 | 🛡️ Captain America | Security Concepts | Locked |
| 4 | 🗺️ Nick Fury | MITRE ATT&CK | Locked |
| 5 | 📝 Hawkeye | Text Processing | Locked |
| 6 | 🐍 Bruce Banner | Python | Locked |
| 7 | 🐙 J.A.R.V.I.S | Git & GitHub | Active alongside Iron Man |
| 8 | 🗣️ Black Widow | English | Active alongside Iron Man |

---

## Next session

**Breadth & tooling practice session** — building several small, real, industry-style tools back to back to drill the everyday commands until they're muscle memory: `find`, `grep`, `cut`, `sort`, `uniq`, `head`/`tail`, `tr`, `xargs`, redirection. Fluency, not new hard concepts.

Then: **Level 8 — Process Management** (`ps`, `top`/`htop`, `kill`, background jobs).
