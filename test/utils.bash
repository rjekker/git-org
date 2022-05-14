#!/bin/env bash

export test_cmd="git-org -q1s 0"

mktempdir() {
    mktemp="mktemp"
    readlink="readlink"
    if [[ $(uname) = "Darwin" ]]; then
        mktemp="gmktemp"
        readlink="greadlink"
    fi
    $readlink -f "$($mktemp -d)" || exit 1
}


make_repo() {
    # create a simple repo with a single commit
    DIR=$(mktempdir)
    cd "$DIR" || exit 1
    git init "$@" . >/dev/null
    echo "$DIR"
}


make_origin() {
    # Create a repo that we can use as origin for other repos
    ORIGIN="$(make_repo --bare)"
    export ORIGIN
}


make_repo_no_remote() {
    # Create a repo without a remote
    REPO_NO_REMOTE="$(make_repo)"
    cd "$REPO_NO_REMOTE" || exit 1
    touch empty_file
    git add . >/dev/null
    git commit -m "inital commit" >/dev/null
    export REPO_NO_REMOTE
}


make_clone() {
    # Clone $ORIGIN

    make_origin
    CLONE="$(mktempdir)"
    git clone "$ORIGIN" "$CLONE" >/dev/null 2>&1
    cd "$CLONE" || exit 1
    touch empty_file
    git add . >/dev/null
    git commit -m "inital commit" >/dev/null
    git push >/dev/null 2>&1
    export CLONE
}


check_repo_clean() {
    LOCAL=$(git status --porcelain) || exit 1
    [ -z "$LOCAL" ]

    REMOTE=$(git diff --stat origin/main) || exit 1
    [ -z "$REMOTE" ]
}
