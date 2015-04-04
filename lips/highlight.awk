#!/usr/bin/awk -f

BEGIN {
    lang = lang? " " lang : lang
    printf("{%% highlight%s %%}\n", lang)
}

1

END { print "{% endhighlight %}" }
