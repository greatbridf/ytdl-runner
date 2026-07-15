#!/bin/sh
# vim: set et ts=4 sw=0 sts=0:

match() {
    regex_search '(http://xhslink\.com/o/\w+)' "$1"
}
