# Abyss Shell

Abyss Shell is a Quickshell-based shell interface for [Abyss](https://github.com/marc24force/abyss), designed for keyboard-driven workflows. To take full advantage of its features, a Window Manager is recommended. Currently, only [Niri](https://github.com/niri-wm/niri) is officially supported.

Abyss Shell communicates with Abyss via Quickshell IPC. Use `qs ipc show` to explore available operations.

---

## Installation

Abyss Shell can be installed either **system-wide** or **per user**, depending on your privileges and needs. For multi-user setups, a system installation is recommended.

### Using the Install Script

A ready-to-use `install.sh` script is provided. It handles cloning the repository, setting up directories, and creating necessary executables.

**Recommended usage:**

```bash
wget https://raw.githubusercontent.com/marc24force/abyss-shell/main/install.sh
./install.sh --system   # For system-wide installation
./install.sh --user     # For user-only installation
```

* The script will **abort if an existing installation is detected** in any of the following locations:

  * `/usr/local/share/abyss/abyss-shell`
  * `/usr/share/abyss/abyss-shell`
  * `$HOME/.local/share/abyss/abyss-shell`

### Manual Installation

For advanced users or custom setups, you can install manually:

**System-wide:**

```bash
export LOCAL_DIR=/usr/local
```

**User-only:**

```bash
export LOCAL_DIR=$HOME/.local
```

Then:

```bash
export ABYSS_DIR=${LOCAL_DIR}/share/abyss
mkdir -p ${ABYSS_DIR}
git clone https://github.com/marc24force/abyss-shell.git ${ABYSS_DIR}/abyss-shell
echo "qs -p ${ABYSS_DIR}" > ${LOCAL_DIR}/bin/abyss-shell
chmod +x ${LOCAL_DIR}/bin/abyss-shell
```

* Ensure `${LOCAL_DIR}/bin` is in your `$PATH` if installing as a user.

---

### Void Packages

TBD – System installation only.

---

## Updating Abyss Shell

Use the provided `abyss-update` command:

```bash
abyss-update
```

It safely pulls the latest changes from the repository and updates your installation. It works for both user and system installs.

---

## Themes

Abyss Shell comes with several default themes. Current active theme is stored in a `theme.json` file, located by default at:

```
${XDG_CONFIG_HOME}/abyss/theme.json
```

* This file can be edited manually or via the Theme menu.
* When setting a Theme or background image via IPC, paths (unless absolute) are searched in the following hierarchical order:

```
~/.local/share/abyss/themes/
 /usr/local/share/abyss/themes/
 /usr/share/abyss/themes/
 ${ABYSS_DIR}/abyss-shell/assets/themes/
```

---

## Features

### Bar

* [x] Clock
* [ ] Workspaces
* [ ] System tray
* [ ] Screen brightness
* [ ] Volume and audio source
* [ ] Network and VPN
* [ ] Bluetooth
* [ ] Microphone and camera
* [ ] Battery

### Pop-ups

* [ ] OS information
* [ ] Hardware information
* [ ] Services
* [ ] Calendar
* [ ] Chronometer
* [ ] Screen brightness
* [ ] Volume
* [ ] Network information
* [ ] Keyboard layout help
* [ ] Key-bindings help

### Menus

* [ ] Power menu
* [ ] Quick commands
* [ ] Apps menu
* [ ] Clipboard
* [ ] Theme menu

