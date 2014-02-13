#!/bin/bash

BASH_UTILS_DIR=${BASH_SOURCE%/*}
if [[ ! -d "${BASH_UTILS_DIR}" ]]; then BASH_UTILS_DIR="$PWD"; fi
if [[ -f "${BASH_UTILS_DIR}/core.sh" ]]; then source "${BASH_UTILS_DIR}/core.sh"; else
	echo "ERROR: Bash-Utils-Core not found! Abort."; 
	exit 1;
fi
require "log_utils.sh"

list_get_size () {
	local LIST="$1"
	echo $(wc -l < "${LIST}")
}

list_enumerate () {
	local LIST="$1"
	local INDEX=1
	while read LINE
	do
		printf "%+6s      %s\n" "${INDEX}" "${LINE}"
		INDEX=$(expr ${INDEX} + 1)
	done <&${LIST}
	return 0
}

list_get_line () {
	local LIST="$1"
    local INDEX="$2"
	local LINE_COUNT=$(list_get_size)
    line_validate_index "${INDEX}" "${LINE_COUNT}"
    if [ $? -ne 0 ] ; then return $?; fi
    sed -n ${INDEX}p < "${LIST}"
    return 0
}
