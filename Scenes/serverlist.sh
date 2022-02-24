server_length=0
jsonFile="{}"

escape_char=$(printf "\u1b")
selected_index=0
servers=()

function update_list() {
	servers=()
	jsonFile=`curl http://services.buildandshoot.com/serverlist.json | jq "sort_by(.players_current)|reverse"`
	server_length=`curl http://services.buildandshoot.com/serverlist.json | jq length`
}

function display_list() {
	clear
	for (( i = selected_index; i<=server_length; i++ )); do
		if [[ $i -lt $(($terminal_lines-5+selected_index)) ]]; then
			color="\e[0m"
			if [[ $selected_index == $i ]]; then
				color="\e[0;41m"
			fi
			echo -e "${color}${servers[$i]} \e[0m"
		fi
	done
}

function display_instructions() {
	echo ""
	echo -e "Use \e[0;31m⬆/⬇ \e[0mto go up or down in the list."
	echo -e "Press \e[0;31mEnter \e[0mto select the server."
	echo -e "Press \e[0;31mR \e[0mto refresh."
}

function load_list() {
	update_list

	server_length=$((server_length-1))
	for ((i=0; i<=server_length; i++))
	do
		selected_server=`echo ${jsonFile} | jq ".[${i}]"`

		name=`echo ${selected_server} | jq ".name"`
		player_current=`echo ${selected_server} | jq ".players_current"`
		player_max=`echo ${selected_server} | jq ".players_max"`
		map=`echo ${selected_server} | jq ".map"`
		game_mode=`echo ${selected_server} | jq ".game_mode"`

		# Format the whitespaces for looking nice
		if [[ player_current -lt 10 ]]; then
			player_current="0${player_current}"
		fi
		if [[ player_max -lt 10 ]]; then
			player_max="0${player_max}"
		fi

		if [[ ${#game_mode} -lt 9 ]]; then
			for (( g=${#game_mode}; g < 9; g++ )); do

				if [[ $(($g%2)) -eq 0 ]]; then
					game_mode="$game_mode "
				else
					game_mode=" $game_mode"
				fi

			done
		fi

		if [[ ${#map} -lt 22 ]]; then
			for (( g=${#map}; g < 22; g++ )); do

				if [[ $(($g%2)) -eq 0 ]]; then
					map="$map "
				else
					map=" $map"
				fi

			done
		fi

		servers+=("${player_current}/${player_max} │ ${game_mode} │ ${map} │ ${name}")
	done
}

function display_connect_info() {
	clear

	selected_server=`echo ${jsonFile} | jq ".[${selected_index}]"`
	name=`echo ${selected_server} | jq ".name"`
	map=`echo ${selected_server} | jq ".map"`
	game_mode=`echo ${selected_server} | jq ".game_mode"`
	server_ip=`echo ${selected_server} | jq ".identifier"`

	echo "┌──[ CONNECTING ]"
	echo "├─[${name}"
	echo "├─[${map}"
	echo "├─[${game_mode}"
	echo "├─[${server_ip}"
	echo "└──[ CONNECTING ]"
}

function show_list {
	while true
	do
		# stop animations or any other job
		if [[ $(jobs) ]]; then
			kill %1
		fi

		display_list
		display_instructions
		read -rsn1 inputo
		if [[ $inputo == $escape_char ]]; then
		    read -rsn2 inputo
		fi

		case $inputo in
			"")
				clear
				server_ip=`echo ${jsonFile} | jq ".[${selected_index}].identifier"`

				echo "Select client for launch:"
				select client in Classic BetterSpades OpenSpades Cancel
				do
					case $client in
						"Classic")
							aos_path=`cat ./configs.json | jq ".Classic.path"`
							aos_prefix=`cat ./configs.json | jq ".Classic.wine_prefix"`
							display_connect_info

							eval WINEPREFIX=${aos_prefix} wine "${aos_path}/client.exe" "-${server_ip}"
							break
							;;

						"BetterSpades")
							bs_path=`cat ./configs.json | jq ".BetterSpades.path"`
							display_connect_info

							# Parse the path for use "cd" without errors
							bs_path="${bs_path/"\$HOME"/"$HOME"}"
							bs_path="${bs_path%\"}"
							bs_path="${bs_path#\"}"

							cd "$bs_path" && ./client "-${server_ip}"
							if [[ $? -ne 0 ]]; then
								exit
							fi
							break
							;;
						"OpenSpades")
							display_connect_info

							eval openspades ${server_ip}
							break
							;;
						"Cancel")
							break
							;;

						*) echo "Invalid option.";;
					esac
				done
				;;

			"[B")
				((selected_index++))
				if [[ $selected_index -gt $server_length ]]; then
					selected_index=0
				fi
				;;

			"[A")
				((selected_index--))
				if [[ $selected_index -lt 0 ]]; then
					selected_index=$((server_length))
				fi
				;;

			"r" | "R")
				clear
				refresh_anim &
				load_list
				;;

			*);;
		esac
	done
}
