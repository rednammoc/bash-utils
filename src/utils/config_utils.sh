#!/bin/bash
# name: config_utils.sh
# description: Utils to read, load and validate config-file..
# version: 0.1
# author: rednammoc
#
if [ -z "${APP_NAME}" ]
then
	echo "ILLEGAL-STATE: No APP_NAME was specified."
	exit 1
fi

# use default configuration-file, when no configuration-file was set.
if [[ -z "${CONFIG_FILE}" ]]; then CONFIG_FILE="/etc/${APP_NAME}.conf"; fi

# setup config should initially construct the default configuration-file.
config_setup() {
	local CONFIG_FILE="$1"
	error "$LOG_MSG_NOT_OVERWRITTEN_FUNCTION"
	return 1
}

# check if field is set.
config_validate_field_set() {
	local CONFIG_FILE="$1"
    local FIELD="$2"
	local VALUE=$(config_read_field "${CONFIG_FILE}" "${FIELD}")
    if [ -z "${VALUE}" ]
    then
        error "${FIELD} is not set."
        return 1
    fi
    return 0
}

# check if a bunch of fields is set.
config_validate_fields_set() {
	local CONFIG_FILE="$1"
	local SUCCESS=0
	shift
    for FIELD in "$@"
    do
        config_validate_field_set "${CONFIG_FILE}" "${FIELD}" 
		if [ $? -ne 0 ] ; then SUCCESS=1; fi
    done
	return "${SUCCESS}"
}

# validate config-file.
config_validate() {
	local CONFIG_FILE="$1"
	error "$LOG_MSG_NOT_OVERWRITTEN_FUNCTION"
	return 1
}

# load config-file.
config_load() {
	local CONFIG_FILE="$1"
	if ! [ -e "${CONFIG_FILE}" ]
	then
		error "Couldn't load config-file at \"${CONFIG_FILE}\" ..."
		return 1
	fi

	if ! [ -r "${CONFIG_FILE}" ]
	then
		error "No permission to read config-file at \"${CONFIG_FILE}\" ..."
		return 1
	fi

	config_validate "${CONFIG_FILE}"
	if [ $? != 0 ] 
	then
		error "Validation of config-file \"${CONFIG_FILE}\" failed ..."
		return 1
	fi

	source "${CONFIG_FILE}"

	return 0
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
