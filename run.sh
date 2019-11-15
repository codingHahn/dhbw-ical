#!/bin/bash

link=$1
from=$(date -I --date="1 month ago")
to=$(date -I --date="4 months")

cleanup() {

	echo 'Error: ${1}'
	rm rapla.csv || true
	rm dhbwcal.ics || true
	exit 1

}
java -jar rapla2csv.jar -l "${1}" -f "${from}" -u "${to}" -o rapla.csv || cleanup 'Error fetching calendar'

python3 csv2ical.py -i rapla.csv -o dhbwcal.ics || cleanup 'Error converting csv to ical'

chmod 664 dhbwcal.ics 

mv dhbwcal.ics /var/www/icalserver/ || cleanup 'Error moving ical to destination'
rm rapla.csv

