#!/usr/bin/awk -f

BEGIN {
    shell = shell? shell : "/bin/sh"
    ALIGN = " | awk '{i=0; if (NR>1) while (i++<n) printf(\" \"); print}END{if (NR==0) printf \"\\n\"}' n="
}

function attach_cd(cmd) {
    # execute cmd under the same directory with the input file
    # (FILENAME)
    return sprintf("(cd $(dirname %s); %s)", FILENAME, cmd)
}

{
    if (match($0, /^#\+sh +/)) {
        # take over the whole line; no need alignment
        cmd = substr($0, RLENGTH)
        print attach_cd(cmd) | shell
        close(shell)
    } else if (match($0, /[^\\]#\+sh +/)) {
        printf substr($0, 1, RSTART)
        pipe = shell ALIGN RSTART;
        cmd = substr($0, RSTART+RLENGTH)
        print attach_cd(cmd) | pipe
        close(pipe)
    } else {
        gsub(/\\#\+sh/, "#+sh")
        print
    }
}
