# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# NOTE: no manual `compinit` here — oh-my-zsh runs it (oh-my-zsh.sh), and calling
# it twice costs ~185ms of startup for nothing.

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ANSIBLE_COW_SELECTION="random"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

HISTSIZE=1000000
SAVEHIST=$HISTSIZE

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  autoupdate
  git
  git-flow
  brew
  common-aliases
  node
  rand-quote
  kubectl
  sudo
  colored-man-pages
  cp
  macos
  docker
  docker-compose
  history
  npm
  helm
  terraform
  aws
  colorize
  # fzf
  zsh-autosuggestions
  # fzf-tab
  fasd
)

# common-aliases' global alias `P` (pipe to pygmentize) expands the bare `P`
# arg in omz_urlencode's zparseopts, breaking it when re-sourcing this file.
unalias 'P' 2>/dev/null  # quoted: an unquoted P would itself be alias-expanded

source $ZSH/oh-my-zsh.sh
source ~/.bash_aliases
# Used for correct Ansible work
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

fpath+=$HOME/.zsh/pure

autoload -Uz promptinit
promptinit
prompt pure

# NOTE: no manual `bashcompinit` — oh-my-zsh's lib/completion.zsh already runs it,
# so the `complete -C` call further down works without it.

typeset -U fpath  # Optinal for oh-my-zsh users
typeset -U path PATH  # keep PATH free of duplicates as it gets prepended below
fpath=(~/.zsh/oc $fpath)

# autoload -U compinit
# compinit -i

eval "$(jump shell)"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

complete -o nospace -C /opt/homebrew/bin/terraform terraform
PATH="/opt/homebrew/bin:$PATH"

eval $(thefuck --alias)

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NOTE: no `source <(kubectl completion zsh)` — the oh-my-zsh kubectl plugin already
# generates it once into $ZSH_CACHE_DIR/completions/_kubectl, asynchronously.
# source <(jj util completion zsh)

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running? - FIX
# export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# Optimize Terragrunt plans
export TG_DEPENDENCY_FETCH_OUTPUT_FROM_STATE=true
export TG_TF_FORWARD_STDOUT=true
export TG_PROVIDER_CACHE=1
export TG_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugins-cache"
# export TG_TF_DEFAULT_REGISTRY_HOST="artifactory.example.com"
# Support for older Terragrunt versions (0.68 in some repos)
export TERRAGRUNT_DEPENDENCY_FETCH_OUTPUT_FROM_STATE=true
export TERRAGRUNT_TF_FORWARD_STDOUT=true
export TERRAGRUNT_PROVIDER_CACHE=1
export TERRAGRUNT_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugins-cache"

# Key bindings + completion. Replaces sourcing /opt/homebrew/Cellar/fzf/*/shell/,
# whose version-numbered path silently breaks on every fzf upgrade.
eval "$(fzf --zsh)"

# Must stay last: zsh-syntax-highlighting has to wrap widgets defined above it.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Link Go binaries
export PATH="$PATH:$(go env GOPATH)/bin"

# Link ASDF shims
# https://asdf-vm.com/guide/getting-started.html#add-shims-directory-to-path-required-3
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Link PostgreSQL binaries
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# nono sandbox for Claude Code (added 2026-07-13)
alias claude='nono run --profile claude-k8s -- claude'

# Terraform module registry auth for git.example.com (added 2026-07-30)
# just init sets TF_CLI_CONFIG_FILE=network-mirror.tfrc, which ignores ~/.terraformrc;
# this env-var token is honored regardless of the active CLI config file.
export TF_TOKEN_git_example_com=$(awk '/credentials "git.example.com"/{f=1} f&&/token/{gsub(/.*= *"|"/,"");print;exit}' ~/.terraformrc 2>/dev/null)

# Company LDAP/SSO creds -> TF_VAR_ldap_*, CONFLUENCE_* (added 2026-08-03)
[[ -f ~/.config/company/env ]] && source ~/.config/company/env
