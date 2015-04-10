#!/bin/sh

# Deps:
#  mongod >= 3.0
#  jq: http://stedolan.github.io/jq/

if test $# -ne 2; then
	echo "Usage: $0 input.csv output_geo.json"
	exit 1
fi

CSV_FILE=$1
GEOJSON_FILE=$2

mongoimport -h localhost:27017 -d build_geojson -c uk_companies --type csv --file "$CSV_FILE" --ignoreBlanks --headerline --drop
mongoexport -h localhost:27017 -d build_geojson -c uk_companies | jq -c 'if .dstk_latitude then . + {geometry: {type: "Point", coordinates: [.dstk_longitude, .dstk_latitude]}} else . end' > "$GEOJSON_FILE"
