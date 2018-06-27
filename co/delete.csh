#!/bin/csh -fbvx

###############################################################################################################################
# This script accepts one or more testers and deletes it from the tipiTester.xml file.
# It will first call the "backup.csh" script to create a backup file before modifying the file.
#
# PARAMETERS: one or more tester
###############################################################################################################################

./backup.csh
set filename = "tipiTester.xml";
set temp = "tipiTester.xml.temp";

foreach i ($*)
	grep -wv $i $filename > $temp; mv $temp $filename;
end
