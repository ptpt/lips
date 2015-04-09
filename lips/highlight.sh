#!/bin/sh

#+block usage

# ### `highlight.sh`: wrap your code block in Jekyll style
# ```
# usage: highlight.sh LANG CODEBLOCK
# ```

# Wrap CODEBLOCK with `{% highlight LANG %}` and `{%
# endhighlight %}`. It is designed to be a helper for generating
# markdown documentation in collaborate with `uncomment.awk`.

#+endblock

if [ "$1" ]; then
    echo "{% highlight $1 %}"
else
    echo "{% highlight %}"
fi
if [ "$2" ]; then
    cat "$2"
else
    cat
fi
# trailing newline is guaranteed by uncomment.awk
echo "{% endhighlight %}"
