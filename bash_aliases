# shellcheck shell=bash

awsp () {
    export AWS_PROFILE=$(grep -E '^\[profile ' ~/.aws/config | cut -d' ' -f2 | tr -d ']' | fzf)
}

awsr () {
  local regions="eu-south-1 eu-central-1"
  export AWS_REGION=$(echo "$regions" | tr ' ' '\n' | fzf)
}

awsc () {
  aws ecr get-login-password --region eu-central-1 | helm registry login --username AWS --password-stdin xxxxxxxxxxxx.dkr.ecr.eu-central-1.amazonaws.com
}

alias rm="rm -v"
alias mv="mv -v"
alias t="terraform"
alias tg="terragrunt --terragrunt-forward-tf-stdout"
alias ll="ls -l -h"
alias la="ls -A"
alias lah="ls -lah"
alias g="git"
alias vim="nvim"
alias jj="process_fzf"
alias zshrc="vim ~/.zshrc"

bash_aliases="$HOME/.bash_aliases"
vimrc="$HOME/.vimrc"
zshrc="$HOME/.zshrc"
alias vimba="nvim \$bash_aliases"
alias vimrc="nvim \$vimrc"
alias vimzrc="nvim \$zshrc"
alias - -='cd -'
alias cat="bat -pp"

function process_fzf() {
  local dest
  dest=$(fd "$@" | fzf -q "$*")
  if [ -d "$dest" ]; then
    cd "$dest" || return
  elif [ -f "$dest" ]; then
    nvim "$dest"
  else
    echo "nothing found :("
  fi

}

alias sss="aws ssm start-session --document-name AWS-StartInteractiveCommand --parameters \"command=[\"/bin/bash\"]\" --target"
alias sts="aws ssm terminate-session --session-id"

alias co="git co"
alias co-="git co -"
alias master="git co master"
alias hd="hexdump -c"
alias bup="brew update && brew upgrade && brew upgrade --cask --greedy"

# short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace) 
function kx() {
  if [ "$1" ]; then
    kubectl config use-context "$1"
  else
    kubectl config current-context
  fi
}
function kn() {
  if [ "$1" ]; then
    kubectl config set-context --current --namespace "$1"
  else
    kubectl config view --minify | grep namespace | cut -d" " -f6
  fi
}

alias chrome="open -a 'Google Chrome'"

alias kgno='kubectl get nodes -L topology.kubernetes.io/zone'
alias ksc='kubectl config use-context'

alias netoff='networksetup -setairportpower en0 off'
alias neton='networksetup -setairportpower en0 on'
alias netrestart='networksetup -setairportpower en0 off && networksetup -setairportpower en0 on'

alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'
