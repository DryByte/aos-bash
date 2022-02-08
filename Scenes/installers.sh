source ./Installers/Classic.sh
source ./Installers/BetterSpades.sh
source ./Installers/OpenSpades.sh

function show_installers {
	select installers_opt in "Classic (With wine)" "BetterSpades" "OpenSpades"
	do
		case $installers_opt in
			"Classic (With wine)")
				classic_install_start
				;;
			"BetterSpades")
				bs_install_start
				;;
			"OpenSpades")
				os_install_start
				;;
		esac
	done
}