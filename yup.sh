#!/bin/sh
# Commit and update the system

set -uex

cd ~/NixOS/

commit_changes() {
    git diff -u

    git add .

    git commit -m "$1"
}

undo_commit() {
    git reset --soft HEAD~
}

update () {
    git pull --rebase
}

if [ $# -gt 0 ]; then
    commit_changes "$1"

    trap 'undo_commit' SIGINT

    if sudo nixos-rebuild switch --flake .; then
        git push
    else
        undo_commit
    fi
else
    update

    sudo nixos-rebuild switch --flake .
fi
