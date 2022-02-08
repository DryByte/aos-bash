function os_install_start {
	# Check if already have an openspades version installed and ask if want to continue
	if [[ -d "/usr/local/share/games/openspades" ]]; then
		clear
		printf "Detected an openspades already installed on the system, you want to uninstall and procced with the installation?"
		read -p " [Y/n]: " -r
		echo 

		if [[ $REPLY =~ ^[Yy]$ ]]; then
			echo "Removing installed version..."
			sudo rm -rf "/usr/local/share/games/openspades"
			echo "Done! Starting to compile OpenSpades..."
			echo
		else
			echo "Cancelling installation."
			exit
		fi
	fi

	if [ -x "$(command -v apt-get)" ]; then
		sudo apt-get install git build-essential cmake pkg-config libglew-dev libcurl3-openssl-dev libsdl2-dev libsdl2-image-dev libalut-dev xdg-utils libfreetype6-dev libopus-dev libopusfile-dev imagemagick
	elif [ -x "$(command -v pacman)" ]; then
		sudo pacman -S git gcc make cmake glew curl sdl2 sdl2_image freealut xdg-utils opus opusfile imagemagick
	else
		printf "Your package manager is not on the list, please install the following packages manually: 'git gcc make cmake glew curl sdl2 sdl2_image freealut xdg-utils opus opusfile imagemagick'\n"
		printf "If you want to add your package manager on the list, open an issue on github.\n"
		exit
	fi

	if [[ ! -d "./Clients" ]]; then
		mkdir ./Clients
	fi

	cd "./Clients"

	# Check if the repository is already cloned
	if [[ ! -d "./openspades" ]]; then
		git clone https://github.com/yvt/openspades.git && cd "./openspades"
		mkdir openspades.mk && cd openspades.mk
	else
		cd "./openspades/openspades.mk"
	fi

	# Check if is already installed
	if [[ ! -d "/usr/local/share/games/openspades" ]]; then
		cmake .. && make
	
		if [[ $? -ne 0 ]]; then
			exit
		fi

		echo "Installing OpenSpades."
		sudo make install
	fi

	clear
	echo "Installed!! (^^ゞ"
	exit
}