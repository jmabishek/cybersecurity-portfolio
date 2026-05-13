DAY - 3 NOTES

LEVEL 3 - PERMISSIONS (Captain America)

ls -la - reading the locks
   First 10 characters tell the whole story:
   d r w x r w x r w x
   |  owner  group  others

   First slot:
       d = directory
       - = regular file
       l = symlink
   Then 3 groups of rwx, in this exact order:
       owner / group / others
   First match wins (cascade rule).

NUMERIC MODE - the 4-2-1 system
   Each permission is one bit:
       r = 4
       w = 2
       x = 1
   Add only what's ON. That sum = the digit.
   Three groups = three digits.

   Why 4-2-1 specifically?
       It's binary place values for 3 bits.
       
       Only combination that gives unique sums
       
       AND fits in a single digit (0-7).
       
       Other systems (5-2-1, 5-6-2) either skip
       
       numbers or overflow into two digits.
       
       The math forced the choice, not designers.

   Common patterns:

       
       600 = -rw------- = private (SSH keys, secrets)
  
       644 = -rw-r--r-- = blog/post (I write, world reads)
       
       755 = -rwxr-xr-x = directories and executables
       
       711 = -rwx--x--x = run-only-no-read (binaries)
       
       666 = -rw-rw-rw- = world-writable. RED FLAG.
       
       777 = -rwxrwxrwx = wide open. Never in prod.

   chmod - change mode
   
       Stands for "change mode" - mode = permission state.
   
       Same naming pattern as cd, cp, mv, rm, chown.

   Numeric form:
       
       chmod 644 file = set exact state, all 9 bits.
       
       Overwrites everything. Absolute.

   Symbolic form:

       
       chmod [who][operator][what] file
       
       Adjusts only the bit you name. Relative.

       WHO:
           u = user (owner)
           g = group
           o = others
           a = all three

       OPERATOR:
           + = add this permission
           - = remove this permission
           = = set EXACTLY (wipes the rest in that group)

       WHAT:
           r = read
           w = write
           x = execute
           Can combine: rw, rx, rwx

   Stacking who's:
       chmod ugo+x file = add x to all three
       chmod go=r file  = group AND others = exactly r
       chmod a+r file   = same as ugo+r

   Numeric vs Symbolic:
       Numeric = surgical replace (rewrite whole msg)
       Symbolic = surgical edit (edit one word)
       Numeric for scripts/audits (deterministic).
       Symbolic for live work/incident response.

OWNERSHIP RULES (the deep truth)
  
  Only the OWNER (or root) can chmod a file.
   
  Wide-open rwx bits don't let others change perms.
   
  The lock on the lock is OWNERSHIP, not rwx bits.
   
  This protects the entire DAC model.

   This is called Discretionary Access Control (DAC).
   
   The owner has DISCRETION over their own files.
   
   Every Linux security model rests on this.

   Real attack vectors aren't chmod itself:
      
       1. File already world-writable (666/777)
      
       2. Attacker becomes root (priv escalation)
      
       3. Attacker hijacks the owner's account

WHAT EACH PERMISSION ACTUALLY MEANS

   On a FILE:
       r = read the file's contents
       w = modify the file's contents
       x = execute (run it as a program)

   On a DIRECTORY:
       r = list what's inside
       w = create/delete files inside
       x = enter the directory (cd into it)

   Note: w on a directory lets you DELETE files
   inside it - even files you don't own. That's
   why directory write is unusually powerful.

chown - PARKED FOR LAPTOP (May 2026)
   Transfers the "deed" of a file to a new owner.
  
 Only root can run chown.
   
   Why? Otherwise users could:
      
       - Steal files by claiming ownership
       
       - Frame others by transferring malware
       
       - Evade detection by laundering ownership
   
   Termux is single-user + sandboxed, can't practice.
   
   Will cover on laptop with multi-user setup.

THE CHECK-FLIP-VERIFY HABIT

Always:
   1. ls -la file       (see current state)
   2. chmod ... file    (change it)
   3. ls -la file       (verify the change)

Never assume the change worked. Always verify.


THINGS THAT CLICKED HARD

- 4-2-1 isn't arbitrary. It's binary mathematics.
- Numeric overwrites all 9 bits.
- Symbolic only touches the bit you name.
- = operator wipes the rest. + and - leave others.
- Ownership is per-file, not per-person.
- Same person = owner here, others somewhere else.
- Every file has exactly ONE owner.
- Linux fails loudly: u+1 gave "invalid mode."
- Termux defaults to 600 (umask hardening).
- Re-running chmod 600 even when already 600 =
  idempotent hardening. Pros do this in scripts.
  Trust nothing. Enforce always.
