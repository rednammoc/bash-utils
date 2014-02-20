#!/bin/bash
# name: log_utils.sh
# description: Collection of utils to log messages into stdin and log-file..
# version: 0.1
# author: rednammoc
#
[ -z "${APP_NAME}" ] && echo "Illegal State: No APP_NAME was specified." && return 1
LOG_FILE="/var/log/${APP_NAME}.log"
touch "${LOG_FILE}" &> /dev/null
! [ -e "${LOG_FILE}" ] && echo "Warning: Log-File \"${LOG_FILE}\" does not exist!" && exit 1
! [ -w "${LOG_FILE}" ] && echo "Warning: Log-File \"${LOG_FILE}\" is not writeable!" && exit 1

# Log-levels
#
#  -1 - disabled
#	0 - error
#	1 - warn
#	2 - info
#	3 - debug
#	4 - trace
#
LOG_LEVEL=4

# Global log-messages which can be used inside your application.
LOG_MSG_NOT_OVERWRITTEN_FUNCTION="Not implemented! You need to overwrite this function inside your application."

# controls the date-format used. 
DATE_FORMAT='%Y/%m/%d %H:%M:%S'

# appends timestamp to log-message and prints message to stdin and log-file.
#
# deprecated: This should only be called within log_utils. 
# 	use error, warn, info, debug or trace instead.
log () {
	local TIMESTAMP=$(get_current_time)
	local LOG_MSG="${TIMESTAMP}: $1"
	log_write "${LOG_MSG}"
}

# prints message to stdin and log-file.
log_write () {
	local LOG_MSG="$1"
	if [ -e "${LOG_FILE}" ] && [ -w "${LOG_FILE}" ]
	then
		echo -e "${LOG_MSG}" | tee -a "${LOG_FILE}" 
	else
		echo -e "${LOG_MSG}"
	fi
}

log_trace () {
	local LOG_CALLER=$(caller 1)
	log_write "\tTrace: ${LOG_CALLER}" 
}

# appends the execution stack to a log-message.
trace () {
	local LOG_MSG="$1"
	if [ "${LOG_LEVEL}" -ge 4 ]
	then
		log "${LOG_MSG}"
		log_trace
	fi
}

debug () {
	local LOG_MSG="$1"
	if [ "${LOG_LEVEL}" -ge 3 ]
	then
		log "${LOG_MSG}"
		log_trace
	fi
}

info () {
	local LOG_MSG="$1"
	if [ "${LOG_LEVEL}" -ge 2 ]
	then
		log "${LOG_MSG}"
	fi
}

warn () {
	local LOG_MSG="$1"
	if [ "${LOG_LEVEL}" -ge 1 ]
	then
		log "${LOG_MSG}"
		log_trace
	fi
}

error () {
	local LOG_MSG="$1"
	if [ "${LOG_LEVEL}" -ge 0 ]
	then
		log "${LOG_MSG}"
		log_trace
	fi
}

# get current time.
get_current_time () {
	printf %s "$(date +"${DATE_FORMAT}")"
}

#
# END OF FILE
#
