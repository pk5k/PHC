#!/bin/bash/
# Get directory, this script is located at
__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

script=$1;

# consume $1
shift;

# if no command was given, use "help" as default
if [ -z "$script" ]; then 
	script="help";
fi

#echo "execution of \"$script\" begins";
php "$__DIR__/../_hcdk/cli/env.php" "$script" "$PWD" "$@";
#echo "execution \"$script\" finished";