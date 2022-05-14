#!/usr/bin/env bats
# -*- shell-script -*-
# Unit tests for git-org
# Depends on the bats-core testing framework: https://github.com/bats-core
# (Note: don't accidentally install the old 'bats'; use 'bats-core')
# On Mac OS we also assume that coreutils has been installed

# Note: if we use [[ ]] for assertions bats will report the WRONG line on failure

load utils

@test "changing a file" {
    make_clone
    cd "$CLONE"
    echo "a new line" >> empty_file
    run $test_cmd
    [ "$status" -eq 0 ]
    grep -qE "^\\[$CLONE.+?] Starting sync" <<< "${lines[0]}"
    grep -qE "^\\[$CLONE.+?] Committing" <<< "${lines[1]}"
    grep -qE "^\\[$CLONE.+?] Pushing" <<< "${lines[2]}"

    check_repo_clean
}


@test "deleting a file" {
    make_clone
    cd "$CLONE"
    rm empty_file
    run $test_cmd
    [ "$status" -eq 0 ]
    grep -qE "^\\[$CLONE.+?] Starting sync" <<< "${lines[0]}"
    grep -qE "^\\[$CLONE.+?] Committing" <<< "${lines[1]}"
    grep -qE "^\\[$CLONE.+?] Pushing" <<< "${lines[2]}"

    check_repo_clean
}


@test "moving a file" {
    make_clone
    cd "$CLONE"
    mv empty_file moved_file
    run $test_cmd
    [ "$status" -eq 0 ]
    grep -qE "^\\[$CLONE.+?] Starting sync" <<< "${lines[0]}"
    grep -qE "^\\[$CLONE.+?] Committing" <<< "${lines[1]}"
    grep -qE "^\\[$CLONE.+?] Pushing" <<< "${lines[2]}"

    check_repo_clean
}

@test "adding a file" {
    make_clone
    cd "$CLONE"
    touch new_file
    run $test_cmd

    [ "$status" -eq 0 ]
    grep -qE "^\\[$CLONE.+?] Starting sync" <<< "${lines[0]}"
    grep -qE "^\\[$CLONE.+?] Committing" <<< "${lines[1]}"
    grep -qE "^\\[$CLONE.+?] Pushing" <<< "${lines[2]}"

    check_repo_clean
}
