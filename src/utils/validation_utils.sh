#!/bin/bash

is_numeric() { [[ ${1} =~ ^[-+]?[0-9]+\.?[0-9]*$ ]] ; }
is_float() { is_numeric "$1"; }
is_integer() { [[ ${1} =~ ^[0-9]+$ ]] ; }
is_empty() { [[ -z ${1} ]] ; }
does_exist() { [[ -f "${1}" ]] || [[ -d "${1}" ]] ; }
is_readable() { [[ -r "${1}" ]] ; }
