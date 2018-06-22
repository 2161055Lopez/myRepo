#!/bin/csh -fbvx
set ifExist = `./exist.csh $1`;
set filename = "tipiTester.xml";
set totalLines = `wc -l < tipiTester.xml | tr -d ' '`
echo $filename

if($ifExist == "empty") then
        set lineNumber = `grep -nw 'stations' $filename | cut -d ':' -f 1 | head -1`

        @ lineNumber += 1
        echo $lineNumber;
        set lineNumber2 = `grep -nw 'stations' $filename | cut -d ':' -f 1 | tail -1`
        echo $lineNumber2;
        touch temp
        echo $1 > temp
        set lPattern = `cut -c1-2 temp`
        set nPattern = `cut -c3- temp`
        rm temp
        echo $lPattern
        echo $nPattern

        set highest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -c3- | tail -1`
        echo $highest

        set lowest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -c3- | head -1`
        echo $lowest

        if("$nPattern" < "$lowest") then
                set highestLine = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tr -d ' ' | sed -n -e '1p'`
                @ highestLine -= 1
                echo $highestLine
                sed -n -e "1,${highestLine}p" tipiTester.xml > upTemp
                @ highestLine += 1
                sed -n -e "${highestLine},${totalLines}p" tipiTester.xml > downTemp
                echo "	<station>$1</station>" >> upTemp
        cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp
        endif

	if("$nPattern" > "$highest") then
		set lowestLine = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tail -1 | tr -d ' '`
		echo $lowestLine
		sed -n -e "1,${lowestLine}p" tipiTester.xml > upTemp
		@ lowestLine += 1
		sed -n -e "${lowestLine},${totalLines}p" tipiTester.xml > downTemp
		echo "	<station>$1</station>" >> upTemp
		cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp	
	else 
		set x = 1
		set condition = no
		while ($condition == "no")
		set current = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -c3- | sed -n -e "${x}p"`
		echo this is the current $current
			if ($current > $nPattern) then
				unset condition
				set condition = yes	
			else 
			@ x++
			endif
		end
		@ x -= 1
		echo $x
		set lowestLine = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | sed -n -e "${x}p" | cut -d '<' -f 1 | tr -d ' '`
		echo $lowestLine
		sed -n -e "1,${lowestLine}p" tipiTester.xml > upTemp
		@ lowestLine += 1
		sed -n -e "${lowestLine},${totalLines}p" tipiTester.xml > downTemp
		echo "	<station>$1</station>" >> upTemp
		cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp 
	endif 
endif 
