#!/bin/sh

error() {
    printf "\033[91merror: \033[0m%s\n" "$1" >&2
}

warn() {
    printf "\033[93mwarn : \033[0m%s\n" "$1" >&2
}

info() {
    printf "\033[92minfo : \033[0m%s\n" "$1" >&2
}

die() {
    error "$1" && exit 1
}

yesno() {
    if [ -n "$1" ]; then
        echo y
    else
        echo n
    fi
}

regex_search() {
    echo "$2" | sed -rn "s/.*$1.*/\1/p"
}

iter_files() {
    _path="$1" && shift

    find -L "$_path" -type f -maxdepth 1 "$@"
}

iter_files_sorted() {
    iter_files "$@" | sort
}
