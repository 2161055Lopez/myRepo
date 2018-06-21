#!/bin/csh
set ifExist = `./exist.csh $1`;
set filename = "tipiTester.xml";
if($ifExist == "exist") then
        set lineNumber = `grep -nw 'stations' $filename | cut -d ':' -f 1 | head -1`;
        echo $lineNumber;
        set var = p;
        set value = `sed -n -e "$lineNumberp" $filename | grep 'stations'`;
        echo "this is the value: $value";
        if($value  == "")
        @ lineNumber += 1;
        endif
#       echo $lineNumber;
else
        echo "I am not here";
endif

