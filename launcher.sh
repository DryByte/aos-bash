#!/bin/bash

# Bash Launcher for Ace of Spades Clients
# Made by sByte

source ./Scenes/serverlist.sh
source ./Scenes/installers.sh

source ./Animations/loading.sh
source ./Animations/refresh.sh

terminal_lines=$(tput lines)

select main_menu in "Server List" "Installers" "Config" "Quit"
do
	case $main_menu in
		"Server List")
			clear
			loading_anim &

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