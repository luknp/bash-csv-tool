#!/bin/bash

export SOURCE=""
export REGEX_EXP=""

function create_error_log(){
	NOW_DATE=`date +"%d-%m-%Y"`
	FILE_NAME="name"
	LOG_FILE_NAME="log-error-${FILE_NAME}-${NOW_DATE}.txt"

	ERROR_LOG_BEGIN=`date '+%H:%M:%S'`" "
    MESSAGE="$*"
	ERROR_LOG_CONTENT=$ERROR_LOG_BEGIN$MESSAGE
	echo $ERROR_LOG_CONTENT >> $LOG_FILE_NAME
}

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
        -s|--source)
            shift
            if test $# -gt 0; then
                export SOURCE=$1
            else
                echo "no source specified"
                exit 1
            fi
            shift
        ;;
        -r|--regexp)
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

REGEX_URL='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
REGEX_CSV_FILE='.+(\.csv)$'
if [[ $SOURCE =~ $REGEX_URL ]]
then
    wget $SOURCE -P $SOURCE_DIR_PATH
elif [[ $SOURCE =~ $REGEX_CSV_FILE ]]
then
    cp $SOURCE $SOURCE_DIR_PATH
else
    FILE_EXIST=`ls -1 *.csv 2>/dev/null | wc -l`
    if [ $FILE_EXIST != 0 ]
    then
        cp *.csv $SOURCE_DIR_PATH
    fi
fi

CSV_FILE=$(ls -t $SOURCE_DIR_PATH | grep .csv | head -1)
echo $CSV_FILE
if test -z "$CSV_FILE"
then
    ERROR_MESSAGE='error: no file to analize in source dir'
    echo $ERROR_MESSAGE
    create_error_log $ERROR_MESSAGE
    exit 1
fi

SOURCE_FILE_PATH=$SOURCE_DIR_PATH$CSV_FILE
DEST_FILE_PATH=$DEST_DIR_PATH"output.txt"

LINES=0
if test -z "$REGEX_EXP"
then
    cat $SOURCE_FILE_PATH | csvlook > $DEST_FILE_PATH
    LINES=$(cat $SOURCE_FILE_PATH | csvlook | wc -l) #TODO zapisać do zmiennej i na niej liczyć ilość linii
else
    grep $REGEX_EXP $SOURCE_FILE_PATH | csvlook > $DEST_FILE_PATH
    LINES=$(grep $REGEX_EXP $SOURCE_FILE_PATH | csvlook | wc -l)
    
fi

OWNER=$(stat -c '%U' $0)
SIZE=$(stat -c '%s' $0)
SOURCE=$(pwd)
COLUMN_NAMES=$(cat $SOURCE_FILE_PATH | head -n 1)

echo "source: $SOURCE" >> $DEST_FILE_PATH
echo "owner: $OWNER" >> $DEST_FILE_PATH
echo "size: $SIZE bytes" >> $DEST_FILE_PATH
echo "output lines: $LINES" >> $DEST_FILE_PATH
echo "column names: $COLUMN_NAMES" >> $DEST_FILE_PATH

cat $DEST_FILE_PATH

: '
    TODO:
        - refactor,
        - error handling,
        - tests,
'