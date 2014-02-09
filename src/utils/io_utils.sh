#!/bin/bash
read_from_pipe () { read "$@" <&0; }
is_pipe_active () { [ "$( tty )" == 'not a tty' ] && { return 0 } || { return 1 } }
