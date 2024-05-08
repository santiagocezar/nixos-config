#!/bin/sh
# Commit and update the system

set -uex

cd ~/NixOS/

commit_changes() {
    git diff -u

    git add .

    git commit -m "$1" || :
}

undo_commit() {
    git reset --soft "$PREV_REV"
}

update () {
    git pull --rebase
}

PREV_REV=$(git rev-parse HEAD)

if [ $# -gt 0 ]; then
    commit_changes "$1"
fi

update

trap 'undo_commit' SIGINT

if sudo nixos-rebuild switch --flake .; then
    git push
else
    undo_commit
fi
