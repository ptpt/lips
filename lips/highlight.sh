#!/bin/sh

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
echo
echo "{% endhighlight %}"
