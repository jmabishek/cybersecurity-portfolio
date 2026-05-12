# Level 4 — Variables and Environment
## Personal Reflections

This file is in my own words. Future me — when you read
this, the goal is to remember what this level FELT like
to learn, not just what was taught.

═══════════════════════════════════════════════════════════════
WHAT I LEARNED THIS LEVEL
═══════════════════════════════════════════════════════════════

I learned what variables and environment variables are, and
how they affect Linux systems. There are two types for me —
normal variables that I assign personally, and environment
variables that the system sets up automatically. They play a
major part in day-to-day commands, especially $PATH which I
now rely on heavily in my mental model.

The variables turned out to be very different from what I
first thought. They look simple, but the way they actually
function — with the $ sign, with quotes, with assignment
rules — that's a whole concept I had to absorb. I also
learned why variables are kept isolated by default — to
protect the system from being misused carelessly.

Aliases were a wonderful learning. They have a similar
feel to variables but work differently — aliases aren't
"stored" in the shell; they're recreated every time the
terminal opens, by reading them from a file. The same
isolation rule applies — aliases don't pass to child shells.

The trickiest thing I learned during the Mini Boss was
this: when you update a variable that's used inside an
alias, the alias does NOT auto-update. The change isn't
read by the shell. You have to redefine the alias entirely
with the new value for it to actually use the new path.
That was very shocking for me.

I also learned why spaces matter when assigning variables
and aliases, the rules for each one, what happens with
single vs double quotes — all the small mechanics that
make Level 4 actually work in practice.

I learned the limits of export and why we use it. I learned
how parent and child shells relate, what $PPID is and how
shell-within-shell actually behaves, and how shells
recognize their parents. It was a lot. And I'm excited to
keep going — this level made me fall more deeply in love
with the subject. I hope I keep working toward the goal.

═══════════════════════════════════════════════════════════════
WHAT CLICKED MOST NATURALLY
═══════════════════════════════════════════════════════════════

Aliases clicked very naturally for me. The concept of
"give a short word to a long command" made instant sense.
I enjoyed learning aliases so much that I built my own
toolkit during the session — three aliases I designed for
my .bashrc workflow:

  alias cbc="cat ~/.bashrc"     (view bashrc contents)
  alias nbc="nano ~/.bashrc"    (edit bashrc)
  alias sbc="source ~/.bashrc"  (reload bashrc)

These three together form my professional edit-loop —
view, edit, reload. I built them because I noticed I was
typing the long paths over and over and figured I could
shortcut them. That instinct alone — "if I'm typing this
twice, there should be an alias" — felt like a real
unlock for me.

Environment variables, on the other hand, shocked me.
Even the most basic commands I'd been using my whole
journey turned out to be quietly relying on environment
variables in the background. Now I'm curious about why
servers and terminals use so many of these — to navigate
safely without disturbing the system. There's a whole
layer of "invisible plumbing" that I hadn't seen before.

═══════════════════════════════════════════════════════════════
WHAT WAS HARDEST
═══════════════════════════════════════════════════════════════

The hardest part for me was variables — specifically
$PATH. $HOME and $PWD I understood quickly: $HOME is a
fixed permanent path; $PWD changes with the current
location. That distinction landed cleanly.

But $PATH hit me hard. I used to think it was a program,
or some kind of system tool. Eventually I understood it's
just a list of folders that the shell searches through to
find a command, in order, until it finds a match. Nothing
more, nothing less. Once that clicked, the whole "first
match wins" rule and the PATH hijacking attack made sense.

Single vs double quotes also surprised me. I never thought
they'd behave so differently with $variables inside. Once
I saw the proof in Termux, I locked it in — but my first
prediction was wrong, and that taught me something about
trusting experiments over intuition.

I also learned how variables actually work inside echo
statements — that was a real "aha" moment for me.

═══════════════════════════════════════════════════════════════
WHAT SURPRISED ME MOST
═══════════════════════════════════════════════════════════════

The biggest surprise was that Linux has its own
predetermined rules — its own internal logic that I have
to learn, not just commands I memorize.

Shell-within-shell was a real eye-opener. I didn't even
know you could have a shell inside another shell. The
working conditions I now understand, but the deeper
mechanics still feel like an enigma I'm excited to revisit
in future levels. I know I'll be using this concept at
much larger scale soon.

What really surprised me about $PPID is how it works
through the family tree. If you ask shell three about its
parent, it doesn't say shell one — it says shell two.
Each shell only knows its IMMEDIATE parent. To trace the
whole ancestry, you have to walk the chain step by step.
That's a clever design — it keeps each process running
independently without interfering with the others, and it
also makes it harder for an attacker to obscure their
trail because each link in the chain is verifiable.

The eager expansion rule for aliases — that aliases
freeze the variable's value at definition time — I
learned the hard way through my own practice. I changed
the variable, ran the alias, and watched the alias use
the OLD value. I had to redefine the alias entirely to
get the new value. Very surprising at first, very
sensible in retrospect.

The empty $USER on Termux made sense once I thought
about it. Termux runs as an Android app, not as a real
Linux login session. Linux doesn't recognize this
environment as a legitimate login the same way it would
on a server. So $USER is empty — but whoami and
$LOGNAME still work, because they query different
sources. That tells me something about how Termux is
structured underneath.

═══════════════════════════════════════════════════════════════
WHAT I DISCOVERED ON MY OWN
═══════════════════════════════════════════════════════════════

unset and unalias commands — I discovered these by
playing in Termux when I needed to remove something I'd
created. It gave me a new perspective: when learning a
command, I should also learn how to UNDO it. That's a
new principle for me going forward.

The .bashrc helper toolkit (cbc, nbc, sbc) — I built
these myself because I got tired of typing the long
forms repeatedly. I just got curious if I could turn
them into small aliases to save time. They're now part
of my permanent workflow.

The eager expansion rule — I figured this out by
experimenting in Termux during Mini Boss Task 5. I
wanted to learn not just in the traditional way the
roadmap teaches, but as a real professional would.
That's why I push to go deeper than just memorizing
commands.

$PPID points to immediate parent only — I noticed this
during the shell-within-shell experiment. It surprised
me, but it's actually a clever design — both for clean
process flow and for making attackers' trails harder to
obscure.

Aliases are workflow-personal — I derived this in Task 6.
Aliases are personal preferences for professionals
working on Linux. They differ from professional to
professional, from architect to intern. So aliases must
match the user and the task they're working on, so they
don't accidentally affect the workflow or the
environment of the system. That also matters for safety.

═══════════════════════════════════════════════════════════════
METAPHORS I BUILT THIS LEVEL
═══════════════════════════════════════════════════════════════

1. INHERITANCE ANALOGY for export:
   Export is like giving your property rights to your
   children — but only what you specifically marked for
   them. They don't inherit everything; they inherit
   what you chose to share.

2. PERSONAL PREFERENCES vs SHARED SYSTEM:
   Aliases are personal preferences (workflow-specific,
   per-user). Variables can be shared across processes
   if exported. Different scopes for different jobs.

3. SHELL HIERARCHY as FAMILY TREE:
   If you ask shell three about its parent, it says
   shell two — not shell one. Each shell knows only
   its immediate parent. The family tree exists, but
   each process can only see one link up.

4. SHELL-WITHIN-SHELL as TASK DELEGATION:
   I imagine running a long log-monitoring task. I
   need to record every minute, but doing it manually
   is impossible. So I delegate to the child shell:
   "you watch the time and update me every minute,"
   while the parent shell does the main monitoring
   work. Two processes, two responsibilities, running
   together. That's a shell-within-shell pattern.

5. VARIABLES as a SPY BLENDING IN:
   Variables are like survival instincts — they let
   you blend invisibly into the environment. They
   don't announce themselves; they just exist quietly
   and do their job when called.

6. ALIASES as JARVIS COMMANDS:
   Aliases are like asking JARVIS to do a big task.
   Instead of writing the full program every time,
   you just assign one short command — "start" —
   and the whole pre-defined sequence runs: start
   the power grid, light the display, calculate the
   power output, scan the surroundings. One word,
   massive program executed.

═══════════════════════════════════════════════════════════════
HOW I WILL USE THIS PROFESSIONALLY
═══════════════════════════════════════════════════════════════

In SOC work, my Level 4 knowledge will matter at every
step of an investigation.

The first thing I would NOT do is run "ls" or any other
basic command without thinking. If an attacker has
modified my .bashrc, even my standard commands could be
compromised — they could be aliased to malicious
versions, or my $PATH could be hijacked to execute the
attacker's tools instead of the system's. So step zero
in any incident is verifying my own environment is
trustworthy:

  - Check .bashrc for unknown aliases or persistence
  - Check $PATH for suspicious folder ordering
  - Confirm my tools aren't tampered with before using them

ONLY after I trust my environment do I move to
investigation:

  - Walk the process lineage ($PPID chains) to find
    out which shell launched what, and where the
    attacker entered the system
  - Check shell history for what commands ran
  - Check hidden files (anything starting with .)
    for malware staging
  - Look at log files for the exact moment the
    escalation began

Once I understand where the attacker is and what
they've touched, I either contain immediately
(close the entry point, lock down compromised
permissions to 000 or 700, escalate to L2/L3/L4)
or I track silently while colleagues coordinate
containment in parallel.

The principle I learned in Level 4 that I'll carry
forward: BEFORE acting, verify the environment.
This is environment integrity. Variables, aliases,
and .bashrc all become attack surfaces in the
wrong hands, so they must be trusted before they
can be used.

═══════════════════════════════════════════════════════════════
QUESTIONS I STILL HAVE
═══════════════════════════════════════════════════════════════

Until I get a laptop, my understanding is solid as far
as my visualization and reasoning go. As long as I can
visualize a concept clearly and understand it at the
core, I count it as a win.

Termux is doing its job for now — I can practice
everything that doesn't require a full Linux
environment. When I get the laptop, I expect to be
even more thrilled to work on a real terminal where I
can stress-test my mental models against real Linux
behavior.

═══════════════════════════════════════════════════════════════
OVERALL FEELING ABOUT LEVEL 4
═══════════════════════════════════════════════════════════════

Level 4 is solid. I built my own toolkit, I made my own
discoveries, I survived a Mini Boss designed at
professional interview level. I'm ready for Level 5.

═══════════════════════════════════════════════════════════════
END OF REFLECTIONS
═══════════════════════════════════════════════════════════════
