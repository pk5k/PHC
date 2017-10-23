#!/bin/bash/
# execute this file, to make the "hcdk" binary avaiable in your terminal

# Get directory, this script is located at
__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

target=""
if [ -f ~/.bashrc ]; then
	target=~/.bashrc
elif [ -f ~/.bash_profile ]; then
	target=~/.bash_profile
else
	echo "Unable to locate bash-initialisation file - neither ~/.bashrc nor ~/.bash_profile were found"
fi

hcdk_alias="alias hcdk=\"bash $__DIR__/hcdk.sh\""

echo "Writing hcdk-alias to $target: $hcdk_alias..."
echo "$hcdk_alias">>"$target"
echo "...done"
echo "setup complete - restart your terminal session and type \"hcdk\""
