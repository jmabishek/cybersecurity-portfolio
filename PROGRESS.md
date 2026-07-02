## Level 7.3 — find: -user & negation · 2 July 2026

Concepts mastered (not yet written into the tool):
- `-user <name>` — filters files by owner. Matches a REGISTERED
  identity (in /etc/passwd), not a filename. Fails loudly and
  instantly if the account doesn't exist — unlike -name, which
  searches happily and returns nothing.
- `-nouser` — finds orphan files whose owner no longer exists
  (deleted account = dangling ownership pointer). Takes no argument.
- `! -user <name>` (or `-not -user`) — negation. Flips any test.
  "Everything NOT owned by this user." The real anomaly detector:
  an owner-scoped search is blind to an intruder's files, so you
  invert it to catch what isn't yours.

SOC relevance: ownership anomalies + baseline drift (file count
today vs. 3 days ago = incident window). Validated the detector by
planting a root-owned file with `sudo touch` and catching it.

Key insight I reasoned to myself: `-user abhi` can't catch an
attacker's files — only the inverted `! -user abhi` can.

STILL OPEN → suspicious_hunter.sh section 5 unwritten; cd not yet
dropped. No new concept needed — pure assembly next session.

Also flagged in audit.sh (for later polish): date substitution
repeated 6× (compute once into a variable); `ls "$file"/*` misses
hidden files (find sees them).
