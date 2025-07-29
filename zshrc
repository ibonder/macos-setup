# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

autoload -Uz compinit
compinit

# Path to your oh-my-zsh installation.
export ZSH="/Users/ibondarev/.oh-my-zsh"
export ANSIBLE_COW_SELECTION="random"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

HISTSIZE=1000000
HISTFILESIZE=1000000
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
  node
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

autoload -U bashcompinit
bashcompinit

typeset -U fpath  # Optinal for oh-my-zsh users
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

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
PATH="/opt/homebrew/bin:$PATH"

eval $(thefuck --alias)

awsp () {
    export AWS_PROFILE=$(cat ~/.aws/credentials | grep '^\[' | tr -d '\[' | tr -d '\]' | fzf)
}

awsr () {
  local regions="us-east-1 eu-central-1 eu-west-1"
  export AWS_REGION=$(echo "$regions" | tr ' ' '\n' | fzf)
}

function fasd_cd_fzf() {
  local cd_paths=$(echo "$*" | xargs fasd -ldR)
  local cd_path=$(echo "$cd_paths" | fzf --reverse -0 -1 -q "$*")
  if [ -d "$cd_path" ]; then
    cd "$cd_path"
  else
    cd $(fd -t=d . ~ | fzf --reverse -0 -1 -q "$*")
  fi
}

alias j=fasd_cd_fzf


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# source <(kubectl completion zsh)
# [[ $commands[kubectl] ]] && source <(kubectl completion zsh)

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
# Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running? - FIX
export DOCKER_HOST="unix://${HOME}/.colima/default/docker.sock"

# Optimize Terragrunt plans
export TERRAGRUNT_FETCH_DEPENDENCY_OUTPUT_FROM_STATE=true
export TG_PROVIDER_CACHE_DIR="${HOME}/.terraform.d/plugins-cache"
export TG_PROVIDER_CACHE=1

source /opt/homebrew/Cellar/fzf/*/shell/key-bindings.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
