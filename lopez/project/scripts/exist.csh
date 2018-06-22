#!/bin/csh
set value = `grep -w $1 tipiTester.xml`
if ($value == "") then
	echo "empty";
else
	echo "exist";
endif
