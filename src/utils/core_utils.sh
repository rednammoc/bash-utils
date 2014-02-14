#!/bin/bash
# TODO: Instead of require BASH_UTILS_DIR use array to store path's to search for.

# Prevent core to be sourced more than once.
if [[ -z "${_BASH_UTILS_CORE}" ]] ; then _BASH_UTILS_CORE=1; else return; fi
_BASH_UTILS_REQUIRED_FILES=()
_BASH_UTILS_REQUIRED_PATHS=()

#
# Helper
#

_strip_file () {
	# remove ./ from file.
	[[ $1 == "./"* ]] && echo ${1:2} && return 
	echo $1
}
_is_in_list () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1	
}
_was_already_added () { _is_in_list "$1" "${_BASH_UTILS_REQUIRED_PATHS[@]}"; }
_was_already_required () { _is_in_list "$1" "${_BASH_UTILS_REQUIRED_FILES[@]}"; }
_get_required_path () {
  local e
  for e in "${_BASH_UTILS_REQUIRED_PATHS[@]}"; do [[ -f "$e/$1" ]] && echo "$e" && return 0; done
  return 1	
}

#
# Core
#

require_path_add () {
	local path="$1"
	! [ -d "${path}" ] && echo "ERROR: \"${path}\" not found!" && return 1
	_was_already_added "${path}" && return 1
	_BASH_UTILS_REQUIRED_PATHS+=(${path}) 
	return 0
}

_require () {
	local requirement=$(_strip_file "$1")
	! [ -f "${requirement}" ] && echo "ERROR: _require failed! \"${requirement}\" not found! Abort." && exit 1
	_was_already_required "${requirement}" && return
	_BASH_UTILS_REQUIRED_FILES+=(${requirement})
	source "${requirement}"
	return 0
}

_lock () {
	local requirement=$(_strip_file "$1")
	[ -z "${requirement}" ] && return 1
	! [ -f "${requirement}" ] && echo "ERROR: _lock failed! \"${requirement}\" not found! Abort." && exit 1
	_was_already_required "${requirement}" && return
	_BASH_UTILS_REQUIRED_FILES+=(${requirement})
 }

# Usage: require "log_utils.sh"
require () {
	_lock $(caller 3 | cut -f3 -d' ')
	local requirements="$@"
	for requirement in "${requirements}"
	do
		if ! [ -f "${requirement}" ]
		then
			local path=$(_get_required_path "${requirement}")
			[ -z "${path}" ] &&	echo "ERROR: require failed! \"${requirement}\" not found! Abort." && exit 1
			requirement="${path}/${requirement}"
		fi
		_require "${requirement}"
	done
	return 0
}

_core_init () {
	[[ -z "${BASH_UTILS_DIR}" ]] && echo "ERROR: BASH_UTILS_DIR not set!" && exit 1
	require_path_add "${BASH_UTILS_DIR}"
}

# Init core.
_core_init
