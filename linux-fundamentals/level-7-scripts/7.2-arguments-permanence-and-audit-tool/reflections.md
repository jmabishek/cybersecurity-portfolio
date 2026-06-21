# Level 7.2–7.4 — Reflections

**Date:** 21 June 2026

Today was not about the commands. The commands (`$1`, `$@`, `$#`, PATH, `.bashrc`) were the easy part — I'd already done the genuinely hard conceptual work in Levels 5 and 6 with loops, nesting, and conditions. Today was the first time I built a *real tool* from nothing but a written spec, with no code handed to me. That's a different skill, and most of the effort went into the engineering around the commands, not the commands themselves.

The bugs were the lesson. `local` only works inside a function. A function defined but never called does nothing — which is why `source` ran my script but `./audit.sh` sat dead silent until I added `audit "$1"` myself. PATH holds folders, not files. A comma instead of a dot gives the identical "command not found" as a real PATH miss. Each of these cost me time, and each one taught more than the working version did.

A real part of today's work was managing the *process* — pushing back when the teaching pace was wrong, insisting on the full spec instead of being drip-fed one brick at a time, keeping the session honest. That took as much energy as the technical side, and it's a skill in itself.

The clearest thing I learned about myself today: my gap right now is not difficulty, it's **breadth**. I can reason through hard logic, but I'm missing the everyday workhorse commands that tool-building actually leans on — `date`, `wc`, `find`, redirection, and the dozens like them. I noticed it mid-build, reaching for commands I didn't have. That's the direction I'm taking next.

**Next session:** a full practice session at sound level — building several small, real, industry-style tools back to back, specifically to drill the common navigation and tooling commands until they're muscle memory. Not new hard concepts. Fluency with the everyday ones, so building tools becomes fast instead of a fight.
