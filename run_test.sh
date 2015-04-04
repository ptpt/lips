#!/bin/sh

success=0

test_block () {
    awk -f "./lips/block.awk" name="$1" "test/block.input" | cmp "test/block.$1.output"
    test "$?" -eq 0 && let success+=1
}

test_it () {
    awk -f "./lips/$1.awk" "test/$1.input" | cmp "test/$1.output"
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
