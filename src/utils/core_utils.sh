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
	! [ -d "${path}" ] && echo >&2 "ERROR: \"${path}\" not found!" && return 1
	_was_already_added "${path}" && return 1
	_BASH_UTILS_REQUIRED_PATHS+=(${path}) 
	return 0
}

_require () {
	local requirement=$(_strip_file "$1")
	! [ -f "${requirement}" ] && echo >&2 "ERROR: _require failed! \"${requirement}\" not found! Abort." && return 1
	_was_already_required "${requirement}" && return
	_BASH_UTILS_REQUIRED_FILES+=(${requirement})
	source "${requirement}"
	return 0
}

# _lock will add the script which is calling the require-command to the required files.
#  This will prevent the require-command to include the caller-script again.  
_lock () {
	local requirement=$(_strip_file "$1")
	[ -z "${requirement}" ] && return 1
	! [ -f "${requirement}" ] && echo >&2 "ERROR: _lock failed! \"${requirement}\" not found! Abort." && return 1
	_was_already_required "${requirement}" && return
	_BASH_UTILS_REQUIRED_FILES+=(${requirement})
 }

# require will include scripts within the caller. It will prevent from include cyclic dependencies.
require () {
	_lock $(caller 3 | cut -f3 -d' ')
	local requirements="$@"
	for requirement in "${requirements}"
	do
		if ! [ -f "${requirement}" ]
		then
			local path=$(_get_required_path "${requirement}")
			[ -z "${path}" ] &&	echo >&2 "ERROR: require failed! \"${requirement}\" not found! Abort." && return 1
			requirement="${path}/${requirement}"
		fi
		_require "${requirement}"
	done
	return 0
}

# depends will print an error message and return false when an dependent command does not exist.
depends () {
	local commands="$@"
	local commands_found=true
	for command in "${commands}"
	do
		if ! command -v "${command}" >/dev/null 2>&1
		then
			echo >&2 "Dependent command \"${command}\" was not found. Abort."
			commands_found=false
		fi
	done
	return "${commands_found}"
}

_core_init () {
	[[ -z "${BASH_UTILS_DIR}" ]] && echo >&2 "ERROR: BASH_UTILS_DIR not set!" && return 1
	require_path_add "${BASH_UTILS_DIR}"
}

# Init core.
_core_init
