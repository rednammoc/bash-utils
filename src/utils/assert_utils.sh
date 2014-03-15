#!/bin/bash
# name: assert_utils.sh
# description: Utils to support automating tests.
# version: 0.1
# author: rednammoc
#
[ -z "${APP_NAME}" ] && echo "Illegal State: No APP_NAME was specified." && return 1

BASH_UTILS_DIR=${BASH_SOURCE%/*}
if [[ ! -d "$BASH_UTILS_DIR" ]]; then BASH_UTILS_DIR="$PWD"; fi
source "${BASH_UTILS_DIR}/core_utils.sh"

require ../../lib/assert.sh/assert.sh

ASSERT_UTILS_SETUP=true
ASSERT_UTILS_TEAR_DOWN=true

# You should overwrite \"setup\" to call your own routines.
#  Set ASSERT_UTILS_SETUP=false in your script to disable calling this method.
function setup
{
	local test="$1"
	echo "Setup ${test} ..."
}

# You should overwrite \"tear_down\" to call your own routines.
#  Set ASSERT_UTILS_TEAR_DOWN=false in your script to disable calling this method.
function tear_down
{
	local test="$1"
	echo "Tearing Down ${test} ..."
}

function run_tests
{
	local src="$1"
	local title="$(basename "${src}")"
	test_functions=$(cat "${src}" | grep "function test" | cut -f2 -d' ')
	for test in ${test_functions}
	do
		[ "${ASSERT_UTILS_SETUP}" ] 		&& setup 		"${test}"
		eval "${test}"
		[ "${ASSERT_UTILS_TEAR_DOWN}" ] 	&& tear_down	"${test}"
	done
	assert_end "${title}"
}
