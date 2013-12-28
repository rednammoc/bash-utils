#!/bin/bash
# name: log_utils.sh
# description: Collection of utils to log messages into stdin and log-file..
# version: 0.1
# author: rednammoc
#

LOG_FILE="/var/log/${APP_NAME}.log"

# Global log-messages which can be used inside your application.
LOG_MSG_NOT_OVERWRITTEN_FUNCTION="$FUNCNAME is not implemented! You need to overwrite this function inside your application."

# controls the date-format used. 
DATE_FORMAT='%Y/%m/%d %H:%M:%S'

# prints message with timestamp to stdin and log-file.
log () {
	local LOG_MSG="$1"
	local TIMESTAMP=$(get_current_time)
	if [ -e "${LOG_FILE}" ] && [ -w "${LOG_FILE}" ]
	then
		printf "%s: %s\n" "${TIMESTAMP}" "${LOG_MSG}" | tee -a "${LOG_FILE}" 
	else
		printf "%s: %s\n" "${TIMESTAMP}" "${LOG_MSG}"
	fi
}

# get current time.
get_current_time () {
	printf %s "$(date +"${DATE_FORMAT}")"
}

#
# END OF FILE
#
