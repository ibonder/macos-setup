#!/bin/bash
#
# Bootstrap a fresh macOS install from this repo.
#
# Safe to re-run: every step checks for its own result first, so a second run
# is a no-op rather than an error. Nothing here overwrites an existing config
# without first moving it aside into a timestamped backup directory.
#
#   ./setup_mac.sh             # do everything
#   DRY_RUN=1 ./setup_mac.sh   # print what would happen, change nothing
#   FORCE=1 ./setup_mac.sh     # also replace configs that already exist
#
# By default an existing config is never replaced. The tracked copies are
# anonymised, so overwriting a working ~/.gitconfig would swap real values for
# xxx placeholders — which makes the plain run safe on a machine already set
# up. FORCE=1 opts into replacing them (the old file is backed up first).
#
# It does NOT place secrets. Six of the tracked configs carry xxx/XXX
# placeholders (see the table in README.md); the script prints exactly which
# ones still need editing when it finishes.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
DRY_RUN="${DRY_RUN:-0}"
FORCE="${FORCE:-0}"

# Real, un-anonymised configs go here — outside the repo, so there is no way to
# git-commit them by accident. Any file present overrides the tracked copy of
# the same name. Private keys do NOT belong here: they live in 1Password and are
# served by its SSH agent. See README.md, "SSH keys and secrets".
PRIVATE="${PRIVATE_DIR:-$HOME/.config/macos-setup/private}"

# The overlay can also override settings the repo has to anonymise — notably a
# directory name, which a filename-based overlay cannot express on its own.
# Drop a `setup.conf` in the overlay with e.g. COMPANY_DIR=acme to have the env
# file land in ~/.config/acme/env instead of ~/.config/company/env.
# shellcheck source=/dev/null
[ -f "$PRIVATE/setup.conf" ] && . "$PRIVATE/setup.conf"
COMPANY_DIR="${COMPANY_DIR:-company}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*" >&2; }
skip() { printf '    already done: %s\n' "$*"; }

# Runs a command, or just prints it under DRY_RUN. Takes real argv, not a
# string, so paths with spaces survive and no eval is involved.
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '    [dry-run] %s\n' "$*"
  else
    "$@"
  fi
}

# --------------------------------------------------------------------------
# Preflight
# --------------------------------------------------------------------------
[ "$(uname -s)" = "Darwin" ] || { warn "macOS only"; exit 1; }
[ "$(id -u)" -ne 0 ] || { warn "do not run as root; it will sudo when needed"; exit 1; }

log "Setting up from $REPO"
[ "$DRY_RUN" = 1 ] && warn "DRY RUN — nothing will be changed"

# Xcode command line tools; everything below needs git and a compiler.
if xcode-select -p >/dev/null 2>&1; then
  skip "xcode command line tools"
else
  log "Installing Xcode command line tools — accept the GUI prompt, then re-run"
  run xcode-select --install
  exit 0
fi

# Rosetta 2, Apple Silicon only. oahd is its daemon, so it doubles as the check.
if [ "$(uname -m)" = "arm64" ]; then
  if /usr/bin/pgrep -q oahd; then
    skip "rosetta 2"
  else
    log "Installing Rosetta 2"
    run sudo softwareupdate --install-rosetta --agree-to-license
  fi
fi

# --------------------------------------------------------------------------
# Homebrew
# --------------------------------------------------------------------------
if command -v brew >/dev/null 2>&1; then
  skip "homebrew"
elif [ "$DRY_RUN" = 1 ]; then
  printf '    [dry-run] install homebrew\n'
else
  log "Installing Homebrew"
  # NONINTERACTIVE stops it waiting on a RETURN it will never get.
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# The Brewfile stays in this repo. Copying it to ~ is how the two drifted apart.
# --no-upgrade keeps this from fighting apps that update themselves.
log "Installing Brewfile packages (this takes a while)"
run brew bundle install --file="$REPO/Brewfile" --no-upgrade

# --------------------------------------------------------------------------
# Zsh
# --------------------------------------------------------------------------
if [ -d "$HOME/.oh-my-zsh" ]; then
  skip "oh-my-zsh"
elif [ "$DRY_RUN" = 1 ]; then
  printf '    [dry-run] install oh-my-zsh\n'
else
  log "Installing oh-my-zsh"
  # Without RUNZSH=no it execs a login zsh and everything below never runs.
  # KEEP_ZSHRC stops it clobbering the .zshrc this repo installs.
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
fi

# Set by oh-my-zsh at runtime, so it is always empty in this bash script.
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_plugin() {
  local url=$1 dest="$ZSH_CUSTOM/plugins/$2"
  if [ -d "$dest" ]; then
    skip "zsh plugin $2"
  else
    log "Cloning zsh plugin $2"
    run git clone --depth 1 "$url" "$dest"
  fi
}
clone_plugin https://github.com/TamCore/autoupdate-oh-my-zsh-plugins autoupdate
clone_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
clone_plugin https://github.com/romkatv/zsh-defer zsh-defer

# --------------------------------------------------------------------------
# iTerm2 shell integration
# --------------------------------------------------------------------------
if [ -f "$HOME/.iterm2_shell_integration.zsh" ]; then
  skip "iterm2 shell integration"
else
  log "Installing iTerm2 shell integration"
  run curl -fsSL https://iterm2.com/shell_integration/zsh \
    -o "$HOME/.iterm2_shell_integration.zsh"
fi

# --------------------------------------------------------------------------
# Config files
# --------------------------------------------------------------------------
# Neovim is symlinked: it carries no placeholders, so repo edits go live.
# Everything else is copied, because the tracked copies are anonymised and
# symlinking them would put a literal xxx into the running config.
link_config() {
  local src="$REPO/$1" dest="$2"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    skip "$dest"
    return
  fi
  if [ -e "$dest" ]; then
    run mkdir -p "$BACKUP"
    run mv "$dest" "$BACKUP/"
    warn "backed up existing $dest"
  fi
  run mkdir -p "$(dirname "$dest")"
  log "Linking $dest"
  run ln -s "$src" "$dest"
}

copy_config() {
  local src="$REPO/$1" dest="$2" mode="${3:-644}" origin="repo"
  # A real file in the private overlay wins over the anonymised tracked one.
  if [ -f "$PRIVATE/$1" ]; then
    src="$PRIVATE/$1"
    origin="private"
  fi
  if [ ! -f "$src" ]; then
    warn "missing in repo: $1"
    return
  fi
  if [ -e "$dest" ]; then
    if cmp -s "$src" "$dest"; then
      skip "$dest"
      return
    fi
    # The repo copy is anonymised. Overwriting a config that already exists
    # would swap a working file for one full of xxx placeholders, so an
    # existing file is left alone unless FORCE=1 is set explicitly.
    if [ "$FORCE" != 1 ]; then
      warn "exists, left untouched: $dest  (FORCE=1 to replace with repo copy)"
      return
    fi
    run mkdir -p "$BACKUP"
    run cp "$dest" "$BACKUP/"
    warn "backed up existing $dest"
  fi
  run mkdir -p "$(dirname "$dest")"
  log "Installing $dest (from $origin)"
  run cp "$src" "$dest"
  run chmod "$mode" "$dest"
  if [ "$origin" = repo ] && grep -qE 'xxx|XXX|example\.com' "$src" 2>/dev/null; then
    warn "  ^ contains placeholders — see 'Filling in real values' in README.md"
  fi
}

link_config config_nvim        "$HOME/.config/nvim"
copy_config zshrc              "$HOME/.zshrc"
copy_config bash_aliases       "$HOME/.bash_aliases"
copy_config gitconfig          "$HOME/.gitconfig"
copy_config terraformrc        "$HOME/.terraformrc"
copy_config aws_config         "$HOME/.aws/config"
copy_config ssh_config         "$HOME/.ssh/config" 600
copy_config config_company/env "$HOME/.config/$COMPANY_DIR/env" 600

# SSH private keys are deliberately untracked — restore them yourself.
if [ -d "$HOME/.ssh" ]; then
  run chmod 700 "$HOME/.ssh"
fi

# --------------------------------------------------------------------------
# macOS defaults
# --------------------------------------------------------------------------
log "Tuning Dock auto-hide"
run defaults write com.apple.dock autohide -bool true
run defaults write com.apple.dock autohide-delay -float 0
run defaults write com.apple.dock autohide-time-modifier -float 0.5
if [ "$DRY_RUN" != 1 ]; then
  killall Dock 2>/dev/null || true
fi

# --------------------------------------------------------------------------
# What still needs a human
# --------------------------------------------------------------------------
echo
log "Bootstrap finished. Remaining manual steps:"
cat <<'EOF'

  1. SSH keys — turn on the 1Password agent:
       1Password > Settings > Developer > "Use the SSH agent"
     Store each key as an SSH Key item there. Private keys never touch disk;
     ~/.ssh/config already points at the agent socket. Verify with:
       ssh-add -l

  2. Secrets into the keychain (nothing lands in a dotfile or shell history):
       security add-generic-password -U -s company-ldap -a '<ldap-user>' -w
       security add-generic-password -U -s tf-registry  -a '<registry-host>' -w

  3. Sign in to the App Store, then re-run so the `mas` entries install.

  4. First `nvim` launch bootstraps lazy.nvim and the language servers.

EOF

if [ -d "$PRIVATE" ]; then
  log "Private overlay in use: $PRIVATE"
else
  cat <<EOF
  5. Configs with real values (AWS account IDs, hostnames, your name/email) are
     NOT in this public repo. Put real copies in

       $PRIVATE/

     using the same filenames as the repo — aws_config, gitconfig, ssh_config.
     Anything there overrides the anonymised copy on the next run. It sits
     outside the repo, so it cannot be committed by accident.
     Until then, fill the placeholders in by hand:
       grep -rn 'xxx\|XXX\|example\.com' ~/.zshrc ~/.gitconfig ~/.aws/config ~/.ssh/config

EOF
fi
