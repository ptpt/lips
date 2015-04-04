#!/usr/bin/awk -f

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
