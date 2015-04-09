#!/usr/bin/awk -f

#+block usage

# ### `trim.awk`: trim blank lines
# ```
# usage: trim.awk FILENAME
# ```

# Trim blank lines in FILENAME

#+endblock

BEGIN {
    n = 0
}

{
    lines[n++] = $0
}

END {
    for (start=0; start<n && lines[start]~/^\s*$/; start++);
    for (end=n-1; end>=0 && lines[end]~/^\s*$/; end--);
    for (i=start; i<=end; i++) {
        print lines[i];
    }
}
