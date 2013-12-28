#!/bin/bash
# name: daemon_utils.sh
# description: Daemon which can be used by other scripts..
# version: 0.1
# author: rednammoc
#

source "log_utils.sh"
source "config_utils.sh"

# trap keyboard interrupt (control-c)
#  This allows to safely exit our script and avoids 
#  corrupting our ${DATA_FILE}. 
trap daemon_control_c SIGINT
daemon_control_c() {
	echo -e "\nExiting safely ..."
}

# can be used to cleanup when exiting daemon.
daemon_cleanup() {
	log "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
	return 1
}

# can be used to load data to stdout.
daemon_data_load() {
	log "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
	return 1
}

# can be used to process data.
daemon_data_process() {
	log "${LOG_MSG_NOT_OVERWRITTEN_FUNCTION}"
	return 1
}

# Lifecycle
# 
# 1. Refresh config-file. 
# 2. Load and process data.  
# 3. Sleep.
# 4. Repeat.
#
while [ true ]
do
	# Refreshing config-file.
	config_load "${CONFIG_FILE}"
	if [ $? -eq 1 ]
	then
		# Error occured during loading config-file.
		echo "Abort."
		exit 1
	fi

	# Retrieve and write data, when retrieving data was successful.
	DATA=$(daemon_data_load)
	if [ $? -eq 0 ]
	then
		if [ $(daemon_data_process "${DATA}") -eq 1 ]
		then
			echo "Abort."
			exit 1
		fi
	else
		log "Loading data failed!"
	fi

	sleep ${SLEEP_TIME}

	# Trapping ctrl-c for save exiting our daemon.
	if [ $? -gt 128 ]
	then
		daemon_cleanup
		echo "Goodbye ..."
		break
	fi
done
#
# END OF FILE
#
