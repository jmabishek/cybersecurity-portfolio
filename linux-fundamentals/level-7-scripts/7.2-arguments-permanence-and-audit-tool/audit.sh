#!/bin/bash

# auditing an folder and its contents
# this was created my abhi on 21-06-2026
# it is limited to only one fOLDER per run
audit() {
local file="$1"
if [ -d "$file" ]; then
        touch $(date +%d-%m-%y).txt
                 echo "---->>>>>AUDIT REPORT OF $file<<<<<-----" >> $(date +%d-%m-%y).txt
           echo "list of files and folders" >> $(date +%d-%m-%y).txt
        ls "$file"/* | wc -l >> $(date +%d-%m-%y).txt
           echo "------LIST OF MODIFIED FILES ACCORDING TO TIME------" >> $(date +%d-%m-%y).txt
     ls -lt "$file"/* >> $(date +%d-%m-%y).txt
         echo "---------------------complited the audit of $file---------------------"
             else
                 echo "***$file not found***"
fi
}

audit $1
