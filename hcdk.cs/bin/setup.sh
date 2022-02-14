#!/bin/bash/
# execute this file, to make the "hcdk" binary avaiable in your terminal
# pass the name of your bash-profile file as first argument if you using a different than ".bashrc" and ".bash_profile"

# Get directory, this script is located at
__DIR__="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 
target="";

if [ -f ~/$1 ]; then 
	target=~/$1
elif [ -f ~/.bashrc ]; then
	target=~/.bashrc
elif [ -f ~/.bash_profile ]; then
	target=~/.bash_profile
else
	echo "Unable to locate bash-initialisation file - neither ~/.bashrc nor ~/.bash_profile were found - trying it with creating ~/.bash_profile"
	target=~/.bash_profile
	touch $target
fi

hcdk_alias="alias hcdk=\"bash $__DIR__/hcdk.sh\""

echo "Writing hcdk-alias to $target: $hcdk_alias..."
echo "$hcdk_alias">>"$target"
echo "...done"
echo "setup complete - restart your terminal session and type \"hcdk\""
