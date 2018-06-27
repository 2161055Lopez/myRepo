#!/bin/csh -fbvx

###############################################################################################################################
# This script creates a backup file of tipiTester.xml and appends the current date and time to the filename.
# The new filename is equivalent to "tipiTester.xml.[month][day][year]-[hour]:[min]:[sec]"
#
# PARAMETERS: none
###############################################################################################################################

set time = `date "+%m%d%y-%T"`
set filename = "tipiTester.xml"
set bak = "$filename"."$time"

cp $filename $bak
