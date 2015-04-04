#!/usr/bin/awk -f

BEGIN {
    # comment delimiter
    comment = comment? comment : "//"
    # lines of code
    loc = 0
}

function is_comment() {
    return index($0, comment)==1 && $1==comment
}

function is_text()
{
    return is_comment() && $2!=comment;
}

function is_double_comment()
{
    return is_comment() && $2==comment;
}

function process_code()
{
    # skip trailing blank lines
    for (last=loc-1; last>=0 && code[last]~/^\s*$/; last--);

    # print leading blank lines
    for (first=0; first<=last && code[first]~/^\s*$/; first++)
        print code[first]

    # process code
    for (i=first; i<=last; i++) {
        if (codeout)
            print code[i] | codeout
        else
            print code[i]
    }
    close(codeout)

    # print trailing blank lines
    for (i=last+1; i<loc; i++)
        print code[i]
}

{
    if (is_text()) {
        # process previous code lines
        process_code()
        # print the uncommented line
        print substr($0, length(comment) + 2)
        loc = 0
    } else {
        if (is_double_comment()) {
            # remove the first comemnt delimiter
            sub(/^\s*\S+\s*/, "")
        }
        # accumulate code lines
        code[loc++] = $0
    }
}

END {
    process_code()
}