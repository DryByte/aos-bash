#!/bin/bash

# Bash Launcher for Ace of Spades Clients
# Made by sByte

source ./Scenes/serverlist.sh
source ./Scenes/installers.sh
source ./Scenes/direct_connection.sh

source ./Animations/loading.sh
source ./Animations/refresh.sh

terminal_lines=$(tput lines)

function show_main_menu() {
	clear
	select main_menu in "Server List" "Direct Connection" "Installers" "Config" "Quit"
	do
		case $main_menu in
			"Server List")
				clear
				loading_anim &

				load_list
				show_list
				;;
			"Direct Connection")
				clear
				show_direct
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
}
show_main_menu