#!/bin/sh

if test $# -ne 1; then
	echo "Usage: $0 output.csv ..."
	exit 1
fi

rake "uk_basicdata:export[$1]"
