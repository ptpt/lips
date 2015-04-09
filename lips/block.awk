#!/usr/bin/awk -f

# #+block usage

# ### `block.awk`: block extraction
# ```
# usage: block.awk name=NAME FILENAME
# ```

# Print out a named block. A named block is a block between `#+block
# NAME` and `#+endblock`.

# #+endblock

BEGIN {
    level = 0
}

function find(s) {
    for (i=1; i<=NF; i++) {
        if ($i==s) return i
    }
    return 0
}

{
    prev = level
    if (n=find("#+block")) {
        if ($(n+1) == name || level)
            level += 1
    } else if (level && find("#+endblock")) {
        level -= 1;
    }
    if (prev && level) {
        gsub(/\\#\+block/, "#+block")
        gsub(/\\#\+endblock/, "#+endblock")
        print
    }
}
