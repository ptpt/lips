#!/bin/sh

echo '```'$1
if [ "$2" ]; then
    cat "$2"
else
    cat
fi
# trailing newline is guaranteed by uncomment.awk
echo '```'
