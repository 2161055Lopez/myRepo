#!/bin/csh -fbvx

###############################################################################################################################
# This script inserts a tester in a specific floor and its cluster.
# First, it will retrieve the line numbers for the "<stationGroups>" and "</stationGroups>" tags. 
# Then it will retrieve the line numbers for the group specified in the parameter and its closing tag.
# using the line number of the group as the boundary, it will then retrieve the line number for the cluster specified in the parameter.
# The final line numbers extracted will server as the boundary for the testers that will be manipulated. It will then add the tester to the cluster sorted by name in an ascending order.
#
# PARAMETERS:	tester($1), group($2), cluster($3)  
###############################################################################################################################

set totalLines = `wc -l < tipiTester.xml | tr -d ' '`


#get the lineNumber for the stationsGroup
set lineNumber = `grep -nw 'stationGroups' tipiTester.xml | cut -d ':' -f 1 | head -1`
@ lineNumber += 1

#get the lineNumber for the closing tag of stationGroup
set lineNumber2 = `grep -nw 'stationGroups' tipiTester.xml | cut -d ':' -f 1 | tail -1`

#get the  lineNumber for the group
set group = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep -w "$2" | cut -d '<' -f 1 | tr -d ' ' | head -1`
@ group += 1

#get the lineNumber of the line
set line = `cat -n tipiTester.xml | sed -n -e "${group},${lineNumber2}p" | grep -w "$3" | cut -d '<' -f 1 | tr -d ' ' | head -1`
@ line += 1

#set the border for the line
set endLine = `cat -n tipiTester.xml | sed -n -e "${line},${lineNumber2}p" | grep "line" | cut -d '<' -f 1 | tr -d ' ' | head -1`
echo this is the endline $endLine
if ($endLine == "") then
	unset endLine
	set endLine = `cat -n tipiTester.xml | sed -n -e "${line},${lineNumber2}p" | grep "</group>" | cut -d '<' -f 1 | tr -d ' '`
	echo this is the endline $endLine
endif

touch temp
echo $1 > temp
set lPattern = `cat temp | tr -d '-' | cut -c1-2`
set nPattern = `cat temp | tr -d '-' | cut -c3-`
rm temp

set test = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tr -d ' ' | sed -n -e '1p'`

if ($test == "") then
	@ endLine -= 1
	sed -n -e "1,${endLine}p" tipiTester.xml > upTemp
	@ endLine += 1
	sed -n -e "${endLine},${totalLines}p" tipiTester.xml > downTemp
	echo "	    <station>$1</station>" >> upTemp
	cat upTemp downTemp > tipiTester.xml
	rm upTemp downTemp	
else
		
	if($lPattern == "93") then
		touch temp
		echo $1 > temp
		unset lPattern
		set lPattern = `cat temp | tr -d '-' | cut -c1-3`
		unset nPattern
		set nPattern = `cat temp | tr -d '-' | cut -c4-`
		rm temp
		set highest = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | tail -1`
		set lowest = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | head -1`
		else 
			set highest = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | tail -1`

			set lowest = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | head -1`
			
	endif

	if ($nPattern < $lowest) then

		set highestLine = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tr -d ' ' | sed -n -e '1p'`
		@ highestLine -= 1
		sed -n -e "1,${highestLine}p" tipiTester.xml > upTemp
		@ highestLine += 1
		sed -n -e "${highestLine},${totalLines}p" tipiTester.xml > downTemp
		echo "	    <station>$1</station>" >> upTemp
		cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp

	else if ($nPattern > $highest) then

		set lowestLine = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '<' -f 1 | tail -1 | tr -d ' '`
		sed -n -e "1,${lowestLine}p" tipiTester.xml > upTemp
		@ lowestLine += 1
		sed -n -e "${lowestLine},${totalLines}p" tipiTester.xml > downTemp
		echo "	    <station>$1</station>" >> upTemp
		cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp	

	else

		set x = 1
		set condition = no
		while ($condition == "no")
				
			if($lPattern == "93K") then
				set current = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c4- | sed -n -e "${x}p"`
			else
				set current = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | cut -d '>' -f 2 | cut -d '<' -f 1 | tr -d '-' | cut -c3- | sed -n -e "${x}p"`
			endif
					
			if ($current > $nPattern) then
				unset condition
				set condition = yes	
			else 
				@ x++
			endif

		end
				
		@ x -= 1
		set lowestLine = `cat -n tipiTester.xml | sed -n -e "${line},${endLine}p" | grep "<station>" | grep ">${lPattern}" | sed -n -e "${x}p" | cut -d '<' -f 1 | tr -d ' '`
		sed -n -e "1,${lowestLine}p" tipiTester.xml > upTemp
		@ lowestLine += 1
		sed -n -e "${lowestLine},${totalLines}p" tipiTester.xml > downTemp
		echo "	    <station>$1</station>" >> upTemp
		cat upTemp downTemp > tipiTester.xml
		rm upTemp downTemp 
	endif

endif
