function compile_libdeflate {
	git clone https://aur.archlinux.org/libdeflate.git && cd "./libdeflate"
	makepkg -si
	cd ..
	rm -rf "./libdeflate"
}

function bs_install_start {

	if [ -x "$(command -v apt-get)" ]; then
		sudo apt-get install git build-essential cmake libdeflate-dev libenet-dev libglew-dev libglfw3-dev
	elif [ -x "$(command -v pacman)" ]; then
		sudo pacman -S git gcc make cmake zlib enet glew glfw-x11

		if [[ ! -d ./libdeflate ]]; then
			compile_libdeflate
		fi
	else
		printf "Your package manager is not on the list, please install the following packages manually: 'git gcc make cmake deflate enet glew glfw3'\n"
		printf "If you want to add your package manager on the list, open an issue on github.\n"
		exit
	fi

	if [[ ! -d "./Clients" ]]; then
		mkdir ./Clients
	fi

	cd "./Clients"

	# Check if the repository is already cloned
	if [[ ! -d "./BetterSpades" ]]; then
		git clone https://github.com/xtreme8000/BetterSpades.git && cd "./BetterSpades/build"
	else
		cd "./BetterSpades/build"
	fi

	# Check if is already compiled
	if [[ ! -d "./BetterSpades" ]]; then
		cmake .. && make

		if [[ $? -ne 0 ]]; then
			exit
		fi
	fi

	t_path="$(pwd)/BetterSpades/"
	jq --arg path_wr "$t_path" '.BetterSpades.path=$path_wr' ../../../configs.json > ../../../tmp_config.json
	mv ../../../tmp_config.json ../../../configs.json

	clear
	echo "Installed! (^^ゞ"
	exit
}