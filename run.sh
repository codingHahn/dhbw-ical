#!/bin/bash

link=$1
from=$(date -I --date="1 month ago")
to=$(date -I --date="4 months")

java -jar rapla2csv.jar -l "${1}" -f "${from}" -u "${to}" -o rapla.csv || exit 1

python3 csv2ical.py -i rapla.csv -o dhbwcal.ics || exit 1

chmod 664 dhbwcal.ics 

mv dhbwcal.ics /var/www/icalserver/ || exit 1
rm rapla.csv
