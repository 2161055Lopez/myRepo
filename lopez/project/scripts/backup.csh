#!/bin/csh -fbvx
set time = `date "+%m%d%y-%T"`
set filename = "tipiTester.xml"
set bak = "$filename"."$time"

cp $filename $bak
