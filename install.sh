#!/usr/bin/env bash
set -e

# Default to user install
INSTALL_TYPE="user"

# Parse command line
for arg in "$@"; do
    case $arg in
        --system)
        INSTALL_TYPE="system"
        shift
        ;;
        --user)
        INSTALL_TYPE="user"
        shift
        ;;
        *)
        echo "Unknown option: $arg"
        exit 1
        ;;
    esac
done

# Determine directories based on install type
if [ "$INSTALL_TYPE" = "system" ]; then
    LOCAL_DIR="/usr/local"
    BIN_DIR="$LOCAL_DIR/bin"
    SHARE_DIR="$LOCAL_DIR/share"
    SUDO_CMD="sudo"
else
    LOCAL_DIR="$HOME/.local"
    BIN_DIR="$LOCAL_DIR/bin"
    SHARE_DIR="$LOCAL_DIR/share"
    SUDO_CMD=""
fi

ABYSS_DIR="$SHARE_DIR/abyss"

# Check if abyss-shell is already installed anywhere
SYSTEM_ABYSS_LOCAL="/usr/local/share/abyss/abyss-shell"
SYSTEM_ABYSS="/usr/share/abyss/abyss-shell"
USER_ABYSS="$HOME/.local/share/abyss/abyss-shell"

if [ -d "$SYSTEM_ABYSS_LOCAL" ] || [ -d "$SYSTEM_ABYSS" ] || [ -d "$USER_ABYSS" ]; then
    echo "Abyss-shell already exists in the following locations:"
    [ -d "$SYSTEM_ABYSS_LOCAL" ] && echo "  - /usr/local/share/abyss/abyss-shell"
    [ -d "$SYSTEM_ABYSS" ] && echo "  - /usr/share/abyss/abyss-shell"
    [ -d "$USER_ABYSS" ] && echo "  - $USER_ABYSS"
    echo "Aborting installation to avoid conflicts."
    exit 1
fi

# Create necessary directories
$SUDO_CMD mkdir -p "$ABYSS_DIR"
$SUDO_CMD mkdir -p "$BIN_DIR"

# Clone the repository
echo "Cloning abyss-shell into $ABYSS_DIR..."
$SUDO_CMD git clone https://github.com/marc24force/abyss-shell.git "$ABYSS_DIR/abyss-shell"

# Create the executable wrapper
EXEC_FILE="$BIN_DIR/abyss-shell"
echo "qs -p $ABYSS_DIR" | $SUDO_CMD tee "$EXEC_FILE" > /dev/null
$SUDO_CMD chmod +x "$EXEC_FILE"

# Create update script
UPDATE_FILE="$BIN_DIR/abyss-update"
cat << EOF | $SUDO_CMD tee "$UPDATE_FILE" > /dev/null
#!/usr/bin/env bash
set -e
if [ ! -d "$ABYSS_DIR/abyss-shell" ]; then
    echo "Abyss-shell not found at $ABYSS_DIR/abyss-shell"
    exit 1
fi
echo "Updating abyss-shell..."
cd "$ABYSS_DIR/abyss-shell"
git pull --rebase
echo "Update complete!"
EOF
$SUDO_CMD chmod +x "$UPDATE_FILE"

# Check if BIN_DIR is in PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
    echo
    echo "WARNING: $BIN_DIR is not in your PATH."
    echo "You won't be able to run 'abyss-shell' or 'abyss-update' directly."
    echo "Add it to your PATH by adding the following line to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
    echo "Then reload your shell or run 'source ~/.bashrc' (or equivalent)."
    echo
fi

echo "Installation complete!"
