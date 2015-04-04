#!/bin/sh

TEST=test
LIP=lips

success=0

test_block () {
    awk -f "./$LIP/block.awk" name="$1" "$TEST/block.input" | cmp "$TEST/block.$1.output"
    test "$?" -eq 0 && let success+=1
}

test_it () {
    awk -f "./$LIP/$1.awk" "$TEST/$1.input" | cmp "$TEST/$1.output"
    test "$?" -eq 0 && let success+=1
}

test_block root
test_block "function"
test_block kid1
test_block escape
test_block unfinished

test_it sh
test_it ignore
test_it uncomment

echo $success tests succeed
