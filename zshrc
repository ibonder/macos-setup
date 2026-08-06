# ~/.zshrc — see github.com/ibonder/macos-setup for the tracked copy and notes.
#
# NOTE: no manual `compinit`/`bashcompinit` anywhere in this file — oh-my-zsh runs
# both. Calling them again doubles compinit and compdump (~185ms for nothing).

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""              # empty: the pure prompt is set up further down
export UPDATE_ZSH_DAYS=7  # used by the autoupdate plugin
export ANSIBLE_COW_SELECTION="random"

# Staged startup: `zsh-defer <cmd>` queues <cmd> to run once zle goes idle —
# after the prompt is on screen, but before your first command executes. Takes
# <1ms to load. See the deferred block at the bottom for what is moved off the
# critical path.
#
# Self-installing, so a fresh machine needs no manual step; once cloned, the
# autoupdate plugin keeps it current like any other $ZSH_CUSTOM plugin.
# If the clone can't happen (offline, no git), the fallback below runs the
# deferred commands immediately instead — slower startup, but nothing is lost.
# Without that fallback a missing zsh-defer would silently drop syntax
# highlighting, autosuggestions, fzf and the credential exports.
_zsh_defer_dir=$ZSH/custom/plugins/zsh-defer
if [[ ! -f $_zsh_defer_dir/zsh-defer.plugin.zsh ]]; then
  command git clone --depth 1 -q https://github.com/romkatv/zsh-defer.git \
    $_zsh_defer_dir 2>/dev/null
fi
if [[ -f $_zsh_defer_dir/zsh-defer.plugin.zsh ]]; then
  source $_zsh_defer_dir/zsh-defer.plugin.zsh
else
  print -u2 "zsh-defer missing and clone failed; loading everything eagerly"
  # Same call signature as the real thing: zsh-defer [{+|-}flags] [-t delay] cmd...
  # or -c 'list'. Options are parsed and discarded, then the command runs now.
  zsh-defer() {
    local as_list=0
    while (( $# )); do
      case $1 in
        -c) as_list=1; shift; break ;;
        -t) shift 2 ;;
        [-+]*) shift ;;
        *) break ;;
      esac
    done
    if (( as_list )); then eval "$*"; else "$@"; fi
  }
fi
unset _zsh_defer_dir

# Skip oh-my-zsh's compaudit/compfix pass over every completion directory.
# Saves ~10-20ms; the tradeoff is no warning about world-writable comp dirs.
ZSH_DISABLE_COMPFIX=true

# --- history ---------------------------------------------------------------
# 200k entries ~= 12MB and years of history. Measured: startup time is flat from
# 3k to 1M entries, so this is a capacity choice, not a performance one.
HISTSIZE=200000
SAVEHIST=$HISTSIZE
# oh-my-zsh already sets: extended_history, hist_expire_dups_first,
# hist_ignore_dups, hist_ignore_space, hist_verify, share_history.
setopt hist_reduce_blanks  # tidy up whitespace before recording
setopt hist_save_no_dups   # never write a duplicate to the history file
setopt hist_find_no_dups   # don't show a match twice while searching

# Dropped because their binary isn't installed, so the plugin did nothing:
# git-flow, docker-compose, fasd, and colorize (needs pygmentize or chroma).
plugins=(
  asdf
  git
  brew
  common-aliases
  node
  kubectl
  sudo
  colored-man-pages
  cp
  macos
  docker
  history
  npm
  helm
  terraform
  aws
)
# zsh-autosuggestions is NOT listed above — it is deferred at the bottom of this
# file, since it only matters once you start typing.

# common-aliases' global alias `P` (pipe to pygmentize) expands the bare `P`
# arg in omz_urlencode's zparseopts, breaking it when re-sourcing this file.
unalias 'P' 2>/dev/null  # quoted: an unquoted P would itself be alias-expanded

# oh-my-zsh always calls a full `compinit`, whose fpath scan costs ~20ms. A
# function defined here survives its `autoload -U compinit`, so we can add -C
# (trust the cached dump, skip the scan) whenever the dump is under a day old.
# Cost: a completion installed today isn't picked up until the dump ages out —
# run `rm ~/.zcompdump*` to force a rebuild immediately.
compinit() {
  unfunction compinit
  autoload -Uz compinit
  zmodload zsh/datetime
  zmodload -F zsh/stat b:zstat
  local -a s
  if zstat -A s +mtime "$ZSH_COMPDUMP" 2>/dev/null && (( EPOCHSECONDS - s[1] < 86400 )); then
    compinit -C "$@"
  else
    compinit "$@"
  fi
}

source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES  # needed for Ansible to work

# --- prompt ----------------------------------------------------------------
fpath+=$HOME/.zsh/pure
autoload -Uz promptinit
promptinit
prompt pure

typeset -U fpath      # Optinal for oh-my-zsh users
typeset -U path PATH  # keep PATH free of duplicates as it gets prepended below
fpath=(~/.zsh/oc $fpath)

# `eval "$(tool ...)"` forks the tool at every startup just to get static shell
# code back. Cache it instead, and regenerate only when the binary is newer than
# the cache (i.e. after a brew upgrade).
_cached_eval() {
  local name=$1 bin=$2; shift 2
  local cache="${ZSH_CACHE_DIR:-$ZSH/cache}/$name.zsh"
  if [[ ! -s $cache || $commands[$bin] -nt $cache ]]; then
    "$@" >| $cache 2>/dev/null || { command rm -f $cache; return 1 }
  fi
  source $cache
}

# NOTE: no `source <(kubectl completion zsh)` — the oh-my-zsh kubectl plugin already
# generates it once into $ZSH_CACHE_DIR/completions/_kubectl, asynchronously.

# --- terragrunt ------------------------------------------------------------
export TG_DEPENDENCY_FETCH_OUTPUT_FROM_STATE=true
export TG_TF_FORWARD_STDOUT=true
export TG_PROVIDER_CACHE=1
export TG_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugins-cache"
# TERRAGRUNT_* are the pre-0.69 names; kept for repos pinned to older versions.
export TERRAGRUNT_DEPENDENCY_FETCH_OUTPUT_FROM_STATE=true
export TERRAGRUNT_TF_FORWARD_STDOUT=true
export TERRAGRUNT_PROVIDER_CACHE=1
export TERRAGRUNT_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugins-cache"

# If Docker can't reach the daemon socket, colima needs this:
# export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# --- PATH ------------------------------------------------------------------
# Later entries win. /opt/homebrew/bin needs no line here: /etc/paths.d/homebrew
# already puts it on PATH for every shell.
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
# Appended, not prepended: go-installed tools must not shadow brew/asdf ones.
# Literal path instead of $(go env GOPATH), which forked go on every startup.
export PATH="$PATH:${GOPATH:-$HOME/go}/bin"

# nono sandbox for Claude Code (added 2026-07-13)
alias claude='nono run --profile claude-k8s -- claude'

# --- deferred ---------------------------------------------------------------
# Everything below is off the critical path to the prompt. zsh-defer runs these
# in queue order once zle is idle, which is after the prompt renders but before
# your first command runs. Aliases, PATH and the prompt stay eager above,
# because those you can need the instant the prompt appears.
#
# Deferred commands run in function scope with LOCAL_OPTIONS, and their output
# goes to /dev/null unless asked otherwise. Each entry below was checked against
# that: none has a top-level `setopt`, and syntax-highlighting's non-global
# `zsh_highlight__aliases` is set and consumed within one sourcing, so function
# scope is exactly its lifetime.

zsh-defer _cached_eval jump-init jump jump shell
zsh-defer -c 'complete -o nospace -C /opt/homebrew/bin/terraform terraform'
[[ -f ${HOME}/.iterm2_shell_integration.zsh ]] &&
  zsh-defer source "${HOME}/.iterm2_shell_integration.zsh"

# LDAP/SSO creds -> TF_VAR_ldap_*, CONFLUENCE_*, plus the Terraform registry
# token -> TF_TOKEN_<host> (added 2026-08-03, registry token moved here
# 2026-08-06 — it used to be awk'd out of ~/.terraformrc, one fork and one
# plaintext secret ago).
# +2 keeps stderr, so the "keychain item not found" hint is still visible.
[[ -f ~/.config/company/env ]] && zsh-defer +2 source ~/.config/company/env

# The autoupdate plugin runs `find -L $ZSH_CUSTOM -maxdepth 3 -name .git` at
# every startup, ~25ms of filesystem work that nothing interactive waits on.
zsh-defer source $ZSH/custom/plugins/autoupdate/autoupdate.plugin.zsh

# Order matters: fzf defines widgets, autosuggestions wraps widgets, and
# syntax-highlighting must wrap everything defined before it — so it goes last.
zsh-defer _cached_eval fzf-init fzf fzf --zsh
zsh-defer source $ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
