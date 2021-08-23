#!/bin/bash

export SOURCE=""
export REGEX_EXP=""

function create_dir_if_doesnt_exist(){
    if [[ ! -d $1 ]]
    then
        mkdir $1
    fi
}

function check_if_dir_empty(){
    if [ "$(ls -A $1)" ]
    then
        return 0
    else
        return 1
    fi
}

function check_if_file_exist(){
    if [ ! -f $1 ]; then
        return 0
    else
        return 1
    fi
}

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

SOURCE_DIR_PATH="source/"
DEST_DIR_PATH="destiny/"

declare -a DIR_ARRAY=($SOURCE_DIR_PATH $DEST_DIR_PATH)
for DIR in "${DIR_ARRAY[@]}"
do
    create_dir_if_doesnt_exist ${DIR}
    rm -rf ${DIR}/*
done