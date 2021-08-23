#!/bin/bash

export SOURCE=""
export REGEX_EXP=""

while test $# -gt 0; do
    case "$1" in
        -h|--help)
            echo "$package - work with csv"
            echo " "
            echo "$package [options] application [arguments]"
            echo " "
            echo "options:"
            echo "-h, --help         show brief help"
            echo "-s, --source       specify path or url of source"
            echo "-r, --regexp       specify a regexp to filter source data"
            exit 0
        ;;
        -s)
            shift
            if test $# -gt 0; then
                export SOURCE=$1
            else
                echo "no source specified"
                exit 1
            fi
            shift
        ;;
        -r)
            shift
            if test $# -gt 0; then
                export REGEX_EXP=$1
            else
                echo "no regexp specified"
                exit 1
            fi
            shift
        ;;
        *)
            break
        ;;
    esac
done

echo $SOURCE
echo $REGEX_EXP