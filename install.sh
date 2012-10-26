#!/bin/bash
# 
#       install.sh
#       
#       Copyright 2012 Francesco Ruvolo <ruvolof@gmail.com>
#       
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License, or
#       (at your option) any later version.
#       
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#       
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.
#       
#       

PREFIX="/usr/"
BIN="$PREFIX/bin/cyc"
HOMEBIN="$HOME/bin/cyc"

function help {
	echo "Usage: ./install.sh <options>"
	echo "Available options:"
	echo "	-h, --help	Show this help and exit."
	echo "	--force		Force reinstall."
	echo "	uninstall	Uninstall Count-Your-Code."
}

function uninstall {
	if [ -e "$BIN" ] ; then
		if [ $1 -eq 0 ] ; then
			echo "Removing $BIN..."
			rm $BIN
		else
			echo "You need root privileges to uninstall it."
		fi
	elif [ -e $HOMEBIN ] ; then
		echo "Removing $HOMEBIN..."
		rm $HOMEBIN
	else
		echo "Count-Your-Code doesn't seem to be installed."
	fi
}

if [[ "$*" =~ -h ]] || [[ "$*" =~ --help ]] ; then
	help
	exit 0
fi

ROOT=`id -u`

if [[ "$*" =~ uninstall ]] ; then
	uninstall $ROOT
	exit 0
fi

if [ $ROOT -eq 0 ] ; then
	if [ ! -e "$BIN" ] || [[ "$*" =~ --force ]] ; then
		echo "Copying $PWD/cyc.pl to $BIN..."
		cp cyc.pl $BIN
	else
		echo "You already have $BIN on your system."
	fi
else
	mkdir -p "$HOME/bin"
	if [ ! -e $HOMEBIN ] || [[ "$*" =~ --force ]] ; then
		echo "Copying $PWD/cyc.pl to $HOMEBIN..."
		cp cyc.pl $HOMEBIN
	else
		echo "You already have $HOMEBIN on your system."
	fi
	HOME_BIN=`which cyc 2>/dev/null`
	if [[ "$HOME_BIN" =~ $HOME/bin/cyc ]] ; then
		echo "PATH variable is set correctly."
	else
		NEW_PATH='PATH=$HOME/bin:$PATH ; export PATH'
		echo "Adding $HOME/bin to PATH..."
		echo "$NEW_PATH" >> "$HOME/.bashrc"
		echo "You need to restart the shell in order to make it working."
	fi
fi

exit 0
	
