#!/bin/sh

match() {
    regex_search '(http://xhslink\.com/o/\w+)' "$1"
}
