# Level 8.1 — Process Observation · Commands Learned

![Status](https://img.shields.io/badge/Status-PRACTICED%20%2B%20EXPLAINED-2ea44f)
![Focus](https://img.shields.io/badge/Focus-Process%20Observation-0969da)
![Environment](https://img.shields.io/badge/Lab-Ubuntu%20VM-f57c00)

**Date:** 13 August 2026
**Status:** ✅ Practiced and explained — program vs process, PID/PPID, process relationships, TTYs, `ps`, process filtering with `grep`, and pipe-based investigation.

---

## 8.1 — PROGRAM VS PROCESS

This session started with a distinction I needed to get completely clear before treating `ps` as just another command.

### Program

A **program** is stored instructions — for example, an executable file sitting on disk.

By itself, the file is not actively executing.

### Process

A **process** is a running execution instance managed by the Linux kernel.

A running process has information associated with it such as:

* PID
* parent process / PPID
* user identity
* execution state
* memory use
* CPU use
* open files
* terminal association

The same program can have multiple processes at the same time.

I proved this myself by opening two terminals. Each terminal had its own Bash process, with a different PID and different TTY.

> **Program = stored instructions. Process = those instructions currently executing in a managed runtime context.**

---

## BASH, SHELL, TERMINAL, AND KERNEL

One of the main goals of this session was putting process management into the system model I have been building.

```text
User
  ↓
Terminal
  ↓
Bash
  ↓
system-call interface
  ↓
Linux kernel
  ↓
CPU / memory / files / devices
```

### Terminal

The terminal is the interface carrying my keyboard input and displaying output.

It is **not** the shell.

### Shell

A shell is a command interpreter.

It reads shell syntax, expands variables and expressions, handles things such as loops and pipes, and starts or controls programs when required.

### Bash

Bash is one specific shell.

```text
Shell = category
Bash  = one implementation
```

Other shells include `sh`, `zsh`, and `fish`.

### Kernel

The Linux kernel manages processes, memory, CPU scheduling, filesystems, device access through drivers, and other kernel-owned resources.

### Correction I locked in

Bash does **not independently create and manage a Linux process by itself**.

For an external program, Bash makes requests through operating-system interfaces. The **kernel performs the process-management work**, assigns/manages the PID, schedules execution, and controls access to resources.

This distinction became important:

> **Requesting an operation is not the same as being the component that performs the kernel operation.**

---

# `ps` — SEE RUNNING PROCESSES

`ps` = **process status**

It gives a point-in-time view of process information.

I learned to think of it as:

```text
ps = snapshot
```

It runs, obtains process information, prints it, then exits.

---

## Bare `ps`

```bash
ps
```

Example from my terminal:

```text
PID    TTY      TIME     CMD
4312   pts/0    00:00:00 bash
4418   pts/0    00:00:00 ps
```

The important realization was that bare `ps` is **not a list of every process on Ubuntu**.

Its default selection is narrow, which is why my interactive Bash and the temporary `ps` process were the main processes I saw.

I also noticed that `ps` shows itself.

That makes sense:

1. Bash starts `ps`.
2. `ps` becomes a process.
3. `ps` takes the snapshot while it exists.
4. Therefore the snapshot can contain `ps`.
5. `ps` prints the result and exits.

---

# PID — PROCESS ID

Every running process has a PID.

I checked my Bash PID with:

```bash
echo $$
```

The Bash PID stayed stable while I remained in the same shell.

Every new external `ps` execution got a new PID.

That gave me direct evidence that:

```text
same Bash process
    ↓
runs ps
    ↓
temporary ps process with its own PID
    ↓
ps exits
    ↓
next ps run gets another PID
```

A PID identifies a currently running process. PID numbers can later be reused after processes exit.

---

# PPID — PARENT PROCESS ID

PPID records a process's parent relationship.

This turned into one of the strongest experiments of the session.

Using a format that exposed PPID, I manually followed the ancestry of my command.

My observed chain included:

```text
ps
 ↓
bash
 ↓
ptyxis-agent
 ↓
ptyxis
 ↓
systemd --user
 ↓
system-level process ancestry
```

I followed the relationships toward PID 1.

The important concept was not memorizing every program in that chain.

It was learning that:

> **PPID provides evidence about what launched or manages a process.**

---

# TWO DIFFERENT `systemd` CONTEXTS

I observed both:

```text
root ... PID 1 ... systemd
```

and:

```text
abhi ... systemd --user
```

These are not the same process.

### PID 1 systemd

Runs as `root` and operates at the system level.

### `systemd --user`

Runs as my user and manages parts of my login/user session.

The `USER` and PID columns helped me distinguish the contexts instead of relying only on the command name.

> **Same/similar process name does not mean same process, owner, or purpose.**

---

# TTY — TERMINAL ASSOCIATION

I observed:

```text
pts/0
pts/1
tty2
?
```

### `pts/0`, `pts/1`

Pseudo-terminals associated with interactive terminal sessions.

I tested this by opening two terminal sessions.

The Bash processes had:

* different PIDs
* different TTY values

That proved my prediction:

> One Bash program can have multiple running Bash processes, each belonging to a different terminal session.

### `?`

A `?` in the TTY field means the process has **no controlling terminal**.

It does not mean:

* unknown process
* failed process
* suspicious process

Many system/background processes legitimately have no controlling terminal.

---

# `ps -e` — EXPAND THE PROCESS SELECTION

```bash
ps -e
```

`-e` selects all processes.

This was useful mainly as a contrast with bare `ps`.

```text
ps
→ narrow default process selection

ps -e
→ broad system process selection
```

The biggest visible difference was the large number of processes with:

```text
TTY = ?
```

That showed how much of Linux runs independently of my interactive terminal.

---

# `ps aux` — BROAD PROCESS VIEW

```bash
ps aux
```

Important syntax:

> `aux` is commonly written **without a dash**.

My output included:

```text
USER   PID   %CPU   %MEM   VSZ   RSS   TTY   STAT   START   TIME   COMMAND
```

The parts I focused on were:

* `USER` — process owner
* `PID` — process ID
* `%CPU` — CPU usage information
* `%MEM` — memory usage information
* `TTY` — controlling terminal if one exists
* `COMMAND` — process command line

I did **not** try to memorize every field just because it existed.

The useful lesson was:

> Choose process output based on the information needed for the investigation.

---

## Understanding `a`, `u`, `x`

I opened the built-in help instead of blindly memorizing the command:

```bash
ps --help all
```

I located the options myself and reconstructed why `ps aux` behaves differently.

Broadly:

```text
a → expands process selection to terminal-associated processes beyond only mine
u → user-oriented output format
x → includes processes without a controlling TTY
```

The important result:

> `ps aux` gives me a broad view plus useful ownership/resource/context columns.

---

# DIFFERENT `ps` FORMATS = DIFFERENT INFORMATION

This was an important correction.

I originally thought changing `ps` options might simply produce more rows.

Instead, I discovered that different formats can also change **which columns are displayed**.

For example:

```bash
ps aux
```

does not normally display PPID.

But my long-format experiments exposed fields including PPID:

```bash
ps lax
```

Example header:

```text
F UID PID PPID PRI NI VSZ RSS WCHAN STAT TTY TIME COMMAND
```

So I stopped thinking:

> "Which `ps` command shows the most stuff?"

and started thinking:

> "Which information do I actually need?"

That is a much better investigation model.

---

# `ps` HELP — DISCOVER INSTEAD OF GUESSING

Commands explored:

```bash
ps --help
ps --help list
ps --help all
```

From the help output I found selection options such as:

```text
-p / --pid
--ppid
-t / --tty
-u / --user
```

and format-related options.

This reused a habit from Level 1:

> **When I don't know what a tool supports, inspect its help instead of inventing syntax.**

---

# FORMAT CONFLICTS I HIT

I experimented beyond the working examples.

These produced:

```bash
ps lux
ps laux
```

and returned:

```text
error: conflicting format options
```

This taught me that `ps` has multiple historical option styles and output-format personalities.

I do **not** need to memorize every combination.

The useful rule I kept is:

> **Use a known format for a specific purpose instead of randomly stacking letters.**

For now:

```text
ps        → quick narrow snapshot
ps aux    → broad user-oriented process view
ps lax    → long-style information including PPID
```

---

# `grep` — LEVEL 7 GAP FILLED DURING LEVEL 8

Before this session, `grep` was still a real gap for me.

I learned it from scratch because `ps aux` produces far too much text to manually scan every time.

## Basic shape

```bash
grep PATTERN FILE
```

Example controlled test:

```bash
printf "apple\nbanana\napricot\ncherry\navocado\n" > fruits.txt
grep a fruits.txt
```

Output:

```text
apple
banana
apricot
avocado
```

`cherry` disappeared because its line did not match the pattern `a`.

That made the behavior click:

> **grep is a discarding text filter — matching lines survive; non-matching lines disappear from its output.**

`grep` reads the input. This search operation does not modify the original file.

---

# WHAT `grep` ACTUALLY SEARCHES

For a simple pattern such as:

```bash
grep python
```

I can think of it as searching each input line for the requested text pattern.

By default, matching is case-sensitive.

For example:

```text
Stark
```

and:

```text
stark
```

are not the same default match.

Technically, `grep` patterns support regular expressions, which I will learn properly later. For this session I only needed simple text patterns.

---

# PIPE — CONNECTING `ps` TO `grep`

The key bridge was:

```bash
ps aux | grep python
```

Conceptually:

```text
ps aux
   ↓
produces process information as text
   ↓
|
   ↓
feeds that text to grep
   ↓
grep python
   ↓
prints only matching lines
```

This connected process management directly to text processing.

> **To `grep`, process output is still just lines of text.**

---

# PYTHON PROCESS SEARCH

I ran:

```bash
ps aux | grep python
```

and observed:

```text
root ... /usr/bin/python3 /usr/bin/networkd-dispatcher ...
root ... /usr/bin/python3 /usr/share/unattended-upgrades/...
abhi ... grep --color=auto python
```

I identified two Python-related process lines.

Then I noticed the third line was `grep` itself.

---

# THE `grep` SELF-MATCH GOTCHA

This appeared repeatedly:

```text
grep --color=auto python
```

Why?

The command line of the running `grep` process itself contains:

```text
python
```

Therefore that process line also satisfies the text search.

The same pattern appeared with:

```bash
ps aux | grep root
ps aux | grep user
ps aux | grep python
```

This became an important investigation lesson:

> **A search result is evidence to interpret — not automatically the thing I was looking for.**

---

# `grep root` DOES NOT MEAN "OWNER IS ROOT"

I tested:

```bash
ps aux | grep root
```

Most results were root-owned processes.

But I also saw an `abhi` process containing:

```text
-rootless
```

in its command arguments.

`grep` matched it because the letters:

```text
root
```

appeared somewhere in the line.

`grep` did **not** understand that I was mentally interested in the USER column.

This distinction mattered:

```text
text match
≠
semantic understanding of the column
```

---

# `grep 0` — WHY THE OUTPUT EXPLODED

I tried:

```bash
ps aux | grep 0
```

and got a huge number of matches.

That was expected once I understood the mechanism.

The character `0` can occur in:

* PIDs
* CPU values
* memory values
* timestamps
* command arguments
* many other fields

`grep` simply searches the line.

It does not know that I might mean:

> "PID equals 0."

---

# `grep` WITH NO FILE

I ran:

```bash
grep user
```

and it appeared to do nothing.

I stopped it with:

```text
Ctrl+C
```

The program was not broken.

Because I supplied no filename, `grep` was waiting for text from **standard input**.

This reused my earlier stdin/pipe knowledge:

```text
file input
or
piped stdin
        ↓
      grep
```

---

# DIRECTORY MISTAKES

I tried forms such as:

```bash
grep temp ~
grep temp temp/
grep l cybersecurity-portfolio/
```

and saw:

```text
Is a directory
```

The correction:

```text
grep PATTERN FILE
```

expects file/text input in the simple form I was practicing.

`~` expands to my home directory:

```text
/home/abhi
```

which is a directory, not a normal text file.

Some large lists I saw while experimenting were shell completion/expansion behavior rather than useful `grep` evidence, so I separated that from what `grep` itself was doing.

---

# ALIASES I INSPECTED

I also checked:

```bash
alias
```

This exposed some issues in my own `.bashrc`.

Examples included:

```bash
alias safer='ls -la'
```

The alias name suggests a security action, but its actual behavior is only a directory listing.

That is poor naming because:

> A command/alias name should not imply protection that the command does not provide.

I also found aliases containing hardcoded process values.

A hardcoded PID is temporary information.

After a process exits or the machine restarts, the PID can change or eventually be reused.

Therefore:

> **Dynamic process information should usually be discovered when needed rather than permanently hardcoded.**

---

# SECURITY CONNECTION — PROCESS INVESTIGATION

Today's commands produced a useful investigative chain:

```text
program
   ↓
running process
   ↓
PID / owner / TTY / command
   ↓
PPID
   ↓
parent process
   ↓
process ancestry / context
```

If an unfamiliar process appears, useful questions include:

```text
Who owns it?
What command is actually running?
What launched it?
Does it have a terminal?
What other evidence supports the suspicion?
```

A process name alone is weak evidence.

A text match alone is also weak evidence.

The process context matters.

---

# COMMANDS I ACTUALLY EXPLORED

```bash
ps
ps -e
ps aux
ps lax
ps lux
ps laux

ps --help
ps --help list
ps --help all

echo $$

ps aux | grep root
ps aux | grep user
ps aux | grep python
ps aux | grep tty
ps aux | grep pts
ps aux | grep 0

ps lax | grep root
ps lax | grep user
ps lax | grep python

grep user
grep temp ~
grep temp temp/
grep l cybersecurity-portfolio/

printf "apple\nbanana\napricot\ncherry\navocado\n" > fruits.txt
cat fruits.txt
grep a fruits.txt

alias
```

Not every command succeeded.

That is intentional evidence: I used incorrect combinations and inputs to understand **why** they failed rather than only recording successful commands.

---

# BIGGEST EXPERIMENTS TODAY

### 1. Manual PPID climb

I followed process ancestry instead of merely reading a definition of PPID.

### 2. Two-terminal test

I predicted that two Bash sessions should be separate processes, then verified:

```text
different terminal
→ different Bash process
→ different PID
→ different TTY
```

### 3. `ps` format exploration

I read the actual `ps` help and tested valid and invalid combinations instead of memorizing one screenshot.

### 4. `grep` stress testing

I intentionally searched:

* words
* users
* Python
* TTY text
* numbers
* directories
* a controlled fruit file

until I could explain why the outputs differed.

---

# KEY RULES TO KEEP

* A program on disk is not automatically a running process.
* A process is a running execution context managed by the kernel.
* One program can have multiple simultaneous processes.
* PID identifies a process; PPID provides its parent relationship.
* Bash is a shell; the terminal is not the shell.
* Bash requests operating-system work; the kernel performs kernel-owned process management.
* Bare `ps` is a narrow snapshot, not every process on Linux.
* Different `ps` formats may change both process selection and displayed columns.
* `ps aux` does not normally contain PPID.
* `TTY ?` means no controlling terminal — not "unknown" or "malicious."
* `grep` filters text lines based on a pattern.
* `grep` does not understand the semantic meaning of `ps` columns.
* A matching line still needs interpretation.
* `grep` can match its own process command line.
* A pipe connects one command's output to another command's input.
* A process name by itself is weak security evidence.
* PPID relationships can provide useful investigative context.
* Dynamic PIDs should not be treated as permanent identifiers.

---

## CURRENT LEVEL STATUS

```text
Level 8.1 — Process Observation
STATUS: PRACTICED + EXPLAINED ✅
```

I did not just run `ps` once.

I tested process selection, process ownership, parent relationships, terminal association, multiple shell instances, output formats, help discovery, pipe-based filtering, false-positive text matches, invalid syntax, and controlled `grep` input.

**Next:** continue to the next Level 8 Process Management sub-level.
