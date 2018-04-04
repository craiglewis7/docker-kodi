#!/bin/bash

# ehough/docker-kodi - Kodi in a Docker container
#
# https://github.com/ehough/docker-kodi
#
# Copyright 2018 - Eric Hough (eric@tubepress.com)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


###########################################################################################################
# This script runs on the Docker host, and is a wrapper around the Docker CLI and x11docker. Its primary
# purpose is to provide a means to cleanly stop the running Kodi container, which will in turn stop the
# parent x11docker process.
###########################################################################################################


###########################################################################################################
###########################################################################################################
## START ARGBASH CODE #####################################################################################
###########################################################################################################
###########################################################################################################

#
# ARG_OPTIONAL_SINGLE([action],[a],[action to perform (start, stop, or status],[start])
# ARG_HELP([])
# ARG_VERBOSE([v])
# ARG_POSITIONAL_DOUBLEDASH([])
# ARG_POSITIONAL_INF([x11docker-argument],[arguments to pass to x11docker])
# ARGBASH_GO()
# needed because of Argbash --> m4_ignore([
### START OF CODE GENERATED BY Argbash v2.6.1 one line above ###
# Argbash is a bash code generator used to get arguments parsing right.
# Argbash is FREE SOFTWARE, see https://argbash.io for more info
# Generated online by https://argbash.io/generate

# When called, the process ends.
# Args:
#   $1: The exit message (print to stderr)
#   $2: The exit code (default is 1)
# if env var _PRINT_HELP is set to 'yes', the usage is print to stderr (prior to )
argbash_die () {

  local _ret=$2
  test -n "$_ret" || _ret=1
  test "$_PRINT_HELP" = yes && argbash_print_help >&2
  echo "$1" >&2
  exit ${_ret}
}

# Function that evaluates whether a value passed to it begins by a character
# that is a short option of an argument the script knows about.
# This is required in order to support getopts-like short options grouping.
argbash_begins_with_short_option() {

  local first_option all_short_options
  all_short_options='ahv'
  first_option="${1:0:1}"
  test "$all_short_options" = "${all_short_options/$first_option/}" && return 1 || return 0
}

# THE DEFAULTS INITIALIZATION - POSITIONALS
# The positional args array has to be reset before the parsing, because it may already be defined
# - for example if this script is sourced by an argbash-powered script.
_positionals=()
_arg_x11docker_argument=()
# THE DEFAULTS INITIALIZATION - OPTIONALS
_arg_action="start"
_arg_image="ehough/kodi:alsa"
_arg_verbose=0

# Function that prints general usage of the script.
# This is useful if users asks for it, or if there is an argument parsing error (unexpected / spurious arguments)
# and it makes sense to remind the user how the script is supposed to be called.
argbash_print_help () {

  printf 'Usage: %s [-a|--action <arg>] [-i|--image <arg>] [-h|--help] [-v|--verbose] [--] [<x11docker-argument-1>] ... [<x11docker-argument-n>] ...\n' "$0"
  printf '\t%s\n' "<x11docker-argument>: arguments to pass to x11docker"
  printf '\t%s\n' "-a,--action: action to perform (start, stop, or status (default: 'start')"
  printf '\t%s\n' "-i,--image: image name or identifier to execute (default: 'ehough/kodi:alsa')"
  printf '\t%s\n' "-h,--help: Prints help"
  printf '\t%s\n' "-v,--verbose: Set verbose output (can be specified multiple times to increase the effect)"
}

# The parsing of the command-line
argbash_parse_commandline () {

  while test $# -gt 0
  do
    _key="$1"
  # If two dashes (i.e. '--') were passed on the command-line,
  # assign the rest of arguments as positional arguments and bail out.
  if test "$_key" = '--'
  then
    shift
    _positionals+=("$@")
    break
  fi
    case "$_key" in
      # We support whitespace as a delimiter between option argument and its value.
      # Therefore, we expect the --action or -a value.
      # so we watch for --action and -a.
      # Since we know that we got the long or short option,
      # we just reach out for the next argument to get the value.
      -a|--action)
        test $# -lt 2 && argbash_die "Missing value for the optional argument '$_key'." 1
        _arg_action="$2"
        shift
        ;;
      # We support the = as a delimiter between option argument and its value.
      # Therefore, we expect --action=value, so we watch for --action=*
      # For whatever we get, we strip '--action=' using the ${var##--action=} notation
      # to get the argument value
      --action=*)
        _arg_action="${_key##--action=}"
        ;;
      # We support getopts-style short arguments grouping,
      # so as -a accepts value, we allow it to be appended to it, so we watch for -a*
      # and we strip the leading -a from the argument string using the ${var##-a} notation.
      -a*)
        _arg_action="${_key##-a}"
        ;;
      # See the comment of option '--action' to see what's going on here - principle is the same.
      -i|--image)
        test $# -lt 2 && die "Missing value for the optional argument '$_key'." 1
        _arg_image="$2"
        shift
        ;;
      # See the comment of option '--action=' to see what's going on here - principle is the same.
      --image=*)
        _arg_image="${_key##--image=}"
        ;;
      # See the comment of option '-a' to see what's going on here - principle is the same.
      -i*)
        _arg_image="${_key##-i}"
        ;;
      # The help argurment doesn't accept a value,
      # we expect the --help or -h, so we watch for them.
      -h|--help)
        argbash_print_help
        exit 0
        ;;
      # We support getopts-style short arguments clustering,
      # so as -h doesn't accept value, other short options may be appended to it, so we watch for -h*.
      # After stripping the leading -h from the argument, we have to make sure
      # that the first character that follows coresponds to a short option.
      -h*)
        argbash_print_help
        exit 0
        ;;
      # See the comment of option '--help' to see what's going on here - principle is the same.
      -v|--verbose)
        _arg_verbose=$((_arg_verbose + 1))
        ;;
      # See the comment of option '-h' to see what's going on here - principle is the same.
      -v*)
        _arg_verbose=$((_arg_verbose + 1))
        _next="${_key##-v}"
        if test -n "$_next" -a "$_next" != "$_key"
        then
          argbash_begins_with_short_option "$_next" && shift && set -- "-v" "-${_next}" "$@" || argbash_die "The short option '$_key' can't be decomposed to ${_key:0:2} and -${_key:2}, because ${_key:0:2} doesn't accept value and '-${_key:2:1}' doesn't correspond to a short option."
        fi
        ;;
      *)
        _positionals+=("$1")
        ;;
    esac
    shift
  done
}

# Take arguments that we have received, and save them in variables of given names.
# The 'eval' command is needed as the name of target variable is saved into another variable.
argbash_assign_positional_args () {

  # We have an array of variables to which we want to save positional args values.
  # This array is able to hold array elements as targets.
  _positional_names=()
  # If we allow up to infinitely many args, we calculate how many of values
  # were actually passed, and we extend the target array accordingly.
  _our_args=$((${#_positionals[@]} - ${#_positional_names[@]}))
  for ((ii = 0; ii < _our_args; ii++))
  do
    _positional_names+=("_arg_x11docker_argument[$((ii + 0))]")
  done

  for (( ii = 0; ii < ${#_positionals[@]}; ii++))
  do
    eval "${_positional_names[ii]}=\${_positionals[ii]}" || argbash_die "Error during argument parsing, possibly an Argbash bug." 1
  done
}

# Now call all the functions defined above that are needed to get the job done
argbash_parse_commandline "$@"
argbash_assign_positional_args

unset -v ii _positionals _positional_names _our_args _key

###########################################################################################################
###########################################################################################################
## END ARGBASH CODE #######################################################################################
###########################################################################################################
###########################################################################################################

log () {

  if [[ $_arg_verbose -ge 1 ]]; then
    echo "---> $1"
  fi
}

bail () {

  echo ""
  echo "FATAL ERROR: $1"
  echo ""
  exit 1
}

warn_on_failure () {

  if [[ $? -ne 0 ]]; then
    log "WARNING: $1"
  fi
}

bail_on_failure () {

  if [[ $? -ne 0 ]]; then
    bail "$1"
  fi
}

ensure_executable () {

  log "ensuring that $1 is executable"

  local command_result
  command_result=$(command -v "$1")

  if [[ ! -x "$command_result" ]]; then
    bail "$1 is missing or not executable"
  else
    log "$1 is executable at $command_result"
  fi
}

find_running_container_id () {

  log "asking Docker for a running Kodi container"
  docker ps --filter "name=x11docker_" --filter "name=kodi" --filter "status=running" -q --last 1
  bail_on_failure "unable to query Docker for Kodi container status"
}

stop_kodi () {

  log "stopping $_arg_image"

  local container_id
  container_id=$(find_running_container_id)

  if [[ -n "$container_id" ]]; then
    docker stop "$container_id"
    bail_on_failure "Docker returned an error when we tried to stop $container_id"
  else
    log "$_arg_image did not appear to be running"
  fi
}

start_kodi () {

  log "starting $_arg_image"

  ensure_executable 'x11docker'

  local command
  local i
  command='x11docker'

  if [[ $_arg_verbose -ge 1 ]]; then
    command="$command -v"
  fi

  for i in "${_arg_x11docker_argument[@]}"; do
    command="$command $i"
  done

  command="$command $_arg_image"

  # gracefully stop Kodi whenever this script is terminated for any reason
  trap stop_kodi EXIT

  log "will now execute: $command"

  # this is where x11docker will take over
  "$command"

  # x11docker finished
  warn_on_failure "command did not exit cleanly: $command"
}

status_kodi () {

  log "checking to see if $_arg_image is running"

  local container_id
  container_id=$(find_running_container_id)

  if [[ -n "$container_id" ]]; then
    echo "$_arg_image appears to be running in container $container_id"
  else
    echo "$_arg_image does not appear to be running"
  fi
}

go () {

  case "$_arg_action" in
    start|stop|status)
      ;;
    *)
      argbash_print_help
      exit 1
  esac

  case "$_arg_action" in
    start)
      start_kodi
      ;;
    stop)
      stop_kodi
      ;;
    status)
      status_kodi
      ;;
  esac
}

go