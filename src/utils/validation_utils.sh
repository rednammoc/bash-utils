#!/bin/bash

is_numeric() { [[ ${1} =~ ^[-+]?[0-9]+\.?[0-9]*$ ]] ; }
is_float() { is_numeric "$1"; }
is_integer() { [[ ${1} =~ ^[0-9]+$ ]] ; }
is_empty() { [[ -z ${1} ]] ; }
