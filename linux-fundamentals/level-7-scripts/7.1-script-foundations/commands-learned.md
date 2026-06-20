# Level 7.1 — Script Foundations · Commands Learned

## nano navigation shortcuts
Ctrl+K           — cut entire line
Ctrl+U           — paste cut line anywhere
Ctrl+W           — search inside file, jump to first match
Ctrl+Home        — jump to top of file instantly
Ctrl+End         — jump to bottom of file instantly
Ctrl+Shift+_     — jump to specific line number
                   critical for debugging: bash reports error
                   on line 47, this takes you there directly
Ctrl+O           — save file (WriteOut)
Ctrl+X           — exit nano

## shebang line
#!/bin/bash
First line of every script. Before this line existed,
running ./script.sh made the system guess which program
should open the file. The shebang removes the guessing.
It tells the system exactly: use bash at /bin/bash
to execute everything below this line.

## chmod +x
chmod +x filename.sh
Gives the file executable permission.
Before: had to type bash or source manually every time.
After: the file runs itself when called with ./
The file turns green in ls output — visual signal
that it is now executable.

## three ways to run a script
source filename.sh   — runs in current shell
                       variables leak in from outside
                       use when loading functions into
                       your live terminal session
bash filename.sh     — runs in clean shell
                       no variable leaking
                       you provide bash manually
./filename.sh        — file runs itself
                       uses shebang to know which program
                       only works after chmod +x
                       how scripts run in automation

## dot slash and shebang — they need each other
./  says: run this file
#!/bin/bash says: use bash to run it
Neither works alone for the full picture.
