# ARCHIVED
This project got archived because everything is going to be moved to a new project (https://github.com/DryByte/aos-launcher). Thank you :D

# Bash Launcher
## What's?
This is a launcher made using bash script, with this you are able to switch client faster and easy, also you have access for the server list using your terminal.

## Dependencies
- curl
- jq

## Usage
**``1.``** You will need to configure your client paths, go to **config.json** and change the settings for your client locations (If you dont have one of that clients, not need to change, just keep how thats by default)

```json
{
	"Classic": {
		"path": "$HOME/aos_wine/drive_c/Ace of Spades",
		"wine_prefix": "$HOME/aos_wine"
	},
	"BetterSpades": {
		"path": "$HOME/Desktop/BetterSpades/build/BetterSpades"
	}
}
```

OpenSpades client path not need to be added, but make sure OpenSpades are installed on your system.

**``2.``** Make sure you have the Dependencies installed.

- _On Debian/Ubuntu based distributions_
   ```
  sudo apt install curl jq
  ```
- _On Arch Linux based distributions_
    ```
  sudo pacman -S curl jq
  ```

**``3.``** Change the file permissions.
```
sudo chmod +x ./launcher.sh
```

**``4.``** Time to launch the script and use.
```
./launcher.sh
```

## Navigating
Use `Arrow Keys` for going up and down of the server list. Press enter on the selected server for joining on that, and select your client. Then client will start and connect automatically to the selected server.