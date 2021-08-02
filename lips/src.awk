#!/usr/bin/awk -f

BEGIN {
    ALIGN_PIPE = " | awk '{i=0; if (NR>1) while (i++<n) printf(\" \"); print}END{if (NR==0) printf \"\\n\"}' n=";
    shell = shell? shell : "/bin/sh";
    src = "";
    open = 0;
    align = 0;
}

function attach_cd(cmd) {
    # execute cmd under the same directory with the input file
    # (FILENAME)
    return sprintf("(cd $(dirname %s); %s)", FILENAME, cmd);
}

function exec(src) {
    if (align) {
        pipe = shell ALIGN_PIPE align;
    } else {
        pipe = shell;
    }
    print(attach_cd(src)) | pipe;
    close(pipe);
}

{
    if (open) {
        if (match($0, /^\s*#\+end_sh\s*$/)) {
            exec(src);
            open = 0;
            align = 0;
        } else if (match($0, /\s*end_sh\+#\s*/)) {
            src = src "\n" substr($0, 1, RSTART - 1);
            exec(src);
            open = 0;
            align = 0;
            print(substr($0, RSTART + RLENGTH));
        } else {
            if (src) {
                src = src "\n" $0;
            } else {
                src = $0;
            }
        }
    } else {
        if (match($0, /#\+begin_sh(\s+|$)/)) {
            begin_start_idx = RSTART;
            begin_length = RLENGTH;
            begin_end_idx = begin_start_idx + begin_length;

            printf substr($0, 1, begin_start_idx - 1);
            end_start_idx = match($0, /\s+end_sh\+#/);

            # end_sh must occur after begin_sh
            if (end_start_idx > begin_start_idx) {
                end_start_idx = RSTART;
                end_length = RLENGTH;
                src_length = end_start_idx - begin_end_idx;
                src = substr($0, begin_end_idx, src_length);
                exec(src);
                print(substr($0, end_start_idx + end_length));
            } else {
                src = substr($0, begin_end_idx);
                if (src) {
                    align = begin_start_idx - 1;
                } else {
                    align = 0;
                }
                open = 1;
            }
        } else {
            print($0);
        }
    }
}
