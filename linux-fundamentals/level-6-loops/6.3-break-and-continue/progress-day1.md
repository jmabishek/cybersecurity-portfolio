═══════════════════════════════════════════════════════════════
LEVEL 6.3 — BREAK AND CONTINUE (Day 1 — in progress)
═══════════════════════════════════════════════════════════════

STATUS: Core concepts owned. Integration started with Pattern 2.
Patterns 1, 3, 4, 5, 6 still pending. Returning tomorrow.

───────────────────────────────────────────────────────────────
CORE CONCEPTS LEARNED
───────────────────────────────────────────────────────────────

break — kills the loop immediately. Remaining items discarded.
        Execution jumps to the line AFTER done. Works the same
        in for, while, and any nested loop.

continue — skips the current pass only. Loop stays alive.
           Jumps back to the top of the loop with the next item.
           Can be used multiple times in one loop.

break vs continue:
- break = loop is dead
- continue = loop is alive, one item ignored

Multiple continues + one break in the same loop is valid.
Whichever fires first wins on that pass.

───────────────────────────────────────────────────────────────
THE WHILE + CONTINUE TRAP (discovered by hand)
───────────────────────────────────────────────────────────────

In a for loop, the counter moves on its own (conveyor belt).
In a while loop, the counter is manual (walking and counting).

If continue fires in a while loop BEFORE the counter is
incremented — the counter never moves. Loop freezes on the
same value forever. Infinite loop. Ctrl+C is the only exit.

THE RULE:
In every while loop with continue, increment the counter
FIRST, then continue. Every continue branch needs its own
increment before it fires.

Proven by triggering the infinite loop multiple times and
fixing it by moving i=$((i+1)) before continue.

───────────────────────────────────────────────────────────────
$0 — WHAT IT ACTUALLY HOLDS
───────────────────────────────────────────────────────────────

$0 = the name of whatever is currently running the script.

When run with: source boss1.sh
$0 becomes /usr/bin/bash — NOT boss1.sh
Because source runs the script inside the current shell.

Lesson: $0 is unreliable for "skip myself" logic when sourcing.
Workaround: set a global variable at the top of the script with
the script's name, and compare against that instead.

───────────────────────────────────────────────────────────────
VARIABLE SCOPE (discovered through bugs)
───────────────────────────────────────────────────────────────

- "local" only works inside a function. Outside = error:
  bash: local: can only be used in a function

- A variable set inside a function is invisible outside it,
  unless declared at the top level of the script.

- The for loop could not see ss="boss1.sh" until it was moved
  ABOVE the function, at the top of the script.

RULE: Where you define a variable decides who can see it.
Top of script = global. Inside function = private.

───────────────────────────────────────────────────────────────
CONTINUE CANNOT LIVE INSIDE A FUNCTION
───────────────────────────────────────────────────────────────

continue only works inside a loop directly.
Putting continue inside classify() did nothing useful — the
function returned but the loop kept processing the file.

FIX: Move the continue check into the loop body, not the
function. The function does work, the loop controls flow.

───────────────────────────────────────────────────────────────
SKIP BY POSITION vs SKIP BY PROPERTY
───────────────────────────────────────────────────────────────

Two ways to use continue:

1. Skip by value/position — when you know exactly what to skip.
   Example: if [ $i -eq 3 ]; then continue
   Used for numbers, counts, specific indexes.

2. Skip by property/pattern — when you don't know in advance.
   Example: if [[ "$file" == *.sh ]]; then continue
   Used for files, real-world data, SOC work.

In real scripts, skip-by-property is far more common.
You describe what to skip, the loop checks every item.

───────────────────────────────────────────────────────────────
ARRAYS — INTRODUCED (Level 7 preview, used minimally)
───────────────────────────────────────────────────────────────

An array is a numbered list of items.

files=(*)              → packs every file into a numbered list
count=${#files[@]}     → how many items in the list
${files[$i]}           → the item at position i

Used to make a while loop walk a folder by index.
Full array topic belongs to Level 7 — used here only because
the while-loop walking version required it.

───────────────────────────────────────────────────────────────
PROGRAMS WRITTEN TODAY
───────────────────────────────────────────────────────────────

1. bk.sh — for loop with break at i=3 (prints 1 2, stops)

2. bk.sh v2 — for loop with continue at i=3 (prints all but 3)

3. bkw.sh — while loop with break at x=3 (prints 1 2)

4. bkw.sh v2 — while loop with continue (caused infinite loop,
   debugged and fixed by incrementing before continue)

5. Multi-condition demo — for loop with two continues (skip 3,
   skip 5) and one break (at 8). Output: 1 2 4 6 7.

6. boss1.sh refactor — original classify() limitation fixed.
   Used global ss="boss1.sh" + continue in the for loop to
   skip the script itself. Tested with fresh files each run.

7. boss1.sh while version — same classify() function, but the
   loop rewritten as while + array + counter. Walks files by
   index instead of glob expansion. Self-skip logic preserved.

───────────────────────────────────────────────────────────────
INTEGRATION STATUS — PATTERNS FROM RESUME PROMPT
───────────────────────────────────────────────────────────────

[x] Pattern 2 — continue in classify (skip self)        DONE
[ ] Pattern 1 — break in while monitoring loop          tomorrow
[ ] Pattern 3 — break in nested loop on critical error  tomorrow
[ ] Pattern 4 — continue with pattern matching          tomorrow
[ ] Pattern 5 — break in flexible monitor               tomorrow
[ ] Pattern 6 — while true + sentinel break             tomorrow

───────────────────────────────────────────────────────────────
RESUME TOMORROW FROM HERE
───────────────────────────────────────────────────────────────

Pattern 1 next: a while-loop file monitor that breaks
immediately when a critical file goes missing.

═══════════════════════════════════════════════════════════════
