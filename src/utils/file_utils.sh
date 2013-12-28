#!/bin/bash
# name: file_utils.sh
# description: Collection of utils to interact with files.
# version: 0.1
# author: rednammoc

source "log_utils.sh"

# checks whether a required file exists and is writeable.
exit_when_file_not_writeable() {
	FILE="$1"
    touch ${FILE} &> /dev/null
    if [ $? -ne 0 ] 
    then
        log "Couldnt write file at \"${FILE}\" ..."
        echo "Abort."
        exit 1
    fi  
}

# checks wheter an array of required files exists and are writeable.
exit_when_files_not_writeable() {
	FILES="$1"
	for FILE in "${FILES[@]}"
	do
		exit_when_file_not_writeable "${FILE}"
	done
}
