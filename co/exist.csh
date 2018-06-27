#!/bin/csh

###############################################################################################################################
# This script checks if the tester exists the tipiTester.xml file.
# It will return the following:
#	'A' -> The tester does not exist in both the stations and the stationGroups
#	'B' -> The tester exist in the stations but not in the stationGroups
#	'C' -> The tester exist in the stationGroups but not in the stations
#	'D' -> The tester already exist in both the stations and stationGroups
#
# PARAMETERS:	tester($1)
###############################################################################################################################

set lineNumber = `grep -nw 'stations' tipiTester.xml | cut -d ':' -f 1 | head -1`
@ lineNumber += 1
set lineNumber2 = `grep -nw 'stations' tipiTester.xml | cut -d ':' -f 1 | tail -1`
set stations = `cat -n tipiTester.xml | sed -n -e "${lineNumber},${lineNumber2}p" | grep "<station>" | grep -w $1`

set lineNumberX = `grep -nw 'stationGroups' tipiTester.xml | cut -d ':' -f 1 | head -1`
@ lineNumberX += 1
set lineNumberY = `grep -nw 'stationGroups' tipiTester.xml | cut -d ':' -f 1 | tail -1`
set groups = `cat -n tipiTester.xml | sed -n -e "${lineNumberX},${lineNumberY}p" | grep "<station>" | grep -w $1`

# A -> Not in both the stations and stationGroups
# B -> Exists in stations but not in stationGroups
# C -> Not in stations but it exists in stationGroups
# D -> Exists in both the stations and stationGroups
if ($stations == "" && $groups == "") then
	echo A
else if ($stations != "" && $groups == "") then	
	echo B
else if ($stations == "" && $groups != "") then	
	echo C
else if ($stations != "" && $groups != "") then	
	echo D
endif

