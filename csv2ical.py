#!/bin/env python3
"""
Example for converting a CSV file into an iCal file
"""

import sys, getopt
from datetime import datetime, timedelta
import pytz

from csv_ical.csv_ical import Convert

def main(argv):
    convert = Convert()
    try:
        opts, args = getopt.getopt(argv, "hi:o:", ["ifile=", "ofile="])
    except getopt.GetoptError:
        print('test.py -i <inputfile> -o <outputfile>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('test.py -i <inputfile> -o <outputfile>')
            sys.exit()
        elif opt in ("-i", "--ifile"):
            csv_file_location = arg
        elif opt in ("-o", "--ofile"):
            ical_file_location = arg

    csv_configs = {
            'HEADER_ROWS_TO_SKIP': 1,
            'CSV_NAME': 0,
            'CSV_START_DATE': 2,
            'CSV_END_DATE': 4,
            'CSV_DESCRIPTION': 5,
            'CSV_LOCATION': 6,
            'CSV_INSTRUCTOR': 5,
            }

    convert.read_csv(csv_file_location, csv_configs)
    i = 0
    while i < len(convert.csv_data):
        row = convert.csv_data[i]
        start_date = row[1] + ' '+row[csv_configs['CSV_START_DATE']]
        end_date = row[3] + ' ' + row[csv_configs['CSV_END_DATE']]
        try:
            row[csv_configs['CSV_START_DATE']] = datetime.strptime(
                    start_date, '%Y-%m-%d %H:%M'
                    )
            row[csv_configs['CSV_END_DATE']] = datetime.strptime(
                    end_date, '%Y-%m-%d %H:%M'
                    )
            row[csv_configs['CSV_DESCRIPTION']] = row[csv_configs['CSV_INSTRUCTOR']].upper() + ' | '+row[csv_configs['CSV_NAME']]

            i += 1
        except ValueError:
            convert.csv_data.pop(i)
            print("Did not work")

        print("Done parsing dates")
        row[csv_configs['CSV_NAME']] = row[csv_configs['CSV_NAME']]

    convert.make_ical(csv_configs)
    convert.save_ical(ical_file_location)

if __name__ == '__main__':
    main(sys.argv[1:])
