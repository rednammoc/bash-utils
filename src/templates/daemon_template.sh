#!/bin/bash
# name: daemon_template.sh
# description: This template can be used to develop a daemon-process.
# version: 0.1
# author: rednammoc
#

APP_NAME="daemon_template"
APP_DESCRIPTION="description of what this daemon does."

BASH_TEMPLATES_DIR=${BASH_SOURCE%/*}
if [[ ! -d "$BASH_TEMPLATES_DIR" ]]; then BASH_TEMPLATES_DIR="$PWD"; fi
BASH_UTILS_DIR="${BASH_TEMPLATES_DIR}/../utils/"
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

daemon_service $@

#
# END OF FILE
#
