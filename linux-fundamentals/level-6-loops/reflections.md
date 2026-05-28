# Level 6 — Loops · Reflections

## What a loop finally meant to me
Everything before happened once — type a command, it runs, done. A loop broke that ceiling: hand it a list, and it runs the same block once per item, in order, missing none. My picture: one repulsor blast hits one target, but in a real fight you lock onto a whole *list* of incoming and fire the same shot at each, one after another, until the list is empty. The action stays the same; only the target changes each pass.

The piece that took longest to click: the gap between **all the items** and **the one I'm on**. `"$@"` is the whole row; the loop variable is the single one this pass; `$#` is just how many. I kept reaching for `"$@"` inside the loop when I meant the current item.

## My approach for this level
By my own call, I pushed the `for` loop to its limits *before* learning `while` and `break` — I wanted to feel *where* a `for` loop stops being the right shape, because that gap is the exact reason those tools exist. I'd rather meet a tool as the answer to a problem I've felt than memorize it cold.

## How I debugged (the story)
- My function kept printing the **same value** for every item. I read the code instead of guessing and found it: the loop advanced one variable but the body read a *different* one. Same shape as a bug I'd hit earlier that day — second time, I recognized it instantly.
- Multi-argument runs threw `[: too many arguments`. That error *was* the lesson: `"$@"` had handed the test five separate words when it wanted one — proof that `"$@"` is many things, not one.
- The nastiest was **silent failure** — no error, no output, when I fed it names that didn't exist. Nothing to grab onto. It took a while to realize it was quietly skipping; the fix was to *announce* the skip.
- I stress-tested instead of trusting the happy path: 13 arguments at once, existing and brand-new names mixed, decimals, leading zeros, re-runs to confirm "created" flipped to "online."
- Mid-session I lost ~2 hours of work to a logout and rebuilt the whole thing from memory.

## New patterns I picked up
- `$#` for "how many?", the loop variable for "the one I'm on," `"$@"` only where I truly want all of them.
- `mkdir -p` already means "create if missing" — it replaces a whole `if [ -d ]` check.
- `ls FOLDER` shows contents without `cd`-ing in — which makes the whole "how do I get back?" problem vanish.
- Pull config (folder names) into variables so the logic stays still and the settings move.
- `start="$(pwd)"` + `cd "$start"` for a portable return instead of a hardcoded path.

## Working with an AI tutor — critically, not blindly
A real skill I practiced was *not* following instructions blindly. When a spec pushed me toward a clumsy `cd` dance I'd already seen a cleaner way around, I noticed and called it out. When the tutor over-built an unfamiliar scenario, I flagged it as straying and we rescoped. Default to the spec — but voice a better way when you see one.

## What this demonstrates
Building and debugging real Bash functions from a blank screen — producing and fixing, not just recognizing. Looping over arbitrary input, classifying and acting on each item, guarding edge cases, and stress-testing under deliberately hostile input.

## Connections forward
- **Python (Bruce Banner):** `for item in items:` is nearly word-for-word what I built; `len(args)` is my `$#`.
- **Text Processing (Hawkeye):** looping over each item is how you walk every line of a log.
- **Next:** `while` and `break` — met as the answer to the `for`-loop limits I deliberately ran into.
