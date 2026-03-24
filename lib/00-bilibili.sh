#!/bin/bash

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
