# Level 4 — Variables and Environment
## Commands Learned

═══════════════════════════════════════════════════════════════
SECTION 1 — VARIABLES (Sub-Level 4.1)
═══════════════════════════════════════════════════════════════

## Creating a variable

Syntax: name="value"

Critical rule: NO SPACES around the = sign.
  name="abhi"      ✅ correct
  name = "abhi"    ❌ broken (shell reads name as command)

Example:
  $ name="abhi"
  $ age=21

Variables are silent on creation (Linux fails loudly,
succeeds silently).

## Reading a variable

Syntax: $name (the $ is the "open the box" signal)

Examples:
  $ echo $name        → abhi
  $ echo name         → name (literal, no expansion)
  $ echo "$name"      → abhi (expansion in double quotes)
  $ echo '$name'      → $name (single quotes block expansion)

The technical name for $-replacement is VARIABLE EXPANSION
(or PARAMETER EXPANSION). Shell expands $name to its value
BEFORE the command runs.

## Quote rules

| Quote type        | Variable expansion? |
|-------------------|---------------------|
| "double quotes"   | ✅ YES              |
| 'single quotes'   | ❌ NO               |
| no quotes         | ✅ YES (default)    |

Use double quotes for most strings (handles spaces in
filenames safely while allowing variables).
Use single quotes when you need literal $ in output
(currency, regex, documentation examples).

## Removing a variable

Command: unset
  $ unset name

═══════════════════════════════════════════════════════════════
SECTION 2 — ENVIRONMENT VARIABLES (Sub-Level 4.2)
═══════════════════════════════════════════════════════════════

## What they are

Pre-set variables Linux fills in automatically when your
shell starts. Convention: ALL CAPS naming.

## Common environment variables

| Variable    | What it holds                              |
|-------------|--------------------------------------------|
| $HOME       | home folder path (permanent, set at login) |
| $PWD        | current working directory (live, changes)  |
| $USER       | username (often empty on Termux — quirk)   |
| $LOGNAME    | reliable Termux fallback for $USER         |
| $SHELL      | path to shell binary running this session  |
| $PATH       | colon-separated folder list for commands   |

## Inspecting environment variables

Commands:
  $ echo $HOME            → /data/data/com.termux/files/home
  $ echo $PWD             → current location
  $ echo $SHELL           → /data/.../usr/bin/bash
  $ echo $PATH            → /usr/bin:/system/bin:...
  $ env                   → list ALL environment variables

## Key distinction: $HOME vs $PWD

  $HOME = permanent. Set at login. Never changes.
  $PWD  = live tracker. Changes every cd.

  ~ is a SHORTCUT SYMBOL that expands to $HOME.
  pwd is a COMMAND that prints $PWD.

## $PATH and command lookup

When you type a command:
  1. Shell reads $PATH
  2. Splits on : separator
  3. Searches each folder LEFT TO RIGHT
  4. FIRST MATCH WINS — search stops there
  5. If no match → "command not found"

Inspecting which file gets found:
  $ which ls            → shows the actual file path
  $ which cat
  $ which echo

═══════════════════════════════════════════════════════════════
SECTION 3 — EXPORT AND PROCESS HIERARCHY (Sub-Level 4.3)
═══════════════════════════════════════════════════════════════

## Process isolation

Every shell has its own private memory.
Variables created in one shell DO NOT exist in another.
This is true even for child shells launched from within.

Demonstrated with:
  $ my=name
  $ bash               (launches child shell)
  $ echo $my           → empty (child has no copy)
  $ exit
  $ echo $my           → name (back in parent, intact)

## export — making variables inheritable

Command: export VAR
  $ my=name
  $ export my
  $ bash
  $ echo $my           → name (now inherited!)

Rules:
  - export only works on VARIABLES, not aliases
  - Inheritance is ONE-WAY (parent → child only)
  - Children's changes do NOT flow back to parent
  - Inheritance is OPT-IN by default

What inherits to children:
  ✅ Exported variables
  ❌ Plain (non-exported) variables
  ❌ Aliases
  ❌ Shell functions
  ❌ Shell history
  ❌ Shell options

## Process hierarchy commands

  $ echo $$           → current shell's PID
  $ echo $PPID        → IMMEDIATE parent's PID
  $ echo $SHLVL       → nesting depth (1, 2, 3 as you nest)

Critical rule: $PPID is the IMMEDIATE parent only.
NOT the grandparent. NOT the original shell.
Lineage must be walked one step at a time.

## Architecture layers

Terminal (Termux app) → Shell (bash) → Kernel (Linux) → Hardware

Each layer talks only to its neighbors. The terminal is
"dumb" (just I/O). The shell interprets and dispatches.
The kernel runs programs against hardware.

═══════════════════════════════════════════════════════════════
SECTION 4 — ALIAS AND .BASHRC (Sub-Level 4.4)
═══════════════════════════════════════════════════════════════

## Creating aliases

Syntax: alias name="command"
  Same rule as variables: NO SPACES around =

Examples:
  $ alias ll="ls -la"
  $ alias cls="clear"
  $ alias cbc="cat ~/.bashrc"
  $ alias nbc="nano ~/.bashrc"
  $ alias sbc="source ~/.bashrc"

## Listing and removing aliases

  $ alias              → list all current aliases
  $ unalias name       → remove a specific alias
  $ \command           → bypass alias for one execution
                         (e.g., \ls runs the real ls)

## Where aliases live

Aliases live in a separate ALIAS TABLE in shell memory.
Distinct from variables. export does NOT affect them.
Aliases are session-only by default — vanish on shell close.

## .bashrc — the persistence file

Location: ~/.bashrc (in your home folder)
Type: regular text file
Purpose: bash reads this file ONCE at startup and runs
         every line in it.

Creating/editing:
  $ nano ~/.bashrc

Format (one alias per line):
  alias ll="ls -la"
  alias cls="clear"
  alias cbc="cat ~/.bashrc"

## The professional edit loop

  1. nano ~/.bashrc        ← edit
  2. (add aliases, save with Ctrl+O, exit with Ctrl+X)
  3. cat ~/.bashrc         ← verify content
  4. source ~/.bashrc      ← reload into current shell
  5. test the new alias

CRITICAL: Editing .bashrc does NOT auto-apply.
Bash reads it once at startup. Edits require either:
  - source ~/.bashrc        (reload in current shell)
  - close and reopen Termux (restart bash entirely)
  - launch a child shell with bash (reads .bashrc fresh)

## source command

Syntax:
  $ source ~/.bashrc      (long form)
  $ . ~/.bashrc           (shorthand — note: this . is a
                           command, not the directory dot)

Effect: re-reads the named file and applies everything
in it to the CURRENT shell.

═══════════════════════════════════════════════════════════════
SECTION 5 — KEY RULES TO REMEMBER
═══════════════════════════════════════════════════════════════

1. No spaces around = in assignments (variables AND aliases).

2. $ before a name means "expand it" (variables only).
   No $ for alias names.

3. Single quotes block expansion. Double quotes preserve it.

4. Children inherit only the EXPORTED ENVIRONMENT.
   Plain variables, aliases, history, functions all stay
   behind in the parent.

5. $PATH order is a security decision. First match wins.
   PATH hijacking (MITRE T1574.007) is a real attack.

6. .bashrc edits don't auto-apply. Source it or restart.

7. EAGER EXPANSION RULE:
   When you write alias x="cd $myvar", the shell expands
   $myvar AT DEFINITION TIME. The variable name is gone —
   only the resolved value is stored. Changing the variable
   afterward does NOT change the alias.
   To update: redefine the alias entirely.

8. .bashrc is a security target. Attackers modify it for
   persistence (MITRE T1546.004). Always audit on
   suspected compromise.

═══════════════════════════════════════════════════════════════
SECTION 6 — COMMANDS DISCOVERED INDEPENDENTLY
═══════════════════════════════════════════════════════════════

These were not formally taught — discovered through
experimentation during the Mini Boss:

| Command          | What it does                            |
|------------------|-----------------------------------------|
| unset name       | Remove a variable                       |
| unalias name     | Remove an alias                         |
| \command         | Bypass alias for one execution          |

═══════════════════════════════════════════════════════════════
END OF COMMANDS LEARNED — LEVEL 4
═══════════════════════════════════════════════════════════════
