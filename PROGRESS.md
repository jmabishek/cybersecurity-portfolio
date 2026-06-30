## Level 7 — Scripts & Automation ✅ COMPLETE
- 7.1 script foundations (shebang, chmod +x, nano)
- 7.2–7.4 arguments ($1 $@ $#), PATH permanence, source vs ./
- Tool built: audit.sh (directory auditor)

## Practice — find Mastery & suspicious_hunter.sh 🟡 WIP
Deep find practice across several sessions + a 4-day gap.
- find solid: -name (quote wildcards), -type f/d/l, -mtime/-mmin
  (sign = timeline, -1 = last 24h, -mtime -0 is dead),
  -perm (DASH = "at least these bits": -4000 SUID, -2000 SGID,
  -002 world-writable), -size (k/M/G round UP, c = exact),
  2>/dev/null, tee
- Concept learned: SUID/SGID + MITRE T1548.001
- Tool built: suspicious_hunter.sh (threat hunter) — 4 of 5 sections live
- Filed under: tools/ (project, not a roadmap level)

### ⏭️ NEXT SESSION — pick one:
A) Finish the hunter — learn -user, add section 5
   (root-owned + world-writable), drop the cd
B) Start Level 8 — Process Management (ps, top/htop, kill, &)
