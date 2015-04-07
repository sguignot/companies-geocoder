#!/bin/sh

if test $# -lt 1; then
	echo "Usage: $0 file.csv ..."
	exit 1
fi

CSV_FILES=$1
shift
while test $# -ne 0; do
	CSV_FILES="${CSV_FILES},$1"
	shift
done

rake "uk_basicdata:import[${CSV_FILES}]"
