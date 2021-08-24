


function create_error_log(){
	NOW_DATE=`date +"%d-%m-%Y"`
	FILE_NAME="name"
	LOG_FILE_NAME="log-error-${FILE_NAME}-${NOW_DATE}.txt"

	ERROR_LOG_BEGIN=`date '+%H:%M:%S'`" "
	ERROR_LOG_MESSAGE=$ERROR_LOG_BEGIN$1
	echo $ERROR_LOG_MESSAGE >> $LOG_FILE_NAME
}



create_error_log "error: no file to analize"