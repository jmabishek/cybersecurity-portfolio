# Level 6.2c — While Loops Nested · Reflections
**Date:** 11 June 2026
**Status:** ✅ Complete — three boss fights cleared, flexible monitoring tool built

---

## How this session felt different

The previous two sessions taught me the mechanics. This session was the
first time I used those mechanics to build something a real SOC analyst
would actually run. Not a counter. Not a file creator. A monitoring tool
that takes any number of files and any number of rounds and reports the
status of each one — every single round.

That shift from "this works" to "this is useful" is what this session was.

---

## The rule that cost the most time — and taught the most

Boss 2 took the longest because of one line:

```bash
if [ check_file "$file" ]; then    # WRONG
if check_file "$file"; then         # CORRECT
```

I spent significant time on this. Every attempt failed with the same error:
`bash: [: check_file: unary operator expected`

I tried different bracket styles. I tried changing the function. I tried
passing different arguments. None of it worked because I was solving the
wrong problem.

The actual rule is simple: `[ ]` is a test for flags like `-f` and `-eq`.
It cannot run a function. When you call a function in an if statement you
write it naked — no brackets at all. The function already returns 0 or 1.
The if reads that directly.

One missing piece of syntax. Hours of debugging. I will never forget it.

The reason I will never forget it is that I hit it myself and had to work
through it myself. Nobody handed me the answer immediately. That is the
difference between knowing a rule and owning it.

---

## The professional structure I locked in

Before this session I was putting all the logic directly inside the loop.
It worked. But it does not scale.

```bash
# what I was building before
for log in *
do
    # 20 lines of logic here
    # and more logic
    # and conditions
done
```

After this session I think differently. The loop walks. The function works.
They do not mix.

```bash
scan_file() {
    # all logic here — one job
}

for log in *
do
    scan_file "$log"    # one line — one job
done
```

When a real security script has 10 checks per file, this structure is the
only one that stays readable. I built pp.sh this way without being asked
to — I saw the improvement myself and made it.

---

## Test environment — applied independently

When I built Boss 1 I created a new file called boss1.sh instead of
editing the working kk.sh. Nobody told me to. I did it because I had
already learned that a working script is not something you edit blindly.

When I built pp.sh I did the same thing — new file, working original
untouched.

This is the test environment principle. Production stays stable. Testing
happens elsewhere. I am applying it by reflex now, not by instruction.

---

## ${@:2} — the pattern that made the tool professional

Boss 3 was the one that changed what the tool could do.

Before Boss 3 the script had hardcoded file names. It checked auth.log,
system.log, error.log. Always those three. Always three rounds. To change
anything you had to edit the script.

After Boss 3 the script takes arguments:

```bash
report 3 auth.log system.log error.log
report 10 nginx.log syslog
report 55 auth.log
```

Same script. Different inputs. The rounds change. The files change. The
script stays the same.

`$1` controls the rounds. `${@:2}` takes every file from position 2
onward. Two files or twenty — the script handles them all the same way.

That is the difference between a script and a tool.

---

## The three monitoring patterns I identified myself

During the session I described three different situations where you would
use a while loop differently:

**Static log** — a log file that does not change while you read it.
Read it once, classify it, move on. No loop needed per file.

**Real-time log** — a log that keeps growing while a service runs.
An infinite while loop keeps watching. The loop is not a mistake here.
It is the design.

**Periodic log** — a log that changes at intervals. A timed while loop
with sleep checks it every few minutes. Not continuous, not one-shot.

The loop choice follows the data behavior. A good analyst does not
apply the same loop to every situation. They choose based on what
the data actually does.

---

## What each boss fight tested

**Boss 1 — File Sorter**
Tested whether I could use pattern matching inside a function called
from a loop. I went further than the assignment — I built a tool that
physically moves files into folders, not just reports them. I also
applied the test environment principle without being asked.

**Boss 2 — Monitoring Sentinel**
Tested the for inside while pattern. The real test was the function
call in the if statement — the rule that cost the most time. Once that
clicked the rest came quickly. I verified it by deleting files mid-run
and confirming the ALERT fired correctly.

**Boss 3 — Flexible Monitor**
Tested whether I could build a genuinely reusable tool. The tool takes
any number of rounds and any number of files. I tested it at 55 rounds.
I tested it with missing files. I tested it with 1 file and with 3.
Every case worked correctly after fixing the single echo line that was
printing all filenames together instead of one at a time.

---

## Limitations I identified

- **Boss 1 moves itself** into shell-files when it runs, so a second
  run cannot find it. Fix requires `continue` — that is Level 6.3.
- **Space in list items splits them** — `server 4` becomes two items
  in a for loop. Must quote: `"server 4"`.
- **`${@:2}` cannot be followed by another individual argument** — the
  open-ended list must always be last.
- **`sleep` makes the monitor real** — without it the rounds run
  instantly. For production use, `sleep 60` between rounds is the
  real implementation.

---

## What I carry forward

- Call functions in if without brackets — always
- Loop walks, function works — never mix them
- `${@:2}` for flexible argument lists — specific args first, list last
- Test environment before touching anything that works
- Predict iterations before running — outer × inner
- The loop choice follows the data behavior, not the habit

---

## Connections forward

- **6.3 — break and continue:** the tool I built in Boss 1 needs
  `continue` to skip itself. I felt the need for it before learning it.
- **Level 7 — Scripts:** these tools deserve a shebang line, chmod +x,
  and proper argument handling. The next level makes them permanent.
- **Python (Bruce Banner):** the same nested loop structure returns.
  The `report` function with `${@:2}` maps directly to `*args` in Python.
- **SOC work:** the flexible monitor is the skeleton of a real file
  integrity monitoring tool. Point it at critical system files, set the
  rounds, run it on a schedule with cron.
