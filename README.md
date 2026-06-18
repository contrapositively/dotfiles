### `setup.sh`
`setup.sh` is meant to be run from an Arch install ISO.
It installs the repository onto the mounted drive, after creating a sudo user.
All scripts require internet connection.

## Directories
`bootstrap` contains scripts that initialize various functionalities, detailed below.

`homefiles` contains files, and the `scripts/homefile` script connects `% -> ~/.%`.

`config` contains directories containing packages, and the `scripts/config` script connects `% -> ~/.config`.

`scripts` contains bash scripts, and the `bootstrap/scripts.sh` script connects `% -> ~/.local/bin/%`.

`file_templates` contains templates for files, and the `scripts/template` script connects `%.& -> ./&`.

## Bootstrapping
Run `bootstrap/homefiles.sh` and `bootstrap/scripts.sh` first, other scripts may depend on them.

`bootstrap/homefiles.sh` sets up `~/.bashrc`, `~/.bash_aliases`, and `~/.bashrc_dotfiles`.
`~/.bashrc_dotfiles` contains environment variables used by scripts.

`bootstrap/scripts.sh` links scripts to `~/.local/bin/`.

`bootstrap/audio.sh` installs `pulse`, `pipewire`, and loads default configs for them.

`bootstrap/desktop.sh` installs `i3`(window manager), `picom`(ricing), `konsole`(terminal), `polybar`(status), `pavucontrol`(audio control), `firefox`, `rofi`(app selector) and loads default configs for them.

`bootstrap/devtools.sh` installs `neovim`, language servers, and some other tools, and loads default configs for them.

`bootstrap/drivers.sh` installs graphics drivers for nvidia, amd, or intel.

`bootstrap/gaming.sh` installs `steam` and `Spotify`.

`bootstrap/wifi.sh` connects to wifi using `networkmanager`, which should be installed already.
