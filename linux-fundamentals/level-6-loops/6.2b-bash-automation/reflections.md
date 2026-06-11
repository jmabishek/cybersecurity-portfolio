# Level 6.2b — Bash Loops & Automation · Reflections
**Date:** Between first while session and nested loops session
**Status:** ✅ Complete — self-directed deeper session

---

## Why I went here instead of moving forward

After 6.2a I could write a while loop. The counter worked. The heartbeat
made sense. But I looked at what I had built and it felt like exercises,
not tools. I had not combined loops with functions in a meaningful way.
I had not used pattern matching. I had not built anything that could
survive real use without breaking something important.

I made the decision myself — not because the roadmap said to, but because
I knew what professional work looked like and this was not it yet. That
decision is the most honest thing I can say about this session.

---

## What changed in this session

The biggest shift was moving from loops that CREATE things to loops that
MAKE DECISIONS about things. Every program here had to look at a file,
figure out what it was, and choose what to do with it. That is closer
to real security work than counting up to 5.

The second shift was learning that a destructive loop without a dry-run
is a liability. I learned this the hard way — a quoted pattern killed
the wildcard, every .sh file failed the protect check, and they were
deleted. After that the dry-run was not optional anymore. It became
the first line of any script that touches real files.

---

## The most important thing I learned

The quoted pattern bug was the real lesson of this session.

`[[ "$any" == "*.sh" ]]` looks almost identical to the correct version.
One pair of quotes in the wrong place. The `*` stops being a wildcard
and becomes a literal character. Every shell script I was trying to
protect failed the check silently and was deleted.

This taught me two things that stay permanently:
1. Leave the pattern unquoted — always.
2. Never run a destructive loop without seeing what it would do first.

A dry-run costs nothing. A missing dry-run can cost everything.

---

## How the cleanup tool evolved

I built it twice in this session on purpose.

Version 1 protected files by name — a hardcoded list of four filenames.
It worked for those four. A fifth .sh file would be deleted. That is
not a tool, that is a script with a list of exceptions.

Version 2 protected files by shape — any file ending in .sh, whatever
its name. The pattern does the work. Add a new shell script tomorrow
and it is automatically protected. That is a tool.

The difference between a list of exceptions and a pattern that describes
a category is the difference between patching and designing.

---

## Variable scope — lived it, not read it

Getting the loop to pass the right value to the function took real
debugging. I tried three things before it worked:

- `repeat "$@"` — passed the shell's empty argument list. rm got nothing.
- `repeat "$any"` — passed the function's own private variable, invisible
  outside. Still empty.
- `repeat "$abhi"` — passed the loop variable, the one item per pass.
  Correct.

I did not read this in a book. I ran each version, read the error, and
figured out what was actually being passed. That is how variable scope
became real to me.

---

## Why this session matters for security work

Every concept here maps directly to real SOC automation:

- Pattern matching classifies files by type without knowing their names
- Dry-run mode lets you verify before acting on a live system
- `&&` instead of `;` means a failed test stops the chain — nothing
  dangerous runs on a bad condition
- `local` variables mean functions do not corrupt each other's state

These are not Bash tricks. They are the habits that separate a script
that works in testing from one that works on a production server.

---

## Connections forward

- **6.2c — nested loops:** the for + while combination comes next,
  applied to real log file monitoring across multiple rounds.
- **Python (Bruce Banner):** the same classify-and-act pattern returns
  with different syntax. The dry-run concept returns as a `--dry-run`
  flag in real tools.
- **Security (Captain America):** least privilege in code — only delete
  what matches, protect everything else by default.
