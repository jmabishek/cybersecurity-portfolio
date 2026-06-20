# Level 7.1 — Reflections

## What this section was

The entry point of Level 7. Not heavy scripting —
this was about understanding what makes a script
a real deployable tool instead of a practice file.

Three things came together: knowing how to navigate
and edit scripts properly in nano, understanding what
the shebang line actually does, and making scripts
executable so they run themselves.

## What confused me and what clicked

The shebang confused me first because I thought
whatever I run already runs in my shell — so why
add a line saying run it in bash? The confusion was
because I was thinking about source, where the current
shell handles everything.

It clicked when I connected dot slash to the shebang.
Dot slash just says run this file. The shebang says
use this program to run it. They depend on each other
but each does its own individual job. Without the shebang,
dot slash makes the system guess. With it, bash is named
explicitly before any code runs.

## chmod +x — not fixing something broken

chmod +x did not fix a problem. It upgraded something
manual into something cleaner. Before it, I typed bash
or source every time. After it, the file executes itself.
The green color in ls is also useful — instantly visible
which files are ready to run without reading permissions.

## nano — what actually changed

Before this session I was surviving in nano. Backspace
and retype. Exit without saving when something went wrong.
Lost a long script once because the system shut down before
I saved it.

The shortcuts that change the most: Ctrl+Shift+_ because
bash gives you the error line number and now I can jump
directly there. Ctrl+K and Ctrl+U because cutting and
pasting a line is faster than rewriting it from scratch.

## Connection to the spine

Every script written from Level 7 onward starts with
#!/bin/bash on line 1 and needs chmod +x to run properly.
This is what J.A.R.V.I.S — Git — will track. Not practice
files but real executable tools. When cron runs scripts
automatically in Level 10, it uses dot slash. The shebang
is what makes that work without a human present.

