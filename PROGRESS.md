# PROGRESS.md — Cybersecurity Portfolio

**Hero:** 🦾 Iron Man — Linux & Bash
**Last updated:** 18 June 2026

---

## Current status

✅ **Level 6 — Loops — COMPLETE**
⏳ **Level 7 — Scripts and Automation — next**

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
    └── level-6-loops/
        ├── 6.1-for-loops/
        ├── 6.2a-while-basics/
        ├── 6.2b-bash-automation/
        ├── 6.2c-while-nested/
        └── 6.3-break-and-continue/
```

---

## Roadmap — overall

| # | Hero | Domain | Status |
|---|---|---|---|
| 1 | 🦾 Iron Man | Linux & Bash | Level 6 complete — Level 7 next |
| 2 | 🕸️ Spider-Man | Networking | Locked |
| 3 | 🛡️ Captain America | Security Concepts | Locked |
| 4 | 🗺️ Nick Fury | MITRE ATT&CK | Locked |
| 5 | 📝 Hawkeye | Text Processing | Locked |
| 6 | 🐍 Bruce Banner | Python | Locked |
| 7 | 🐙 J.A.R.V.I.S | Git & GitHub | Active alongside Iron Man |
| 8 | 🗣️ Black Widow | English | Active alongside Iron Man |

---

## Next session

**Level 7 — Scripts and Automation**
Shebang line, `chmod +x`, `./script.sh`, arguments `$1 $2`, making scripts permanent in `~/bin`.
