#!/bin/sh

#+block usage

# ### `fence.sh`: wrap your code block in triple-backtick (or GitHub Markdown) style
# ```
# usage: fence.sh LANG CODEBLOCK
# ```

# Wrap CODEBLOCK with triple-backtick syntax. It is
# designed to be a helper for generating markdown documentation in
# collaborate with `uncomment.awk`.

#+endblock

echo '```'$1
if [ "$2" ]; then
    cat "$2"
else
    cat
fi
# trailing newline is guaranteed by uncomment.awk
echo '```'
