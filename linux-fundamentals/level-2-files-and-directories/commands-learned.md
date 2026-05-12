DAY - 2 NOTES

mkdir - makes directories (only folders, not files)
   mkdir name = one folder
   mkdir -p a/b/c = builds the whole chain at once
       -p is safe to re-run, won't crash
   mkdir -p test/{a,b,c} = makes a, b, c
       all inside test in one shot (brace expansion)
   mkdir f1 f2 f3 = multiple folders side by side

touch - makes empty files (0 bytes)
   touch file.txt = one file
   touch f1 f2 f3 = multiple at once
   Files and folders are separate things.
   A folder is just a list pointing to files.

cat - reads file contents
   cat file = whole file
   cat -n file = with line numbers
   cat f1 f2 = reads multiple back-to-back
   Empty file = no output. Success, just nothing to show.

echo with > - write into a file
   echo "hello" > file.txt
   ">" overwrites whatever was there. No warning.
   ">>" appends instead (will learn properly later)

cp - copy
   cp file newfile = copies a file
   cp -r folder newfolder = copies folder + everything in it
   Without -r on a folder, cp refuses. Safety thing.
   cp gives the copy a NEW timestamp.

mv - move and/or rename
   mv old new = rename
   mv file folder/ = move
   mv file folder/newname = move + rename together
   mv f1 f2 f3 folder/ = multiple at once
   mv KEEPS the original timestamp.
   Forensic clue: new timestamp = cp, old = mv.

rm - delete (gone forever, no recycle bin)
   rm file = one file
   rm -r folder = folder + contents
   rm -rf folder = force + recursive (most dangerous)
   rmdir folder = empty folders only
   Rule: don't reach for -f unless I actually need it.

nano - simple editor
   nano file.txt = open
   Ctrl+O = save
   Ctrl+X = exit
   Ctrl+W = search

ls -R - recursive listing
   Shows the full tree from where I am.

THINGS THAT CLICKED HARD
- Linux fails LOUDLY, succeeds SILENTLY.
- It overwrites without asking. No confirmation pop-up.
- If destination exists as folder = source nests inside.
- If destination doesn't exist = source becomes the destination.
- mv is instant even on huge files (only the pointer moves).
- cp actually reads and writes every byte.
- mkdir -p is forgiving, regular mkdir is not.
- pwd + ls before anything destructive. Always.
