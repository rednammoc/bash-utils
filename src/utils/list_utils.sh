#!/bin/bash

list_size () {
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
	done <"${LIST}"
	return 0
}

list_enumerate_search () {
	local list="$1"
	local search_term="$2"
	# notice: this is not efficient.
	list_enumerate "${list}" | grep -i "${search_term}" --color=always
}

list_get () {
	local LIST="$1"
    local INDEX="$2"
	local LINE_COUNT=$(list_size "${LIST}")
	if [[ "${INDEX}" -lt 1 ]] || [[ "${INDEX}" -gt "${LINE_COUNT}" ]] ; then return 1; fi
    sed -n ${INDEX}p < "${LIST}"
    return 0
}

list_put () {
	local list="$1"
	local entry="$2"
	# notice: index is ignored for now but may be added in the future.
	local index="$3"
	echo "${entry}" >> "${list}"
}

list_delete () {
	local list="$1"
	local index="$2"
	sed -i "${index}d" "${list}"
}

list_clear () {
	local list="$1"
	> "${list}"
}

