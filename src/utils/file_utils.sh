#!/bin/bash
# name: file_utils.sh
# description: Collection of utils to interact with files.
# version: 0.2
# author: rednammoc

require "log_utils.sh"

# checks whether a required file exists and is writeable.
exit_when_file_not_writeable() {
	local file="$1"
    touch ${file} &> /dev/null
    if [ $? -ne 0 ] 
    then
        log "Couldnt write file at \"${file}\" ..."
        echo "Abort."
        exit 1
    fi  
}

# checks wheter an array of required files exists and are writeable.
exit_when_files_not_writeable() {
	local files="$1"
	for file in "${files[@]}"
	do
		exit_when_file_not_writeable "${file}"
	done
}

# get filename of file without path.
get_file_full_filename() {
	local file="$1"
	echo $(basename "${file}")
}

# get filename of file without path and extension.
get_file_filename() {
	local file="$1"
	local full_filename=$(basename "${file}")
	echo "${full_filename%.*}"
}

# get extension of file.
get_file_extension() {
	local file="$1"
	local full_filename=$(basename "${file}")
	echo "${full_filename##*.}"
}

# get file path.
get_file_path() {
	local file="$1"
	echo $(dirname "${file}")
}

# removes unnecessary characters from filename.
strip_filename() {
	[[ $1 == "./"* ]] && echo ${1:2} && return
    echo $1
}
