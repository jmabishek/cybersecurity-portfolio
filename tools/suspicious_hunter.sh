#!/bin/bash
# =====================================================================
#  suspicious_hunter.sh  —  Directory Threat Hunter
#  Author : abhi
#  Built  : June 2026, across several deep sessions hammering on `find`
#
#  Sibling of audit.sh. Where audit.sh DESCRIBES a folder (count + listing),
#  this one HUNTS it — point it at a directory and it scans for files that
#  signal danger on a real system.
#
#  Usage  : sushunt <foldername>
#  Scope  : searches under ~ on purpose — a safety choice, so the tool
#           never wanders into root-owned system directories.
#  Output : prints to the screen AND saves a dated report, via tee.
# =====================================================================

sushunt() {
{
    logfile=$(date +%d-%m-%y).txt
    local file="$1"
    local dpath=$(find ~ -type d -name "$file" 2>/dev/null | head -1)

    if [ -n "$dpath" ]; then
        cd "$dpath"

        echo "------- World-writable files -------"
        find . -perm -002 2>/dev/null
        echo "---------------------------------------------------------------"

        echo "------- SUID and SGID binaries -------"
        find . -perm -4000 2>/dev/null
        find . -perm -2000 2>/dev/null
        echo "---------------------------------------------------------------"

        echo "------- Files modified in the last 24 hours -------"
        find . -mtime -1 2>/dev/null
        echo "---------------------------------------------------------------"

        echo "------- Files larger than 10MB -------"
        find . -size +10M 2>/dev/null
        echo "---------------------------------------------------------------"

        echo ">>>>>> End of the report <<<<<<<"
    else
        echo "NO SUCH FOLDER EXIST"
    fi
} | tee "$logfile"
}

sushunt "$1"


# =====================================================================
#  FIELD LOG  —  everything learned building this tool
#  The program above runs. This block is commented out and just rides
#  along, so one file holds the tool AND the whole journey behind it.
#  This was not a quick build. It was days of probing find from every
#  angle — every flag, every variant, every combination, every dead end.
# =====================================================================
#
#  THE FIVE HUNTS (why each one is a red flag)
#  1. World-writable files .......... anyone on the box can modify them
#  2. SUID / SGID binaries .......... run with the OWNER's/GROUP's power
#  3. Modified in last 24h .......... fresh activity worth a look
#  4. Larger than 10MB .............. unusual bulk (dumps, exfil staging)
#  5. Root-owned + world-writable ... PARKED (see NEXT STEPS) — the
#                                     sharpest check; needs -user root
#
# ---------------------------------------------------------------------
#  THE find COMMAND — anatomy
# ---------------------------------------------------------------------
#  find [WHERE] [WHAT TO MATCH] [WHAT TO DO]
#  - Recursive by default — it walks every subfolder under WHERE.
#  - Multiple conditions are ANDed: all must be true to list a file.
#  - Flag ORDER does not matter — proven by running the same conditions
#    in different orders and getting identical results.
#
# ---------------------------------------------------------------------
#  -name  —  match by filename (the wildcard deep-dive)
# ---------------------------------------------------------------------
#  Tried every shape: '*.sh'  '*.txt'  '*.log'  '*boss*'  'te*' 'tes*'
#  't*'  '*t*'  '*1*'  '*1.*'  bare names like 'test', 'h', 'jj.sh'.
#  LESSON — ALWAYS QUOTE THE WILDCARD: '*.sh', not *.sh.
#    Unquoted, bash expands the * BEFORE find sees it -> wrong results
#    or "paths must precede expression" errors.
#  TRAP — gluing the next flag onto the pattern with no space:
#    ...-name '*boss*'2>/dev/null   <- silently breaks. Needs a space.
#  -type d -name '*.sh' finds DIRECTORIES named like that, not files.
#
# ---------------------------------------------------------------------
#  -type  —  what kind of thing
# ---------------------------------------------------------------------
#  -type f  = regular files      -type d  = directories
#  (-type l = symlinks, for later)
#  NOTE: "-type -f" with a stray dash errors — "Unknown argument to -type".
#
# ---------------------------------------------------------------------
#  -mtime / -mmin  —  filter by time (the sign is a timeline)
# ---------------------------------------------------------------------
#  -mtime is in DAYS, -mmin is in MINUTES. Same sign logic:
#     -N  = LESS than N ago (the recent side)   e.g. -mtime -1 = last 24h
#     +N  = MORE than N ago (the old side)       e.g. -mtime +7 = older than a week
#      N  = exactly N (rarely useful)
#  Walked the whole range: -mtime 0,1,-1,-2,-3,-5,-6,-12,-20,-25,-30,-35
#  and -mmin -1,12,50,60,-60,120,-120,-1200,-12000...
#  LESSON — -mtime -0 is a DEAD command: "less than zero days" = nothing.
#           Want the last 24h -> -mtime -1.
#  LESSON — -mtime 0 and -mtime -1 return effectively the same set.
#  DEAD PREDICATES (all error): -time, -ntime, -msec. They don't exist.
#  KEY — ls -lt only SORTS by time; find -mtime actually FILTERS. This
#        closed the "true 24h window" refinement parked from the audit tool.
#
# ---------------------------------------------------------------------
#  -size  —  filter by size (and the rounding trap that ate an hour)
# ---------------------------------------------------------------------
#  Units: c=bytes  k=KB  M=MB  G=GB.   +N = bigger than,  -N = smaller than.
#  Probed: +1M -1M +1G -1G +1k -1k +1c -1c +10M -10M +20M +70M +99G -0.2G...
#  THE TRAP — find rounds every file's size UP to the next whole unit
#    BEFORE comparing. boss1.sh is 1011 bytes = 0.00096M, but find treats
#    it as "1M". So:
#       -size -1M  -> "less than 1" -> rounds to 1 -> NOT less -> MISSED
#       -size +1M  -> "more than 1" -> rounds to 1 -> NOT more -> MISSED
#       -size -2M  -> "less than 2" -> rounds to 1 -> YES        -> SHOWN
#    That's exactly the behaviour I kept hitting. The file sits on the boundary.
#  CONSEQUENCE — "-size -1M" matches ONLY truly empty (0-byte) files.
#  FIX for exact small thresholds: use bytes -> -size -1048576c (no rounding).
#  RULE — k/M/G round UP (good for "big files over X"); c is exact.
#
# ---------------------------------------------------------------------
#  -perm  —  filter by permission (the longest fight, the biggest payoff)
# ---------------------------------------------------------------------
#  TWO MODES, and confusing them wastes the most time:
#     -perm  NNNN   = EXACTLY these bits and nothing else  (almost never true)
#     -perm -NNNN   = AT LEAST these bits, whatever else is set  (what you want)
#  THE SILENT KILLER — wrote "-perm 4000" (no dash) for SUID. It matched
#     NOTHING, which on a real box reads as a false "all clear" — the worst
#     kind of bug. "-perm -4000" (dash) fixed it. Same for -2000 (SGID).
#  Octal modes probed: 700, 777, 222, 644, 760, 761, 762,
#     and the special bits: -4000 (SUID) -2000 (SGID) -1000 (sticky)
#     -6000 -7000 (combos — returned nothing on this box, as expected).
#  Symbolic forms probed: -o+w -o+r -o+x  -u+r -u+w  -g+r -g+w  +x +r +w
#     and triples like -u+r+w+x, -o+r+w+x.
#  BIT MEANINGS (the part that actually matters):
#     r = read,  w = write,  x = execute/enter
#     o = others,  g = group,  u = owner(user)
#     -002  ==  -o+w  ->  WORLD-WRITABLE (anyone can change it)  <- section 1
#  LESSON — o+r is READ; nearly EVERY file is world-readable, so searching
#     -o+r floods the report with everything. "Writable by others" is o+w.
#  PROVED IT WITH DIRTY DATA — set a folder world-writable on purpose
#     (chmod 762 f/), ran find . -perm -002 -> it caught ./f. Then chmod 760 f/
#     and re-ran -> gone. That is how you confirm a check works: feed it
#     something bad and watch it catch exactly that.
#
# ---------------------------------------------------------------------
#  2>/dev/null  &  the redirection family
# ---------------------------------------------------------------------
#  Every command has 2 output streams: stdout (1, the results) and
#  stderr (2, the errors). find shouts "Permission denied" to stderr.
#     2>/dev/null  = send stream 2 into the void (a black hole file).
#  Family:
#     >   overwrite a file        >>  append to a file
#     |   pipe output to a COMMAND (e.g. ... | head -1, ... | wc -l)
#     tee write to screen AND file at the same time  <- used here
#  WARNING from the basics: never run find / without sudo — it floods
#  the screen with hundreds of /proc, /sys permission-denied lines.
#
# ---------------------------------------------------------------------
#  BUILDING BLOCKS reused from the audit.sh era
# ---------------------------------------------------------------------
#  $1 ................ first argument = the folder to hunt
#  date +%d-%m-%y .... builds the dated logfile name (watch % not $)
#  [ -n "$dpath" ] ... "string is not empty" = the folder-exists gate
#  function + call ... a defined function does NOTHING until called;
#                      sushunt "$1" at the bottom is what fires it.
#  source vs ./ ...... source runs in THIS shell (changes stick);
#                      ./script runs in a child shell (changes die).
#  local ............. only works inside a function.
#
# ---------------------------------------------------------------------
#  SUID / SGID — the concept behind the bits (the real prize)
# ---------------------------------------------------------------------
#  Linux's core rule: a program runs with YOUR permissions. SUID is a
#  deliberate, temporary exception — a trusted program (e.g. passwd) runs
#  as its OWNER (root) just long enough to do one privileged job, then
#  drops back. That's how passwd writes to root-owned /etc/shadow while
#  you are not root. SGID is the same idea at the GROUP level.
#  WHY A HUNTER LOOKS FOR THEM: an attacker landing as a low-privilege
#  user hunts for an exploitable SUID binary as a fast path to root. An
#  unexpected SUID file in an odd place (like /tmp) is an instant red flag.
#  Maps to MITRE ATT&CK  T1548.001 — Setuid and Setgid.  Auditing these
#  is on every Linux hardening checklist (e.g. CIS Benchmarks).
#
# ---------------------------------------------------------------------
#  REVELATIONS (the discipline, not just the syntax)
# ---------------------------------------------------------------------
#  * EMPTY OUTPUT IS NOT PROOF OF CORRECTNESS. A half-fixed line and a
#    fully-fixed line give the SAME empty result on clean data. You only
#    prove a check works by feeding it something dirty (see the chmod test).
#  * FIX SILENT FAILURES FIRST. A quiet false-negative (SUID finding
#    nothing, -mtime -0 finding nothing) is more dangerous than a loud error.
#  * QUOTE YOUR WILDCARDS, and mind the space before the next flag.
#  * SCOPING TO ~ IS A FEATURE. Staying out of system dirs unless you mean
#    to go there is exactly the instinct a security tool should have.
#
# ---------------------------------------------------------------------
#  KNOWN NEXT STEPS
# ---------------------------------------------------------------------
#  1. SECTION 5 (root-owned + world-writable). It needs TWO conditions on
#     one line: the world-writable bit (-perm -o+w) AND an owner filter
#     (-user root). Without the owner filter it is just a copy of section 1,
#     so it is parked until the -user predicate is formally learned.
#  2. The cd inside the function moves the shell when the script is sourced.
#     find can take the path directly; revisit to drop the cd entirely.
# =====================================================================
