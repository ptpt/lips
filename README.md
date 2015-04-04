Literate Programming Utils
==========================

## Introduction

`lips` is a set of quick-and-dirty utils designed for *inverse
literate programming*, i.e. generating documentation from source
code.

To install `lips`, copy `lips/*` (or only the ones you need) to your
`PATH` and make them executable.

This documentation is generated from
[its source](https://github.com/ptpt/lips/blob/master/README.md.in) by
`lips`.

## Examples

### Source code -> Markdown
We have a JavaScript file `examples/say.js`. Its comments are
written in Markdown.
```javascript
// ## Your First Program

// `say` is a function that says something
var say = function(something) {
    console.log(something);
};

// #+ignore
// test it
say('hello world');
// #+endignore
```

With the command below, we do 3 things:

1. uncomment it
2. highlight its code block, and
3. ignore its test block

```
uncomment.awk codeout="highlight.awk -vlang=javascript" examples/say.js | ignore.awk
```

It becomes a markdown documentation:
```markdown
## Your First Program

`say` is a function that says something
{% highlight javascript %}
var say = function(something) {
    console.log(something);
};
{% endhighlight %}

```

### Include partials
We have a main markdown file `examples/main.md`:
```
hello world
===========

#+sh cat intro.md

#+sh uncomment.awk codeout="highlight.awk -vlang=javascript" say.js | ignore.awk
```

It contains two commands `cat intro.md` and `uncomment.awk say.js ...`.

`intro.md` looks like this:
```
## Introduction

Programming is fun. In this article we are going to teach you how to
program in JavaScript.
```

Include them in `main.md` with one command:
```
$ sh.awk examples/main.md
hello world
===========

## Introduction

Programming is fun. In this article we are going to teach you how to
program in JavaScript.

## Your First Program

`say` is a function that says something
{% highlight javascript %}
var say = function(something) {
    console.log(something);
};
{% endhighlight %}

```

## Usage

### `uncomment.awk`: uncomment source code
```
usage: uncomment.awk [codeout] [comment="//"] FILENAME
```

Uncomment `FILENAME` by simply removing the leading comment delimiter
in each comment line, and pipe code blocks (the non-comment lines) to
the command specified by `codeout`.

You need to specify another comment delimiter when your source code is not
commented by `//`.

### `sh.awk`: simple shell-base templating
```
usage: sh.awk [shell="/bin/sh"] FILENAME
```

Pipe commands after the mark `#+sh` to `SHELL`, and replace each mark
and command with its output.

```
$ cat today
Today is #+sh date +%Y-%m-%d

$ sh.awk today
Today is 2015-04-04
```

### `ignore.awk`: ignore blocks
```
usage: ignore.awk FILENAME
```

Like `cat FILENAME` but ignore blocks between `#+ignore` and
`#+endignore`, and lines containing `#+ignoreline`.

### `block.awk`: block extraction
```
usage: block.awk name=NAME FILENAME
```

Print out a named block. A named block is a block between `#+block
NAME` and `#+endblock`.

### `fence.awk` and `highlight.awk`: wrap your code block

```
usage: fence.awk -vlang=LANG FILENAME
       highlight.awk -vlang=LANG FIELNAME
```

Two helpers for generating markdown documentation. `fence.awk` wraps
your code block with triple-backtick syntax, while `highlight.awk`
wraps with `{% highlight LANG %}` and `{% endhighlight %}`.

## Development
Some principles:

- follow KISS
- utilize tools installed on every UNIX-like machine, such as `awk`, `sed`, `sh`
- not exceed 128 LoC for each little program

LoC of each program:
```
       fence.awk 7
   highlight.awk 10
      ignore.awk 22
       block.awk 27
          sh.awk 30
   uncomment.awk 66
           total 162
```

Runing tests:
```
./run_test.sh
```

## License

See LICENSE.
