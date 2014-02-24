#!/bin/bash

list_size () {
	local list="$1"
	! [ -f "${list}" ] && echo 0 && return 1
	echo $(wc -l < "${list}")
}

list_enumerate () {
	local list="$1"
	local highlight="$2"
	local index=1
	! [ -f "${list}" ] && return 1
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
	! [ -f "${list}" ] && return 1
	# notice: this is not efficient.
	list_enumerate "${list}" | grep -i "${search_term}" --color=always
}

list_get () {
	local list="$1"
    local index="$2"
	! [ -f "${list}" ] && return 1
	local line_count=$(list_size "${list}")
	if [[ "${index}" -lt 1 ]] || [[ "${index}" -gt "${line_count}" ]] ; then return 1; fi
    sed -n ${index}p < "${list}"
    return 0
}

list_put () {
	local list="$1"
	local entry="$2"
	local index="$3"
	if [ -z "${index}" ] || [ "${index}" -le "1" ] || [ "${index}" -gt $(list_size "${list}") ]
	then
		echo "${entry}" >> "${list}"
	else
		sed -i "${index}i${entry}" "${list}"
	fi
}

list_delete () {
	local list="$1"
	local index="$2"
	! [ -f "${list}" ] && return 1
	sed -i "${index}d" "${list}"
}

list_clear () {
	local list="$1"
	! [ -f "${list}" ] && return 1
	> "${list}"
}

