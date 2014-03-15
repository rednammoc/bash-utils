#!/bin/bash
# name: assert_utils.sh
# description: Utils to support automating tests.
# version: 0.1
# author: rednammoc
#
[ -z "${APP_NAME}" ] && echo "Illegal State: No APP_NAME was specified." && return 1

ASSERT_UTILS_SETUP=true
ASSERT_UTILS_TEAR_DOWN=true

function setup
{
	[ "${ASSERT_UTILS_SETUP}" ] || return
	echo "Setup test. You can overwrite \"setup\" to call your own routines."
	echo "Set ASSERT_UTILS_SETUP=false to disable calling this method and printing this information."
}

function tear_down
{
	[ "${ASSERT_UTILS_TEAR_DOWN}" ] || return
	echo "TearDown test. You can overwrite \"tear_down\" to call your own routines."
	echo "Set ASSERT_UTILS_TEAR_DOWN=false to disable calling this method and printing this information."
}

function run_tests
{
	local src="$1"
	test_functions=$(cat "${src}" | grep "function test" | tail -n+2 | cut -f2 -d' ')
	for test in ${test_functions}
	do
		setup
		eval $test
		tear_down
	done
	assert_end "${src}"
}
