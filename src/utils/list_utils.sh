#!/bin/bash

list_size () {
	local LIST="$1"
	echo $(wc -l < "${LIST}")
}

list_enumerate () {
	local list="$1"
	local highlight="$2"
	local index=1
	while read line
	do
		local color=''
		if [ $index -eq $highlight ] 
		then
			printf "\e[1;34m%+6s      %s\e[m\n" "${index}" "${line}"
		else
			printf "%+6s      %s\n" "${index}" "${line}"
		fi
		index=$(expr ${index} + 1)
	done <"${list}"
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
	local index="$3"
	if [ -z "${index}" ]
	then
		echo "${entry}" >> "${list}"
	else
		sed -i "${index}i${entry}" "${list}"
	fi
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

