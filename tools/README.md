# 🛡️ suspicious_hunter.sh — Directory Threat Hunter

![Bash](https://img.shields.io/badge/Bash-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Status](https://img.shields.io/badge/status-working-brightgreen?style=for-the-badge)
![Focus](https://img.shields.io/badge/focus-threat%20hunting-blue?style=for-the-badge)
![MITRE ATT&CK](https://img.shields.io/badge/MITRE%20ATT%26CK-T1548.001-red?style=for-the-badge)

> Point it at a directory and it **hunts** — scanning for the files that signal danger on a real system, then writing a timestamped report to screen *and* disk.

A sharper sibling to `audit.sh`. Where `audit.sh` **describes** a folder, this one **interrogates** it. It answers the first question a SOC analyst asks walking up to an unfamiliar machine: *"Is anything in here dangerous?"*

---

## 🎯 The Hunt — five red flags

| # | What it looks for | Why it matters |
|---|---|---|
| 1 | **World-writable files** | Anyone on the box can modify them |
| 2 | **SUID / SGID binaries** | Run with the *owner's* or *group's* power, not yours |
| 3 | **Modified in the last 24h** | Fresh activity worth investigating |
| 4 | **Files larger than 10MB** | Unusual bulk — data dumps, exfil staging |
| 5 | **Root-owned + world-writable** | 🚧 *parked* — the sharpest check; pending the `-user` filter |

---

## ⚙️ Usage

```bash
sushunt <foldername>
```

- **Scope:** searches under `~` *by design* — a deliberate safety choice so the tool never wanders into root-owned system directories.
- **Output:** prints live to the terminal **and** saves a dated report (`30-06-26.txt`) via `tee`.
- **Gate:** if the folder doesn't exist, it says so and stops — no silent failure.

---

## 🧭 The build behind it

This wasn't a quick script. It was several deep sessions taking `find` apart from every angle — every flag, every variant, every combination, every dead end — until the behaviour was genuinely understood rather than copied. The notes below are that map.

### `find` — anatomy
```
find [WHERE] [WHAT TO MATCH] [WHAT TO DO]
```
Recursive by default. Multiple conditions are **AND**ed — all must be true to list a file. Flag **order doesn't matter** (proven by reordering and getting identical results).

### `-name` — matching by filename
Probed every shape: `'*.sh'`, `'*.log'`, `'*boss*'`, `'te*'`, `'t*'`, `'*1.*'`, bare names.
> **Always quote the wildcard** — `'*.sh'`, never `*.sh`. Unquoted, bash expands the `*` *before* `find` sees it → wrong results or `paths must precede expression`.
- Trap: gluing the next flag on with no space — `...-name '*boss*'2>/dev/null` — silently breaks.
- `-type d -name '*.sh'` finds **directories** named that way, not files.

### `-type` — what kind of thing
`-type f` = files · `-type d` = directories · `-type l` = symlinks.
A stray dash (`-type -f`) errors with `Unknown argument to -type`.

### `-mtime` / `-mmin` — time, where the sign is a timeline
`-mtime` = days · `-mmin` = minutes. Same sign logic:
- `-N` → **less** than N ago (recent side) — `-mtime -1` = last 24h
- `+N` → **more** than N ago (old side) — `-mtime +7` = older than a week
- `N` → exactly N (rarely useful)

> `-mtime -0` is a **dead command** — "less than zero days" matches nothing. `-mtime 0` and `-mtime -1` return effectively the same set.

Dead predicates that don't exist: `-time`, `-ntime`, `-msec`.
**Key:** `ls -lt` only *sorts* by time; `find -mtime` actually *filters*.

### `-size` — and the rounding trap that ate an hour
Units: `c`=bytes · `k`=KB · `M`=MB · `G`=GB. `+N` bigger than, `-N` smaller than.
> `find` rounds every file's size **up** to the next whole unit *before* comparing. A 1011-byte file (`0.00096M`) is treated as `1M`. So `-size -1M` ("less than 1") misses it, `-size +1M` ("more than 1") misses it, and only `-size -2M` catches it. **`-size -1M` matches only truly empty files.**

For exact small thresholds, use bytes: `-size -1048576c`. Rule: `k/M/G` round up; `c` is exact.

### `-perm` — the longest fight, the biggest payoff
Two modes, and confusing them costs the most time:
- `-perm NNNN` → **exactly** these bits, nothing else (almost never true)
- `-perm -NNNN` → **at least** these bits, whatever else is set ← what you want

> **The silent killer:** writing `-perm 4000` (no dash) for SUID matched *nothing* — which on a real box reads as a false "all clear," the most dangerous bug class in security work. `-perm -4000` (dash) fixed it.

**Bit meanings:** `r`=read `w`=write `x`=execute/enter · `o`=others `g`=group `u`=owner.
`-002` == `-o+w` → **world-writable**.
> `o+r` is *read* — nearly every file is world-readable, so searching `-o+r` floods the report with everything. "Writable by others" is `o+w`.

**Proved with dirty data:** `chmod 762 f/` → `find . -perm -002` caught `./f`. Then `chmod 760 f/` → gone. *That's* how you confirm a check works — feed it something bad and watch it catch exactly that.

### `2>/dev/null` & the redirection family
Every command has two output streams: **stdout** (results) and **stderr** (errors). `find` shouts `Permission denied` to stderr; `2>/dev/null` sends stream 2 into the void.
- `>` overwrite · `>>` append · `|` pipe to a command · `tee` write to screen **and** file at once.
> Never run `find /` without `sudo` — it floods the screen with hundreds of `/proc` and `/sys` permission-denied lines.

---

## 🔑 SUID / SGID — the concept behind the bits

Linux's core rule: a program runs with **your** permissions. SUID is a deliberate, temporary exception — a trusted program (like `passwd`) runs as its *owner* (root) just long enough to do one privileged job, then drops back. That's how `passwd` writes to root-owned `/etc/shadow` while you aren't root. SGID is the same idea at the group level.

**Why a hunter looks for them:** an attacker landing as a low-privilege user hunts for an exploitable SUID binary as a fast path to root. An unexpected SUID file in an odd place — say `/tmp` — is an instant red flag. Maps to **MITRE ATT&CK T1548.001 (Setuid and Setgid)**, and auditing these files sits on every Linux hardening checklist (e.g. CIS Benchmarks).

---

## 💡 Engineering discipline (the real lessons)

> **Empty output is not proof of correctness.** A half-fixed line and a fully-fixed line give the *same* empty result on clean data. You only prove a check works by feeding it something dirty.

> **Fix silent failures first.** A quiet false-negative (SUID finding nothing, `-mtime -0` finding nothing) is more dangerous than a loud error.

> **Scoping to `~` is a feature, not a limitation.** Staying out of system directories unless you mean to go there is exactly the instinct a security tool should have.

---

## 🚧 Roadmap

1. **Section 5 (root-owned + world-writable)** — needs two conditions on one line: the world-writable bit (`-perm -o+w`) **and** an owner filter (`-user root`). Without the owner filter it just duplicates Section 1, so it's parked until `-user` is formally learned.
2. **Drop the `cd`** — `cd`-ing inside the function moves the shell when the script is *sourced*. `find` can take the path directly; revisit to remove it.
