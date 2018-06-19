#!/bin/csh -fbvx
./backup.csh
set filename = "tipiTester.xml";
set temp = "tipiTester.xml.temp";

foreach i ($*)
	grep -wv $i $filename > $temp; mv $temp $filename;
end
