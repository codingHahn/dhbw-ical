#!/bin/bash

link=$1
course=$2
from=$(date -I --date="1 month ago")
to=$(date -I --date="4 months")
dir='/var/dhbw-ical'

cleanup() {

	echo 'Error: ${1}'
	rm ${course}rapla.csv || true
	rm ${course}dhbwcal.ics || true
	exit 1

}
java -jar ${dir}/rapla2csv.jar -l "${1}" -f "${from}" -u "${to}" -o ${dir}/${course}rapla.csv || cleanup 'Error fetching calendar'

python3 ${dir}/csv2ical.py -i ${dir}/${course}rapla.csv -o ${dir}/${course}dhbwcal.ics || cleanup 'Error converting csv to ical'

mkdir -p ${dir}/${course}

chmod 664 ${dir}/${course}dhbwcal.ics 

mv ${dir}/${course}dhbwcal.ics /var/www/dhbw-ical/${course}/dhbwcal.ics || cleanup 'Error moving ical to destination'
rm ${dir}/${course}rapla.csv
