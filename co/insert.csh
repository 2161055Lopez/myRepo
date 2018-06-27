#!/bin/csh -fbvx
###############################################################################################################################
# This script inserts a tester to the tipiTester.xml file.
# First, it will retrieve a value by calling the "ifExist.csh" script and store it in the "ifExist" variable.
#	CASE 'A':
#		-If the variable is equal to "A", it means that the tester does not exist in both the stations and the stationGroup list.  	
#		-It will then retrieve the line number of the "<station>" and "</station>" tags. These line numbers will serve as the boundary for the testers that will be manipulated. It will then add the tester to the station list sorted by name in an ascending order. After that, it will then call the "insert2.csh" to add the tester to its specific group and cluster.
#	CASE 'B':
#		- if the variable is equal to "B", it means that the tester exist in the stations but not in the stationGroup list. It will then call the "insert2.csh" to add the tester to its specific group and cluster.
#	CASE 'C': 
#		- if the variable is equal to "C", it means that the tester does not exist in the station but it exist in the sstation list. Therefore it will delete the tester in the stationGroup list and proceeds to CASE 'A'.
#	CASE 'D':
#		- if the variable is equal to "D", it means that the tester already exists in both the stations and stationGroup list.
#
# PARAMETERS:	tester($1), group($2), cluster($3)
###############################################################################################################################

./backup.csh
set ifExist = `./exist.csh $1`;
set filename = "tipiTester.xml";
set totalLines = `wc -l < tipiTester.xml | tr -d ' '`
echo $filename

if($ifExist == "A" || $ifExist == "C") then

		if ($ifExist == "C") then
			./delete.csh $1
		endif
		
        set lineNumber = `grep -nw 'stations' $filename | cut -d ':' -f 1 | head -1`
        @ lineNumber += 1
        set lineNumber2 = `grep -nw 'stations' $filename | cut -d ':' -f 1 | tail -1`
        touch temp
        echo $1 > temp
        set lPattern = `cat temp | tr -d '-' | cut -c1-2`
        set nPattern = `cat temp | tr -d '-' | cut -c3-`
        rm temp
		
		if($lPattern == "93") then
			touch temp
			echo $1 > temp
			unset lPattern
			set lPattern = `cat temp | tr -d '-' | cut -c1-3`
			unset nPattern
			set nPattern = `cat temp | tr -d '-' | cut -c4-`
			rm temp
			set highest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | tail -1`		
			set lowest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | head -1`
		else 
			set highest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | tail -1`

			set lowest = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | head -1`
		endif

        if("$nPattern" < "$lowest") then
            set highestLine = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tr -d ' ' | sed -n -e '1p'`
            @ highestLine -= 1
            sed -n -e "1,${highestLine}p" tipiTester.xml > upTemp
            @ highestLine += 1
            sed -n -e "${highestLine},${totalLines}p" tipiTester.xml > downTemp
            echo "	<station>$1</station>" >> upTemp
			cat upTemp downTemp > tipiTester.xml
			rm upTemp downTemp
			
			./insert2.csh "$1" "$2" "$3" 

		else if("$nPattern" > "$highest") then
			set lowestLine = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tail -1 | tr -d ' '`
			sed -n -e "1,${lowestLine}p" tipiTester.xml > upTemp
			@ lowestLine += 1
			sed -n -e "${lowestLine},${totalLines}p" tipiTester.xml > downTemp
			echo "	<station>$1</station>" >> upTemp
			cat upTemp downTemp > tipiTester.xml
			rm upTemp downTemp	
			
			./insert2.csh "$1" "$2" "$3" 
			
		else 
			set x = 1
			set condition = no
			while ($condition == "no")
			
				if($lPattern == "93K") then
					set current = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | sed -n -e "${x}p"`
				else
					set current = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | sed -n -e "${x}p"`
				endif
				
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
			
			./insert2.csh "$1" "$2" "$3" 
		endif 
else if ($ifExist == "B") then
	
	./insert2.csh "$1" "$2" "$3" 
	
else if ($ifExist == "D") then
	echo ALREADY EXISTS IN BOTH THE STATION AND STATIONGROUPS
endif
