#!/bin/bash
# vim: set et ts=4 sw=0 sts=0:

# Audio only, for special use
audio_list='
30280  m4a audio only     | ≈169.05KiB  111k https | audio only          mp4a.40.2  111k
30232  m4a audio only     | ≈130.17KiB   86k https | audio only          mp4a.40.2   86k
30216  m4a audio only     | ≈101.30KiB   67k https | audio only          mp4a.40.2   67k
'

preferred_list='
30077  mp4 1080x1920   30 | ≈  2.37MiB 1594k https | hvc1.1.6.L150 1594k video only
30080  mp4 1080x1920   30 | ≈  5.57MiB 3755k https | avc1.640033   3755k video only
30066  mp4 720x1280    30 | ≈981.57KiB  646k https | hvc1.1.6.L120  646k video only
30064  mp4 720x1280    30 | ≈  2.44MiB 1643k https | avc1.640033   1643k video only
'

no_prefer_list='
# resolution too low
100022 mp4 360x640     30 | ≈540.55KiB  356k https | av01.0.08M.08  356k video only
30016  mp4 360x640     30 | ≈  1.26MiB  850k https | avc1.640033    850k video only
30011  mp4 360x640     30 | ≈524.42KiB  345k https | hvc1.1.6.L120  345k video only
100023 mp4 480x852     30 | ≈763.02KiB  502k https | av01.0.08M.08  502k video only
30032  mp4 480x852     30 | ≈  1.25MiB  844k https | avc1.640033    844k video only
30033  mp4 480x852     30 | ≈756.98KiB  498k https | hvc1.1.6.L120  498k video only

# we dont like avc for its bad compatibility
100024 mp4 720x1280    30 | ≈917.54KiB  604k https | av01.0.08M.08  604k video only
100026 mp4 1080x1920   30 | ≈  2.32MiB 1567k https | av01.0.08M.08 1567k video only
'

all_list="$audio_list
$preferred_list
$no_prefer_list"

bilibili_bvid() {
    regex_search '[\/=](BV[a-zA-Z1-9]+)' "$1" && return
    regex_search "(av[0-9]+)" "$1" && return
    return 1
}

bilibili_epid() {
    regex_search "&(p=[0-9]+)" "$1" && return
    return 1
}

bilibili_url() {
    bvid="$(bilibili_bvid "$1")"
    [ -n "$bvid" ] || return 1

    epid="$(bilibili_epid "$1")"

    echo "https://www.bilibili.com/video/$bvid/?$epid"
}

bilibili_short_url() {
    regex_search '(https://b23\.tv/\w+)' "$1"
}

match() {
    bilibili_url "$1" || bilibili_short_url "$1"
}

filter_list() {
    echo "$1" | grep -v '^#' | awk '{ print $1 }'
}

is_in_list() {
    local target="$1"
    shift

    local item
    for item in "$@"; do
        if [ "$item" = "$target" ]; then
            return
        fi
    done

    return 1
}

# $1: A
# $@: B
# Returns whether all elements of A (separated by blanks) is in B
contained_in() {
    local items="$1"
    shift

    local item
    for item in $items; do
        if ! is_in_list "$item" "$@"; then
            return 1
        fi
    done

    return
}

select_format() {
    # shellcheck disable=2046
    if ! contained_in "$*" $(filter_list "$all_list"); then
        warn "Unknown format found, skipping..."
        return 1
    fi

    local preferred
    for preferred in $(filter_list "$preferred_list"); do
        if is_in_list "$preferred" "$@"; then
            echo "$preferred"
            return
        fi
    done
}
