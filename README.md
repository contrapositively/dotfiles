### `setup.sh`
`setup.sh` is meant to be run from an Arch install ISO.
It installs the repository onto the mounted drive, after creating a sudo user.
All scripts require internet connection.

## Directories
`bootstrap` contains scripts that initialize various functionalities, detailed below.

`homefiles` contains files, and the `scripts/homefile` script connects `% -> ~/.%`.

`config` contains configuration packages, and the `scripts/config` script connects `% -> ~/.config`.

`scripts` contains bash scripts, and the `essential/scripts.sh` script connects `% -> ~/.local/bin/%`.

`file_templates` contains file templates, and the `scripts/template` script connects `%.& -> ./&`.

## Bootstrapping
### `essential/`
Run `essential/homefiles.sh` and `essential/scripts.sh` first, other scripts may depend on them.

`essential/homefiles.sh` sets up `~/.bashrc`, `~/.bash_aliases`, and `~/.bashrc_dotfiles`.
`~/.bashrc_dotfiles` contains environment variables used by scripts.

`essential/scripts.sh` links scripts to `~/.local/bin/`.

`essential/audio.sh` installs `pulse`, `pipewire`, and loads default configs for them.

`essential/desktop.sh` installs `i3`(window manager), `picom`(ricing), `konsole`(terminal), `polybar`(status), `cable`(audio control), `firefox`, `rofi`(app selector) and loads default configs for them.


`essential/drivers.sh` installs graphics drivers for nvidia, amd, or intel.

`essential/wifi.sh` connects to wifi using `networkmanager`, which should be installed already.

### `gaming/`
### `music/`
### `development/`
`development/neovim.sh` installs `neovim`, language servers, and some other tools, and loads default configs for them.

`development/github.sh` sets up a ssh key for GitHub access.
