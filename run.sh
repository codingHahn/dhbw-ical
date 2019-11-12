#!/bin/bash

link=$1
from=$(date -I --date="1 month ago")
to=$(date -I --date="4 months")

java -jar rapla2csv.jar -l "${1}" -f "${from}" -t "${to}" -o rapla.csv

python3 csv2ics.py -i rapla.csv -o dhbwcal.ics

chmod 664 dhbwcal.ics 

mv dhbwcal.ics /var/www/icalserver/
rm rapla.csv
