#!/usr/bin/awk -f

# #+block usage

# ### `uncomment.awk`: uncomment source code
# ```
# usage: uncomment.awk [codeout] [comment="//"] FILENAME
# ```

# Uncomment `FILENAME` by simply removing the leading comment starter
# in each comment line, and pipe code blocks (the non-comment lines) to
# the command specified by `codeout`.

# You need to specify another comment starter when your source code is not
# commented by `//`.

# #+endblock

BEGIN {
    # comment starter
    comment = comment? comment : "//"
    # lines of code
    loc = 0
}

function is_comment() {
    return index($0, comment)==1 && $1==comment
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
    if (is_comment() && !is_double_comment()) {
        # process previous code lines
        process_code()
        # print the uncommented line
        print substr($0, length(comment) + 2)
        loc = 0
    } else {
        if (is_double_comment()) {
            # remove the first comemnt starter
            sub(/^\s*\S+\s*/, "")
        }
        # accumulate code lines
        code[loc++] = $0
    }
}

END {
    process_code()
}
