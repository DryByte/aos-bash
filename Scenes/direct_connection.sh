
function show_direct() {
	printf "Type server ip: "
	read server_ip

	clear
	echo "Select client for launch:"
	select client in Classic BetterSpades OpenSpades Cancel
	do
		case $client in
			"Classic")
				aos_path=`cat ./configs.json | jq ".Classic.path"`
				aos_prefix=`cat ./configs.json | jq ".Classic.wine_prefix"`

				eval WINEPREFIX=${aos_prefix} wine "${aos_path}/client.exe" "-${server_ip}"
				break
				;;

			"BetterSpades")
				bs_path=`cat ./configs.json | jq ".BetterSpades.path"`

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
				eval openspades ${server_ip}
				break
				;;
			"Cancel")
				show_main_menu
				break
				;;

			*) echo "Invalid option.";;
		esac
	done

	show_main_menu
}