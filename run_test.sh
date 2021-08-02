#!/usr/bin/env bash
set +e

success=0
failure=0

test_block () {
    observed=$(mktemp)
    expected="test/block.$1.output"
    awk -f "./lips/block.awk" name="$1" "test/block.input" > $observed
    cmp $expected $observed
    if [ "$?" -eq 0 ]; then
        let success+=1
    else
        diff $expected $observed
        let failure+=1
    fi
    rm $observed
}

test_awk () {
    observed=$(mktemp)
    expected="test/$1.output"
    awk -f "./lips/$1.awk" "test/$1.input" > $observed
    cmp $expected $observed
    if [ "$?" -eq 0 ]; then
        let success+=1
    else
        diff $expected $observed
        let failure+=1
    fi
    rm $observed
}

test_block root
test_block "function"
test_block kid1
test_block escape
test_block unfinished

test_awk sh
test_awk src
test_awk ignore
test_awk uncomment

echo $success tests succeed
echo $failure tests fail

if [ $failure -gt 0 ]; then
    exit 1
fi
