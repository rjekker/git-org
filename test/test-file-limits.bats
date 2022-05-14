#!/usr/bin/env bats
# -*- shell-script -*-
# Unit tests for git-pisces
# Depends on the bats-core testing framework: https://github.com/bats-core
# (Note: don't accidentally install the old 'bats'; use 'bats-core')
# On Mac OS we also assume that coreutils has been installed

# Note: if we use [[ ]] for assertions bats will report the WRONG line on failure

load utils

@test "Warn when adding over 10 files" {
    make_clone
    cd "$CLONE"
    touch {1..11}
    run $test_cmd
    grep -q "Too many new files" <<< "$output"
    [ "$status" -eq 0 ]
}


@test "Warn when adding more 10 files in a directory" {
    make_clone
    cd "$CLONE"
    mkdir flarp
    cd flarp
    touch {1..11}
    run $test_cmd

    grep -q "Too many new files" <<< "$output"
    [ "$status" -eq 0 ]
}


@test "Warn when adding more than 10 files in multiple dirs" {
    make_clone
    cd "$CLONE"
    mkdir flarp
    cd flarp
    touch {1..4}
    cd ..
    mkdir florp
    cd florp
    touch {5..9}
    cd ..
    touch {10..12}
    run $test_cmd

    grep -q "Too many new files" <<< "$output"
    [ "$status" -eq 0 ]
}

@test "Warn when exceeding size limit" {
    make_clone
    cd "$CLONE"
    dd if=/dev/urandom bs=1024 count=1024 > bigfile 2>/dev/null
    run $test_cmd
    grep -q "New files are too large " <<< "$output"
    [ "$status" -eq 0 ]
}


@test "Warn when exceeding size limit (multiple files/dirs)" {
    make_clone
    cd "$CLONE"
    mkdir flarp
    dd if=/dev/urandom bs=1024 count=512 > flarp/bigfile 2>/dev/null
    mkdir florp
    dd if=/dev/urandom bs=1024 count=512 > florp/bigfile 2>/dev/null
    run $test_cmd
    grep -q "New files are too large " <<< "$output"
    [ "$status" -eq 0 ]
}
