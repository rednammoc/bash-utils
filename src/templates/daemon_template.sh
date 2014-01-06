#!/bin/bash
APP_NAME="daemon_template"
APP_DESCRIPTION="description of what this daemon does."
APP_DIR=${BASH_SOURCE%/*}
APP_VERSION="0.1"
APP_AUTHOR="rednammoc"
APP_AUTHOR_EMAIL="rednammoc@gmx.de"

if [[ ! -d "$APP_DIR" ]]; then APP_DIR="$PWD"; fi
BASH_UTILS_DIR="${APP_DIR}/../utils/"
BASH_UTILS_DAEMON="${BASH_UTILS_DIR}/daemon_utils.sh"
source "${BASH_UTILS_DAEMON}"

# can be used to cleanup when exiting daemon.
daemon_cleanup() {
    error "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
    return 0
}

# can be used to load data to stdout.
daemon_data_load() {
    error "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
    return 0
}

# can be used to process data.
daemon_data_process() {
    error "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
    return 0
}

# Retrieve and write data, when retrieving data was successful.
daemon_process() {
	DATA=$(daemon_data_load)
	if [ $? -eq 0 ] 
	then
		daemon_data_process "${DATA}"
		if [ $? -ne 0 ] 
		then
			echo "Abort."
			exit 1
		fi  
	else
		warn "Loading data failed!"
	fi
}

# Call daemon_service with user-supplied arguments.
# ( see daemon_utils.sh for more information )
daemon_service $@

#
# END OF FILE
#
