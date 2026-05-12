DAY - 2 REFLECTIONS

Day 2 was way harder and way deeper than Day 1.

I learned so many commands today, so many use
cases, and went much deeper into the cybersecurity
world and how it actually works.

I learned cp (copy), mv (move), and how flags
operate on them. Honestly, I was very confused
about the basics of mv and cp at first. I used
to think cp just copies and mv just moves. Nope.
mv actually does renaming too, depending on the
conditions. I learned the conditions:

- If a file with the same name already exists at
  the destination, mv overwrites it.
- If the destination is in the same directory and
  the name is different, mv renames the file.
- If the destination doesn't exist, mv basically
  renames as it moves.

cp behaves the same way - if you're copying to
a directory and the destination file doesn't exist,
cp creates it for you with whatever name you gave.

The thing both cp and mv have in common - they
DON'T ASK. No "are you sure?" pop-up. No warning
that data already exists at the target. They just
do it. They replace whatever's there. That made
me realize how essential it is to always know
where I'm taking the data from and where I'm
putting it. Verification before action.

Same lesson with rm. Plain rm removes files.
Add -r and it's recursive - it deletes everything
from the top folder all the way down to the
deepest sub-folder. Files, folders, all of it.
But the most dangerous combo is -rf. That's fast,
silent, and suppresses errors. No turning back
once I run it. The session also taught me real
protocols to keep in mind before using these
commands - pwd and ls first, every time.

Then I learned cat, nano, and touch - exciting
tools to work with. I have Notepad on Windows,
and now nano is my notepad inside the terminal.
cat is how I look at the data inside a file.
touch is how I create one. The fascinating thing
about touch - it uses ZERO storage to create a
file. 0 bytes. An empty file just sits there,
existing, waiting to be filled. That blew my mind.

The more I'm learning, the more excited I get -
like a kid wandering into a big park, a big
jungle. It was exciting and informative at the
same time. I'm not just learning commands - I'm
learning WHY they exist, why they're foundational
in the professional world, and how attackers and
defenders use the SAME tools for completely
different purposes.

Really looking forward to Day 3.
