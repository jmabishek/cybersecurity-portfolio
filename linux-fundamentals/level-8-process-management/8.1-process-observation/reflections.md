# Level 8.1 — Process Observation · Reflections

![Progress](https://img.shields.io/badge/Progress-PRACTICED%20%2B%20EXPLAINED-2ea44f)
![Skill](https://img.shields.io/badge/Skill-Process%20Reasoning-8250df)
![Approach](https://img.shields.io/badge/Approach-Test%20→%20Observe%20→%20Explain-f57c00)

**Date:** 13 August 2026

---

This session changed the way I think about processes.

Before Level 8, I knew that commands ran and that Linux had PIDs, but those ideas were still separate pieces. Today I connected the whole path:

```text
program
→ process
→ PID
→ parent / PPID
→ user
→ terminal
→ process evidence
```

The most important correction was understanding responsibility between Bash and the kernel.

Bash is the shell interpreting what I type, but it does not independently own Linux process creation. When an external program needs to run, Bash requests operating-system operations and the kernel performs the kernel-level process management. That distinction sounds small, but it fixed a bigger mental-model problem for me:

> **The component requesting work is not necessarily the component that performs the work.**

That idea will matter later for services, sockets, networking, files, and security.

---

## THE PPID CLIMB WAS THE STRONGEST PART

The best experiment today was not `ps aux`.

It was following PPIDs manually.

I started from a process I could see and followed its parent relationships upward through Bash, the terminal-related processes, my user session, and toward system-level process ancestry.

That turned PPID from:

> "another number in a table"

into:

> **an investigative relationship.**

Now when I see a process, one of my natural questions is:

**What launched this?**

That is much more useful than recognizing a process name alone.

---

## I TESTED THE TWO-TERMINAL THEORY INSTEAD OF ACCEPTING IT

I wanted to know whether opening another terminal really meant another Bash process.

Instead of just accepting the explanation, I opened two terminals and checked.

The result matched my prediction:

```text
Terminal 1 → Bash PID A → pts/0
Terminal 2 → Bash PID B → pts/1
```

Same Bash program.

Different running instances.

Different process IDs.

Different terminal associations.

That experiment made the difference between **program** and **process** concrete.

---

## `ps` STOPPED BEING A COMMAND TO MEMORIZE

At first it would have been easy to treat:

```bash
ps
ps aux
ps lax
```

as three commands to memorize.

Instead, I experimented with the help system:

```bash
ps --help
ps --help list
ps --help all
```

and tried to understand why different forms produced different information.

I also deliberately tried combinations that failed:

```bash
ps lux
ps laux
```

and got:

```text
conflicting format options
```

That failure helped me understand something useful:

> I should not randomly stack options just because individual letters exist.

Different `ps` formats have different purposes and output structures.

The goal is not to know every `ps` option.

The goal is to know what evidence I need and choose an appropriate view.

---

## `grep` WAS A REAL GAP — NOT A REVISION

`grep` was one of the Level 7 gaps I had not properly learned.

Today I learned it from scratch because process output created a real reason to need it.

That made the concept much easier to understand.

When `ps aux` produced a wall of processes, this:

```bash
ps aux | grep python
```

suddenly had an obvious purpose.

I was not learning `grep` because it appears on a Linux command list.

I needed:

```text
large evidence set
→ reduce it
→ inspect only relevant lines
```

That is the kind of learning connection I want to keep using.

---

## THE FRUIT TEST MADE `grep` CLICK

I created controlled data:

```text
apple
banana
apricot
cherry
avocado
```

and searched:

```bash
grep a fruits.txt
```

I initially mentally grouped all the fruits together, but `cherry` had no `a`, so it disappeared.

That small mistake made the behavior clearer than another definition would have:

> `grep` does not "show me the file with highlighted words."

It produces matching lines and discards non-matching lines from its output.

---

## THE FALSE-POSITIVE LESSON WAS IMPORTANT

I ran:

```bash
ps aux | grep root
```

and learned why text filtering must not be confused with interpretation.

A process owned by `abhi` could still appear because its command contained:

```text
-rootless
```

`grep` had done exactly what I asked.

The mistake would have been **my interpretation** if I had assumed every matching line represented a root-owned process.

This is probably the most security-relevant lesson from the `grep` work:

> **A match is not a conclusion.**

The same idea applies to alerts, logs, signatures, process names, and other security evidence.

Something matched.

Now I still have to determine **why**.

---

## I ALSO SAW THE TOOL MATCH ITSELF

When I ran:

```bash
ps aux | grep python
```

I saw the expected Python processes — plus:

```text
grep --color=auto python
```

At first this can look like noise.

But it actually demonstrates the timing:

```text
Bash starts the pipeline
→ ps and grep are running
→ ps observes running processes
→ grep's command line contains "python"
→ that line matches too
```

That helped connect:

* process lifetime
* `ps` snapshots
* pipes
* command lines
* text filtering

in one experiment.

---

## FAILURES WERE PART OF THE LAB

I tried `grep` against directories.

I swapped around what I thought should be searched.

I gave it no file and saw it wait for stdin.

I searched broad patterns such as `0` and got an overwhelming result.

I tried invalid `ps` format combinations.

Those were not wasted commands.

Each failure answered a different question:

```text
Why is it waiting?
Why did this match?
Why did this not match?
Why did I get "Is a directory"?
Why is this unrelated-looking line present?
Why does this ps format have different columns?
```

I am getting better at separating:

> **what the system actually proved**

from:

> **what I assumed the output meant.**

---

## SECURITY THINKING I TOOK FROM THIS

Process investigation is not:

```text
weird process name
→ malware
```

A stronger investigation starts building context:

```text
process
→ owner
→ PID
→ PPID
→ parent
→ command line
→ terminal/session context
→ resource behavior
→ other evidence
```

The PPID trail can help answer:

> "What launched this?"

But PPID alone is still only one piece of evidence.

Likewise, finding a process named `python`, `bash`, or anything else does not make it suspicious by itself.

The behavior and context matter.

---

## I FOUND ISSUES IN MY OWN `.bashrc`

While checking aliases, I noticed examples that are worth cleaning later.

One alias was named:

```bash
safer
```

but only executed:

```bash
ls -la
```

The command itself is harmless, but the name implies a security property it does not provide.

That is a documentation and usability risk.

I also had aliases containing hardcoded PID information.

That does not make sense as permanent configuration because process IDs change as processes start and exit.

This was a useful reminder:

> **Names should describe real behavior, and temporary system state should not be treated as permanent configuration.**

---

# WHAT I CAN NOW EXPLAIN WITHOUT JUST RECITING COMMANDS

After this session I can explain:

* the difference between a program and a process
* why one program can have many process instances
* why Bash itself has a PID
* why an external `ps` run gets another PID
* why `ps` can display itself
* what PID and PPID tell me
* why parent relationships can matter during investigation
* why two terminal sessions can have different Bash processes
* what `pts/0`, `pts/1`, and `TTY ?` mean at the level I currently need
* why bare `ps` and `ps aux` give very different views
* why different `ps` formats can expose different columns
* why `ps aux` does not contain PPID by default
* how to use `ps --help` to discover capabilities
* what `grep` does to text
* why pipes make process filtering useful
* why `grep` can match itself
* why `grep root` is not equivalent to "USER equals root"
* why a process-name match is weak evidence by itself

---

# MY MAIN TAKEAWAY

The biggest improvement today was not learning more syntax.

It was moving from:

```text
"I know the ps command."
```

to:

```text
"I can look at process evidence,
form a prediction,
test it,
and explain why the output looks that way."
```

That is the level of understanding I want the rest of this portfolio to demonstrate.

---

## STATUS

**Level 8.1 — Process Observation:** ✅ **PRACTICED + EXPLAINED**

The standout evidence from this session was:

1. manually tracing PPID relationships,
2. proving the two-terminal/two-process model myself,
3. reconstructing and exploring `ps` behavior using its own help,
4. learning `grep` through controlled and incorrect inputs,
5. identifying false-positive text matches instead of blindly trusting filtered output.

**Next:** continue to the next Level 8 Process Management sub-level.
