# Level 6.2 — While Loops · Reflections
**Date:** Early June 2026
**Status:** ✅ Complete — but not satisfied; moved to deeper session

---

## Why I learned while loops the way I did

After pushing the `for` loop to its limits deliberately, I arrived at
`while` already knowing WHY I needed it. The `for` loop needs a list.
The `while` loop watches a condition. That distinction was not abstract
for me — I had already felt the gap.

My analogy: a `while` loop is a heartbeat monitor. It keeps running as
long as the patient is alive. The moment the condition flips — the
patient recovers or the counter hits the limit — it stops. Miss the
heartbeat line and it runs forever.

---

## What I built

I worked through five programs in sequence, each one adding a layer:

- **Counter** — pure while loop, stepping by 2 to print odd numbers.
  Simple, but it proved the three-part structure: initialize, test, heartbeat.
- **Foundation Layer** — created 6 files then 6 folders automatically.
  Learned that two loops in a row need separate counters — the second
  loop's counter has to be reset or it never runs.
- **Inspector** — checked whether each folder existed. First time using
  `-d` inside a while loop. The loop asked a question about the real
  world and reported honestly.
- **Teardown** — removed files and folders together in one pass.
  Discovered the `elif` vs separate `if` difference by running both versions
  and seeing the output. `elif` only fires one branch. Two separate `if`s
  each fire independently, every pass.
- **repeat()** — a reusable function taking two arguments, using while
  to repeat a word a chosen number of times. Fixed an off-by-one error
  by starting the counter at 1 instead of 0.

---

## Bugs I hit myself — not told about, discovered by running

1. **Infinite loop** — forgot the heartbeat. Loop ran forever.
   Stopped it with `Ctrl+C`, added the increment, understood why.
2. **`$(( ))` missing** — tried `x=x+1`, got the text "x+1" stored.
   Bash does not do math unless you ask it to.
3. **Integer overflow** — multiplied a number past 9.2 quintillion.
   It rolled into negative. Bash integers have a hard ceiling.
4. **The lying echo** — wrote `echo "deleted"` after `rm` without
   gating it. The message printed even when the file was not there.
   Learned: `echo` does not know what happened before it. Gate with `if`.
5. **Ghost variable** — used `source` to run a script. A stale variable
   from a previous run printed the wrong value. Switched to `./script.sh`
   to get a clean shell.
6. **elif vs separate if** — discovered by experiment, not by being told.
   `elif` only takes one branch. Two separate `if`s each fire.

---

## Why I was not satisfied and went further

I completed everything in the session. The loops worked. The programs ran.

But when I looked at what I had built, I realized it was not professional
yet. The while loop was working as a counter — initialize, test, heartbeat.
But I had not combined it with functions in a real way, had not used pattern
matching with `[[ ]]`, had not built anything that looked like actual security
automation work.

I made the decision to go into a second deeper session before moving to 6.3.
Not because I failed — because I knew what good looked like and this was not
it yet. That decision is the most important thing this session produced.

---

## Connections forward

- **`while` + `for` nested** — the next session combined both loops
  inside the same script for the first time.
- **Python (Bruce Banner)** — `while condition:` is the same structure.
  The heartbeat is just written differently.
- **SOC work** — real monitoring scripts run while loops continuously,
  checking servers and log files every few seconds. The infinite loop
  is not a mistake there — it is the design.
