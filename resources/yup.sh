# Commit and update the system

set -ue

msg_err () {
    echo -e "\e[1;31merror \e[1;37m::\e[0m" "$@" >&2
}
msg_warn () {
    echo -e "\e[1;33mwarn \e[1;37m::\e[0m" "$@" >&2
}
msg_info () {
    echo -e "\e[1;34minfo \e[1;37m::\e[0m" "$@" >&2
}

hardcoded_repo="https://github.com/santiagocezar/nixos-config.git"

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
mkdir -p "$XDG_CONFIG_HOME"

config_file="$XDG_CONFIG_HOME/yuprc"

if [ -z "${CONFIG_REPO:-}" ]; then
    if [ -f "$config_file" ]; then
        CONFIG_REPO="$(cat "$config_file")"
    else
        CONFIG_REPO="$HOME/NixOS"
        echo "$CONFIG_REPO" > "$config_file"
    fi
fi

yup__bootstrap () {
    msg_info Building system using the latest config...
    if ! git clone "$hardcoded_repo" "$CONFIG_REPO"; then
        msg_err Failed to fetch config repository.
        if [ -d "$CONFIG_REPO" ]; then
            msg_err System is already bootstrapped, use '"yup update"' instead.
            exit 1
        else
            msg_warn Using source from the nix store. You might want to clone "$hardcoded_repo" to "$CONFIG_REPO" manually.
        fi
        CONFIG_REPO="$SRC"
    fi
    sudo nixos-rebuild switch --flake "$CONFIG_REPO"
}

get_upstream () {
    git fetch || msg_warn Failed to fetch changes from upstream, config may be out of date.
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse '@{u}')
    BASE=$(git merge-base @ '@{u}')

    if [ "$LOCAL" != "$REMOTE" ] && [ "$LOCAL" = "$BASE" ]; then
        msg_info Upstream has been updated, merging changes...
        git rebase || { msg_err that\'s not good... :/; exit 1; }
    fi
}

check_dirty () {
    if ! git diff-files --quiet; then
        if [ -z "${1:-}" ]; then
            return 1
        fi

        git add . || :
        git commit -m "$1" || :
    fi
}

build_or_undo () {
    if ! nixos-rebuild dry-build --flake .; then
        git reset --soft "$1"
        exit 1
    fi

    git push || :

    sudo nixos-rebuild switch --flake .
}

yup__update () {
    cd "$CONFIG_REPO"

    PREV_REV=$(git rev-parse HEAD)

    check_dirty "$1" || {
        msg_err There have been changes to the config, please add a commit message to save them before updating.
        exit 1
    }

    get_upstream

    build_or_undo "$PREV_REV"
}

yup__refresh () {
    check_dirty || {
        msg_err There have been changes to the config, commit them separately.
        exit 1
    }

    PREV_REV=$(git rev-parse HEAD)

    nix flake update

    git add flake.lock
    git commit -m "update inputs"

    build_or_undo "$PREV_REV"
}

cmdname=$1
shift
echo "$@"
if declare -f "yup__$cmdname" >/dev/null 2>&1; then
    "yup__$cmdname" "$@"
else
    msg_err unknown command \""$cmdname"\".
    exit 1
fi
