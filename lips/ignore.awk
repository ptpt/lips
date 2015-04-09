#!/usr/bin/awk -f

#+block usage

# ### `ignore.awk`: ignore blocks
# ```
# usage: ignore.awk FILENAME
# ```

# Like `cat FILENAME` but ignore blocks between `#+ignore` and
# `#+endignore`, and lines containing `#+ignoreline`.

#+endblock

BEGIN { ignored = 0 }

function find(s) {
    for (i=1; i<=NF; i++) {
        if ($i == s) return i;
    }
    return 0;
}

{
    if (!ignored && find("#+ignore")) {
        ignored = 1
    } else if (ignored && find("#+endignore")) {
        ignored = 0
    } else if (!ignored && !find("#+ignoreline")) {
        gsub(/\\#\+ignore/, "#+ignore")
        gsub(/\\#\+endignore/, "#+endignore")
        print
    }
}
