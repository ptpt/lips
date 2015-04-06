Literate Programming Utils
==========================

## Introduction

`lips` is a set of quick-and-dirty utils designed for *inverse
literate programming*, i.e. generating documentation from source
code.

This documentation is generated from
[its source](https://github.com/ptpt/lips/blob/master/README.md.in) by
`lips`.

## Installation

```
$ make install
```

It merely copies `lips/*` to `/usr/local/bin`. Feel free to pick only
the ones you need.

## Examples

### Source code -> Markdown
We have a JavaScript file `examples/say.js`. Its comments are
written in Markdown.
```javascript
// ## Your First Program

// `say` is a function that says something
var say = function(something) {
    // something goes to stdout
    console.log(something);
};

// #+ignore just put words below, I'll hide them for you
// test it
say('hello world');
// #+endignore
```

Run the command below, which does 3 things:

1. uncomment all comments in `say.js`
2. highlight the code block, and
3. ignore the test block

```
$ uncomment.awk codeout="highlight.sh javascript" examples/say.js | ignore.awk
```

It outputs a markdown documentation:
```markdown
## Your First Program

`say` is a function that says something
{% highlight javascript %}
var say = function(something) {
    // something goes to stdout
    console.log(something);
};
{% endhighlight %}

```

### Include partials
We have a main markdown file `examples/main.md`:
```markdown
hello world
===========

#+sh cat intro.md

#+sh uncomment.awk codeout="highlight.sh javascript" say.js | ignore.awk
```

Note that the special syntax `#+sh` is not a markdown syntax; it
tells `lips/sh.awk` that here is a command, please execute the command
and replace here with its output. This file contains two commands `cat
intro.md` and `uncomment.awk say.js ...`.

`intro.md` (it is also located under the folder `examples`) looks like
this:
```markdown
## Introduction

Programming is fun. In this article we are going to teach you how to
program in JavaScript.
```

Include them in `examples/main.md` with one command:
```
$ sh.awk examples/main.md
```

It outputs:
```markdown
hello world
===========

## Introduction

Programming is fun. In this article we are going to teach you how to
program in JavaScript.

## Your First Program

`say` is a function that says something
{% highlight javascript %}
var say = function(something) {
    // something goes to stdout
    console.log(something);
};
{% endhighlight %}

```

## Usage

### `uncomment.awk`: uncomment source code
```
usage: uncomment.awk [codeout] [comment="//"] FILENAME
```

Uncomment `FILENAME` by simply removing the leading comment starter
in each comment line, and pipe code blocks (the non-comment lines) to
the command specified by `codeout`.

You need to specify another comment starter when your source code is not
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
Today is 2015-04-06
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

### `fence.sh` and `highlight.sh`: wrap your code block

```
usage: fence.sh LANG FILENAME
       highlight.sh LANG FIELNAME
```

Two helpers for generating markdown documentation in collaborate with
`uncomment.awk`. `fence.sh` wraps your code block with
triple-backtick syntax, while `highlight.sh` wraps with `{% highlight
LANG %}` and `{% endhighlight %}`.

## Development
Some principles:

- follow KISS
- utilize common UNIX tools such as `awk`, `sed`, `sh`
- not exceed 128 LoC for each little program

LoC of each program:
```
        fence.sh 10
    highlight.sh 14
      ignore.awk 22
       block.awk 27
          sh.awk 30
   uncomment.awk 61
           total 164
```

Run tests:
```
sh run_test.sh
```

## License

See LICENSE.
