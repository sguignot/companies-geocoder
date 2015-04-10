#!/bin/sh

if test $# -ne 2; then
	echo "Usage: $0 input.json output_geo.json"
	exit 1
fi

cat "$1" | jq -c 'if .dstk_latitude then . + {geometry: {type: "Point", coordinates: [.dstk_longitude, .dstk_latitude]}} else . end' > "$2"
