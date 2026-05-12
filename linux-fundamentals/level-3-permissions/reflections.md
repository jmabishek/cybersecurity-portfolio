DAY - 3 REFLECTIONS

Day 3 was the day I stopped just learning commands
and started understanding the philosophy of how
Linux protects itself.

Going in, I thought permissions would be a small
topic - maybe just a few numbers to memorize.
755 here, 644 there, done. I was completely wrong.
What I got instead was a full architecture lesson
about how authority works on a computer.

The 4-2-1 binary thing was the first surprise.
At first it felt random - why 4, 2, 1? Why not
5, 6, 7? But once I worked through the math, I
saw it wasn't a designer choice at all. It was
the math forcing the choice. Each rwx slot is
one bit, and three bits in binary HAVE to use
place values 4, 2, and 1 if you want every
combination to produce a unique number AND fit
in a single digit. Any other numbers either skip
values or overflow into two digits. That kind of
why blew my mind. The designers didn't pick 4-2-1.
The mathematics did.

Then came the difference between numeric and
symbolic chmod. At first I didn't understand why
both existed if they did the same thing. I pushed
back when the explanation felt rushed - and I'm
glad I did, because the deeper version made it
click. Numeric replaces all 9 bits at once.
Symbolic touches only the one bit you name.
Numeric is what scripts and audits use because
it's deterministic - same command, same result,
every time. Symbolic is what real people use at
the keyboard, especially during incidents, because
you don't want to wipe what's already there. You
just want to flip one bit fast.

The deepest insight of the day was about ownership.
I asked - if anyone can run chmod, can a random
user just change permissions on sensitive files?
The answer was no, and the reason rewrote how I
think about Linux. Only the owner (or root) can
chmod a file. The rwx bits don't control who can
change permissions. The lock on the lock is
OWNERSHIP. That's the whole foundation.

This is called Discretionary Access Control - DAC.
The owner has discretion over their own files.
Root has discretion over everything. Other users
are guests. They can read or write what the owner
chose to give them, but they can't promote
themselves. The whole architecture protects itself
through this one rule.

I also realized why chown exists, and why only
root can use it. If any user could transfer
ownership, the entire model would collapse - people
could steal files, frame others, hide attacker
activity by laundering ownership. So chown is
locked behind root. It's the supreme jewel of the
system. We parked the actual chown practice for
laptop in May because Termux is single-user and
sandboxed, but I understand the concept fully.

I built a king-and-jewel analogy for this myself.
Root is the supreme king. Owners are state rulers
with full power inside their states but no power
outside. chmod is the ruler's authority within
their state. chown is the king's jewel - only one
exists in the kingdom, and only the king can use
it. That picture made everything fit together.

The mini-boss felt small after all that depth.
I had to create secret.txt, write something inside,
lock it to 600, verify with ls -la, and explain
each permission symbol. I noticed Termux had
already set it to 600 by default thanks to umask,
so my chmod 600 was technically a no-op. But I
ran it anyway, and I'm glad I did. The lesson
was - in real security work, you enforce the safe
state explicitly even when it looks correct.
Trust nothing. Enforce always. That's idempotent
hardening, and pros do it in every audit script.

What I'm taking from Day 3 - permissions aren't
about memorizing numbers. They're about
understanding the architecture of trust on a
computer. Who owns what. Who can change what.
Why the system can't be undermined just because
someone has access to a terminal. Linux doesn't
trust users. It trusts owners. And it trusts root
above all. Once I saw that, the numbers and flags
became easy. The hard part was the philosophy.

Looking forward to Day 4 - networking. Spider-Man
is next.
