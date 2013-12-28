#!/bin/bash
# name: config_utils.sh
# description: Utils to read, load and validate config-file..
# version: 0.1
# author: rednammoc
#
CONFIG_FILE="/etc/${APP_NAME}.conf"

# validate config-file
config_validate() {
	local CONFIG_FILE="$1"
	log "$LOG_MSG_NOT_OVERWRITTEN_FUNCTION"
	return 1
}

# loads config-file and calls config_validate.
config_load() {
	local CONFIG_FILE="$1"
	if ! [ -e "${CONFIG_FILE}" ]
	then
		log "Couldn't load config-file at \"${CONFIG_FILE}\" ..."
		return 1
	fi

	if ! [ -r "${CONFIG_FILE}" ]
	then
		log "No permission to read config-file at \"${CONFIG_FILE}\" ..."
		return 1
	fi

	if [ $(config_validate "${CONFIG_FILE}") -eq 0 ]
	then
		source "${CONFIG_FILE}"
		return 0
	fi
	
	return 1
}

# write entry in config-file.
config_write_field() {
	local CONFIG_FILE="$1"
	local FIELD_NAME="$2"
	local FIELD_VALUE="$3"
	sed -i "s@\(${FIELD_VALUE} *= *\).*@\1${FIELD_NAME}@" "${CONFIG_FILE}"
}

# get entry from config-file
config_read_field() {
	local CONFIG_FILE="$1"
	local FIELD_NAME="$2"
	grep --only-matching --perl-regex "(?<=${FIELD_NAME}\=).*" "${CONFIG_FILE}"
}

#
# END OF FILE
#
