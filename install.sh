#!/usr/bin/env bash
set -e

# Default to showing help
SHOW_HELP=false
INSTALL_TYPE="user"
REMOVE=false

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
  --user         Install for the current user (default)
  --system       Install system-wide
  --remove       Remove the selected installation
  --help         Show this help message
EOF
}

# Parse command line
if [ $# -eq 0 ]; then
    SHOW_HELP=true
fi

for arg in "$@"; do
    case $arg in
        --system)
        INSTALL_TYPE="system"
        ;;
        --user)
        INSTALL_TYPE="user"
        ;;
        --remove)
        REMOVE=true
        ;;
        --help)
        SHOW_HELP=true
        ;;
        *)
        echo "Unknown option: $arg"
        usage
        exit 1
        ;;
    esac
done

if [ "$SHOW_HELP" = true ]; then
    usage
    exit 0
fi

# Directories
if [ "$INSTALL_TYPE" = "system" ]; then
    LOCAL_DIR="/usr/local"
    BIN_DIR="$LOCAL_DIR/bin"
    SHARE_DIR="$LOCAL_DIR/share/abyss"
    SUDO_CMD="sudo"
else
    LOCAL_DIR="$HOME/.local"
    BIN_DIR="$LOCAL_DIR/bin"
    SHARE_DIR="$LOCAL_DIR/share/abyss"
    SUDO_CMD=""
fi

REPO_DIR="$SHARE_DIR/abyss-shell"

remove_install() {
    echo "Removing Abyss Shell from $REPO_DIR..."
    $SUDO_CMD rm -rf "$REPO_DIR"
    $SUDO_CMD rm -f "$BIN_DIR/abyss-shell" "$BIN_DIR/abyss-update"
    echo "Removal complete."
    exit 0
}

if [ "$REMOVE" = true ]; then
    remove_install
fi

# Check for existing installation
SYSTEM_LOCAL="/usr/local/share/abyss/abyss-shell"
SYSTEM_SHARE="/usr/share/abyss/abyss-shell"
USER_LOCAL="$HOME/.local/share/abyss/abyss-shell"

if [ -d "$SYSTEM_LOCAL" ] || [ -d "$SYSTEM_SHARE" ] || [ -d "$USER_LOCAL" ]; then
    echo "Abyss-shell already exists in:"
    [ -d "$SYSTEM_LOCAL" ] && echo "  - /usr/local/share/abyss/abyss-shell"
    [ -d "$SYSTEM_SHARE" ] && echo "  - /usr/share/abyss/abyss-shell"
    [ -d "$USER_LOCAL" ] && echo "  - $USER_LOCAL"
    echo "Aborting installation to avoid conflicts."
    exit 1
fi

# Create directories
$SUDO_CMD mkdir -p "$REPO_DIR"
$SUDO_CMD mkdir -p "$BIN_DIR"

# Clone repository
echo "Cloning abyss-shell into $REPO_DIR..."
$SUDO_CMD git clone https://github.com/marc24force/abyss-shell.git "$REPO_DIR"

# Create executable wrapper
echo "qs -p $SHARE_DIR/abyss-shell" | $SUDO_CMD tee "$BIN_DIR/abyss-shell" > /dev/null
$SUDO_CMD chmod +x "$BIN_DIR/abyss-shell"

# Create update script
UPDATE_FILE="$BIN_DIR/abyss-update"
cat << 'EOF' | $SUDO_CMD tee "$UPDATE_FILE" > /dev/null
#!/usr/bin/env bash
set -e

SYSTEM_LOCAL="/usr/local/share/abyss/abyss-shell"
USER_LOCAL="$HOME/.local/share/abyss/abyss-shell"

if [ -d "$SYSTEM_LOCAL" ]; then
    REPO="$SYSTEM_LOCAL"
    UPDATE_CMD="sudo git -C \"$REPO\" pull --rebase"
elif [ -d "$USER_LOCAL" ]; then
    REPO="$USER_LOCAL"
    UPDATE_CMD="git -C \"$REPO\" pull --rebase"
else
    echo "Abyss-shell not found."
    exit 1
fi

echo "Updating Abyss Shell at $REPO..."
eval $UPDATE_CMD
echo "Update complete!"
EOF

$SUDO_CMD chmod +x "$UPDATE_FILE"

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    echo
    echo "WARNING: $BIN_DIR is not in your PATH."
    echo "Add it by adding the following to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
    echo "Then reload your shell or run 'source ~/.bashrc'."
    echo
fi

echo "Installation complete!"
