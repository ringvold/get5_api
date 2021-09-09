#!/usr/bin/env bash

# This is a script suggested by the Elixir documentation (https://hexdocs.pm/elixir/Port.html)
# on how to handle executables that do not gracefully terminate
# when stdin/stdout is cloused. This script fixes this.

# https://github.com/phoenixframework/phoenix/issues/2215


# Start the program in the background
exec "$@" &
pid1=$!

# Silence warnings from here on
exec >/dev/null 2>&1

# Read from stdin in the background and
# kill running program when stdin closes
exec 0<&0 $(
  while read; do :; done
  kill -KILL $pid1
) &
pid2=$!

# Clean up
wait $pid1
ret=$?
kill -KILL $pid2
exit $ret