#!/bin/csh -fbvx

###############################################################################################################################
# This script removes the tester from its original location and then calls the "insert2.csh" script to add the new tester to itsnew location base on the parameters in the script.
#
# PARAMETERS: Tester($1), newGroup($2), newCluster($3)
###############################################################################################################################

set filename = "tipiTester.xml"
set temp = "tipiTester.xml.temp"
set line = `grep -wn $1 $filename | tail -1 | cut -d ':' -f1`

sed -e "${line}p" tipiTester.xml > $temp; mv $temp $filename 

./insert2.csh "$1" "$2" "$3"
