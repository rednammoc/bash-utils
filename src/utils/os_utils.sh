#!/bin/bash

# Get pid of session leader.
pid_leader () {
	echo $(echo $( cut -f 6 -d ' ' /proc/self/stat ) )
}
