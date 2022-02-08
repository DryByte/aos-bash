msi_link="http://www.spadille.net/aos075install.msi"

function download_msi {
	wget -O aos075.msi $msi_link
	if [[ $? -ne 0 ]]; then
		clear
	    echo "$msi_link looks offline, if you have an alternative URL, please go to ./Installers/Classic.sh, and change 'msi_link' variable, then try again."
	    exit 1; 
	fi
}

function install_aos {
	echo "Starting Ace of Spades installation..."
	wine msiexec /q /i ./aos075.msi
}

function classic_install_start {
	if [[ ! $(command -v wine) ]]; then
		printf 'Wine not found!\nPlease use your package manager to install.\n'
		exit
	fi

	download_msi
	install_aos

	jq '.Classic.path="$HOME/aos_wine/drive_c/Ace of Spades/"' ./configs.json > tmp_config.json
	jq '.Classic.wine_prefix="$HOME/aos_wine"' ./configs.json > tmp_config.json
	mv ./tmp_config.json ./configs.json
	rm ./aos075.msi

	clear
	echo "Installed! (^^ゞ"
	exit
}