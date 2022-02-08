#!/bin/bash

# Bash Launcher for Ace of Spades Clients
# Made by sByte

source ./Scenes/serverlist.sh
source ./Scenes/installers.sh

terminal_lines=$(tput lines)

select main_menu in "Server List" "Installers" "Config" "Quit"
do
	case $main_menu in
		"Server List")
			clear
			echo "Loading server list... (~_~;)"

			load_list
			show_list
			;;
		"Installers")
			clear
			show_installers
			;;
		"Config")
			echo "WIP"
			;;
		"Quit")
			break
			;;
	esac
done