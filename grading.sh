#!/bin/bash

program="Cipher"
expected="$1"
output="$2"

deadline="2026-02-12 10:00"

while read key
do
    repo="fake-$key"
    url="https://github.com/CSE237SP26/$repo.git"

    git clone $url
    if [ -d "$repo" ]
    then
        cd $repo
    else
        echo 0
        continue
    fi

    git checkout cipher
    if [ "$(git branch --show-current)" != "cipher" ]
    then
        echo 0
        cd ..
        continue
    fi

    commit=$(git log -1 --before="$deadline")
    if [ "$commit" = "" ]
    then
        echo 0
        cd ..
        continue
    fi

    javac $program.java
    if [ ! -f "$program.class" ]
    then
        echo 0
        cd ..
        continue
    fi

    java $program

    if [ ! -f "$output" ]
    then
        echo 0
        cd ..
        continue
    fi

    student_output=$(cat $output)
    expected_output=$(cat ../$expected)

    if [ "$student_output" = "$expected_output" ]
    then
        echo "$key 1"
    else
        echo "$key 0"
    fi

    cd ..
done
