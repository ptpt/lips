#!/bin/sh

success=0

test_block () {
    awk -f "./lips/block.awk" name="$1" "test/block.input" | cmp "test/block.$1.output"
    test "$?" -eq 0 && let success+=1
}

test_awk () {
    awk -f "./lips/$1.awk" "test/$1.input" | cmp "test/$1.output"
    test "$?" -eq 0 && let success+=1
}

test_block root
test_block "function"
test_block kid1
test_block escape
test_block unfinished

test_awk sh
test_awk ignore
test_awk uncomment

echo $success tests succeed
