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
# 🦾 Level 6.1 — The `for` Loop & Fusion Mini-Bosses
**Hero:** Iron Man (Linux & Bash) · **Level 6: Loops — `for` complete**
**Date:** 29 May 2026 · **Status:** ✅ for-loop mechanics cleared; ceiling reached

**In one line:** I took the `for` loop from "walk a list" all the way to nested
loops over folder trees, fused real commands (`cp`, `chmod`, `rm`) into it, and
deliberately pushed it until I could feel exactly where `for` stops being the
right tool — which is the reason `while` and `find` exist.

## 🔁 The idea, in my own analogy
A `for` loop is one hand moving down a row of items, touching each exactly once.
`for VAR in LIST` — `VAR` is the hand, holding ONE item per pass; `LIST` is the
row. The hand never skips and never doubles back. The whole skill is choosing
*what the row is* and *what the hand does* at each item.

## ⚔️ The mini-bosses I built
Each boss was a different SHAPE of loop, not just a different command:
- **`sweep`** (classify & create) — look at each item, decide what it is, act.
- **`org`** (sort & relocate) — pick up each item, carry it to the right bin (`mv`).
- **`seed`** (fan-out) — loop over DESTINATIONS, copy one starter file into each
  (`cp`). Learned to put the "is the starter file even here?" check ONCE at the
  top — fail fast — instead of letting `cp` fail noisily in every folder.
- **`triage` / `cleanup`** (two-fate) — walk a folder's contents; each item is
  either locked down (`chmod`) or removed (`rm`). First time fusing `chmod`+`rm`
  into a loop, then extended to many folders with a nested loop.

## 🔍 Discoveries
- **`folder/*`** — a glob can be aimed at ANY named directory, not just the one
  I'm standing in. The matches come back WITH the path attached (`testzone/25`),
  and that prefix is precisely why `chmod`/`rm` could act on each item.
- **Nested loops** — `for` inside `for`. Each deeper level points at the
  level-above's variable + `/*`:  `"$@"` → `"$folder"/*` → `"$sub"/*`.
  I chain the loop variables downward.
- **`"$@"/*` only globs the LAST argument** — so for a single target folder the
  honest form is `"$1"/*`. (Same lesson as `$1` vs `$@` from earlier.)
- **Empty glob survives as literal text** — an empty folder hands the loop the
  literal string `folder/*` once; my `-f`/`-d` guards quietly absorb it.
- **Globs skip hidden/dotfiles** — `*` never sees `.bashrc`. A real blind spot
  for a security tool, since dotfiles are where secrets and malware hide.

## 🐛 The two-hour wall — and Claude's miss (told straight)
Claude handed me the `triage` spec worded as "go through each item inside that
folder." That quietly REQUIRED `folder/*` — globbing into a named directory —
which my roadmap had never taught (it only ever showed `*.txt` in the current
directory). Claude didn't flag it as new, even though our standing rule is to
surface anything beyond the roadmap.

So I hit a wall. I spent ~2 hours fighting it, experimented my way to `"$@"/*`
on my own, and got the script working — then called out that both the roadmap
AND Claude had skipped a required piece. Claude owned the miss without excuses,
and we set the rule going forward: **anything beyond Levels 1–5 + the plain
`for` loop gets flagged up front, and learned on purpose — never buried in a
spec for me to find the hard way.** The thing I tripped over turned out to be
the single most useful discovery of the day.

## 🧱 The ceiling I hit (and why it matters)
Pushing `for` to its edge showed me two hard limits:
1. **`for` walks a list it already has** — arguments, a glob, a folder's
   contents. It cannot loop on a *condition* ("keep going *while* X is true,"
   "repeat *until* the user quits"). There's no fixed list there.
2. **Nesting only handles depth I can count in advance.** Folders nested to
   UNKNOWN depth can't be solved with a taller stack of loops — that's `find`'s
   job (a recursive whole-tree walk), parked for later.

I also locked in the real design fork: **delete vs descend.** If the tool
*removes* folders, depth is irrelevant — the folder is destroyed, never entered.
You only need to go deeper if you choose to clean *inside* instead of deleting.

## 🎯 What this demonstrates
- Composing primitives — `for` + `if/elif` + file tests + `cp`/`chmod`/`rm`
  into working tools, not isolated commands.
- Reading failure precisely — separating a genuine roadmap gap from my own bug,
  and root-causing `folder/*` by experiment.
- Knowing a tool's *edges* — not just how `for` works, but where it stops being
  the right shape, which is what tells me when to reach for a different tool.
- Holding the process accountable — flagging that a required concept was never
  taught, instead of assuming I was the problem.

## 🔗 Connections forward
- **`while`** (next): the condition-driven loop, for when there's no fixed list
  to walk. Brings `$(())` arithmetic with it (for counters like `x=$((x+1))`).
- **`find`** (later): unknown-depth tree walking — the recursive version of
  "every item inside, all the way down."
- **🐍 Python (Bruce Banner):** the same `for` and nested `for` return with new
  syntax; `os.walk()` later replaces the find-style descent.
- **🛡️ Security (Captain America):** `chmod` in a loop = least privilege at
  scale; the dotfile blind spot = where real investigations have to look.

## ➡️ Why I'm moving to `while`
I set out to push `for` until I *felt* where it breaks — and I found it: `for`
needs a list, and the next real problems (run until a condition changes, monitor
something over time) have no list to hand it. That gap is exactly what `while`
fills. Reaching that wall is the signal it's time, so the story moves on to
condition-driven loops.
