#!/bin/env zsh

# Download Znap, if it's not there yet.
[[ -r ~/.znap/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.znap/zsh-snap
        source ~/.znap/zsh-snap/znap.zsh  # Start Znap

HISTFILE="${HOME}"/.zsh_history
echo "${HISTFILE}"
if [ "${HOME}" != "${PWD}" ] && [ -f "${PWD}"/.zsh_history ]; then
	fc -R ${HISTFILE}
	HISTFILE="${PWD}"/.zsh_history
	echo "${HISTFILE}"
fi

if [ -f "${PWD}"/.zsh_history_tmp ]; then
	fc -R ${HISTFILE}
	HISTFILE="${PWD}"/.zsh_history_tmp
	echo "${HISTFILE}"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# put additional paths to fpath
if [ -d "${HOME}"/.local/share/zsh/site-functions ]; then
	fpath=("${HOME}"/.local/share/zsh/site-functions $fpath)
fi

# ========================== HELPER start =============================

# helper to check if command is available
isvalid() {
	command -v "$1" >/dev/null
}

# create local history files and start new shell instance
lhist() {
	test -f .zsh_history || touch .zsh_history
	test -f .zsh_history_tmp || touch .zsh_history_tmp
	exec zsh
}

# change dir and create new local shell
lcd() {
	cd "${1}" && exec ${SHELL}
}

# create folder inclusive parents and change to folder
mkcd() {
	mkdir -p "${1}" && cd "${1}" || exit
}

# change dir and new local shell
mklcd() {
	mkcd "${1}" && lhist
}

result() {
	local ERRORCODE=$?
	local MESSAGE=${*:-\=>}

	if [ $ERRORCODE = 0 ]; then
		echo -e "${MESSAGE} \e[32m\e[1msuccess\e[0m"
	else
		echo -e "${MESSAGE} \e[31m\e[1merror ${ERRORCODE}\e[0m"
	fi

	return $ERRORCODE
}

detach() {
	nohup "$@" 2>&1 >/dev/null &
}

# -------------------------- local HELPER -----------------------------

# helper to define alias, only if target command is available
lsalias() {
	typeset ALIAS=${1%=*}
	typeset VALUE=${1##*=}
	typeset EXA_CMD=${VALUE%%:*}
	typeset LS_CMD=${VALUE##*:}
	if isvalid "lsd"; then
		alias "${ALIAS}"="${EXA_CMD}"
	elif [ -n "${LS_CMD}" ]; then
		alias "${ALIAS}"="${LS_CMD}"
	fi
}

# -------------------------- start of Znap ------------------------------

source ~/.znap/zsh-snap/znap.zsh

znap source ohmyzsh/ohmyzsh
znap source ohmyzsh/ohmyzsh lib/git plugins/{git,git-extras,fzf,command-not-found}
znap source Aloxaf/fzf-tab
znap source denysdovhan/gitio-zsh
# znap source erichs/composure
znap source romkatv/powerlevel10k
znap source wstein/git-toolbelt-zsh
# znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions

# optional plugins
isvalid ansible && znap source ohmyzsh/ohmyzsh plugins/ansible
isvalid aws && znap source ohmyzsh/ohmyzsh plugins/aws
isvalid az && znap source ohmyzsh/ohmyzsh plugins/azure
isvalid docker && znap fpath _docker 'docker completion zsh'
isvalid docker-compose && znap source ohmyzsh/ohmyzsh plugins/docker-compose
isvalid fnm && znap fpath _fnm 'fnm completions --shell=zsh'
isvalid fossil && znap source ohmyzsh/ohmyzsh plugins/fossil
isvalid gcloud && znap source ohmyzsh/ohmyzsh plugins/gcloud
if isvalid gh && gh extension list | grep -q copilot; then
    . <(gh copilot alias -- zsh)
fi
isvalid helm && znap fpath _helm 'helm completion zsh'
isvalid just && znap fpath _just 'just --completions=zsh'
isvalid k9s && znap fpath _k9s 'k9s completion zsh'
isvalid kitty && znap source ohmyzsh/ohmyzsh plugins/kitty
isvalid kubectl && znap fpath _kubectl 'kubectl completion zsh'
isvalid minikube && znap source ohmyzsh/ohmyzsh plugins/minikube
isvalid packer && znap source ohmyzsh/ohmyzsh plugins/pass
isvalid rg && znap fpath _rg 'rg --generate complete-zsh'
isvalid taskw && znap source ohmyzsh/ohmyzsh plugins/taskwarrior
isvalid terraform && znap source ohmyzsh/ohmyzsh plugins/terraform
isvalid timew && znap source svenXY/timewarrior
isvalid tmux && znap source ohmyzsh/ohmyzsh plugins/tmux
isvalid vagrant && znap source ohmyzsh/ohmyzsh plugins/vagrant
isvalid vault && znap source ohmyzsh/ohmyzsh plugins/vault

# -------------------------- end of Znap ------------------------------

if isvalid "rg"; then
	export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore-vcs --glob '!.git/*'"
else
	export FZF_DEFAULT_COMMAND='find -not -path "*/.git"'
fi

if isvalid "bat"; then
	export MANPAGER="bat -l man -p"
fi

# check for user podman.sock and set DOCKER_HOST otherwise use default
if [ -S "${XDG_RUNTIME_DIR}/podman/podman.sock" ]; then
	export DOCKER_HOST="unix://${XDG_RUNTIME_DIR}/podman/podman.sock"
elif [ -S "/var/run/docker.sock" ]; then
	export DOCKER_HOST="unix:///var/run/docker.sock"
fi

# extend path
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
if [ -f "${HOME}/.rbenv/bin/rbenv" ]; then
	export PATH="${PATH}:${HOME}/.rbenv/bin"
	eval "$(${HOME}/.rbenv/bin/rbenv init -)"
fi

#alias ccat='ccat -C always -G Comment=red'
#alias dcat='rougify --require ~/.config/rouge/themes/dracula_colorful.rb highlight --theme dracula_colorful'

alias dockrun='docker run -it --rm -e TERM="xterm-256color" -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/mnt -w /mnt -e HOST_GROUPNAME=`id --name --group` -e HOST_USERNAME=`id --name --user` -e HOST_GID=`id --group` -e HOST_UID=`id --user`'
alias dockrunx='dockrun -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'

alias mkpasswd='mkpasswd --method=yescrypt'
alias histuniq="{ history | sort -u --key=1.9 | sort -n -k1,1 }"
alias z85="basenc --z85"
isvalid terraform && alias tf="terraform"

alias kicat='kitty +kitten icat'
alias kssh='kitty +kitten ssh'
alias qscp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=off'
alias qssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=off'
alias qssh-copy-id='ssh-copy-id -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=off -o PreferredAuthentications=keyboard-interactive'
alias qpscp='scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=off -o PreferredAuthentications=keyboard-interactive'
alias qpssh='ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=off -o PreferredAuthentications=keyboard-interactive'

isvalid pwgen && alias pwg='pwgen -Bsy -r"[]{}=-+_/?\\|'"'"'\`;:@#^&*()<>~\"yYzZ"'

isvalid fzf && {
	alias fzff='fzf --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}"'
	alias fzffm='fzf -m --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}"'
	alias fzfd='find -type d -not -path "*/.*" 2>/dev/null | fzf --ansi --preview="eza -alh --git --color=always {}"'
	alias fzfdm='find -type d -not -path "*/.*" 2>/dev/null | fzf -m --ansi --preview="eza -alh --git --color=always {}"'
	alias vimz='vim `fzff`'
	alias vimzd='vim `fzfd`'
	alias cdz='cd `fzfd`'
}
alias h='fc -ln'
alias hl='fc -Dil'
isvalid code && {
	alias dcode='detach code'
	alias codez='code $(fzff)'
	alias codezd='code $(fzfd)'
}
isvalid idea && alias didea='detach idea'
isvalid dnf && alias dnf-upgrade-and-reboot="sudo sh -c 'dnf upgrade && reboot'"
isvalid yum && alias yum-upgrade-and-reboot="sudo sh -c 'yum upgrade && reboot'"

# restart GNOMEShell like Alt-F2 r
alias restart-gnome="busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart(\"Restarting…\")'"

alias mount-ls='mount -l | column --table --table-columns=device,-,mount,-,type,options,label --table-hide=2,4 --table-order=device,label,mount,type'
alias df-mount="df -hT -x devtmpfs -x tmpfs"

isvalid qrencode && alias qrencode-ansiutf8="qrencode -t ansiutf8"

alias ls="ls --color=auto"
lsalias l='lsd --icon=auto':'ls -F -x'
lsalias l.='lsd -d --icon=auto .*':'ls -F -dx .*'
lsalias la='lsd -A --icon=auto':'ls -F -Ahlx'
lsalias laa='lsd -a --icon=auto':'ls -F -ahlx'

lsalias ll='lsd -l --icon=auto --date=+%Y-%m-%d\ %H:%M':'ls -F -hl'
lsalias ll.='lsd -l -d --icon=auto --date=+%Y-%m-%d\ %H:%M .*':'ls -F -dhl .*'
lsalias lla='lsd -l -A --icon=auto --date=+%Y-%m-%d\ %H:%M':'ls -F -Ahl'
lsalias llaa='lsd -l -a --icon=auto --date=+%Y-%m-%d\ %H:%M':'ls -F -ahl'

lsalias lg='lsd -l --git --icon=auto --date=relative':
lsalias lg.='lsd -l -d --git --icon=auto --date=relative .*':
lsalias lga='lsd -l -A --git --icon=auto --date=relative':
lsalias lgaa='lsd -l -a --git --icon=auto --date=relative':

lsalias lt='lsd --tree -l --icon=auto':
lsalias lt.='lsd --tree -l -d --icon=auto .*':
lsalias lta='lsd --tree -l -A --icon=auto':
lsalias ltg='lsd --tree -l --git --icon=auto':
lsalias ltg.='lsd --tree -l -d --git --icon=auto .*':
lsalias ltga='lsd --tree -l -A --git --icon=auto':

isvalid git && alias gtlo="git log --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --tags --no-walk"

alias bwz='/usr/bin/ruby -e "$(curl -fsSL https://brewiz.github.io/bin/brewiz)" --'

if isvalid "\\gl"; then
	alias gle='\\gl'
	alias glbr='\\gl branch'
	alias glbrc='\\gl branch -c'
	alias glbrd='\\gl branch -d'
	alias glco='\\gl checkout'
	alias glcommit='gl commit'
	alias glcmsg='\\gl commit -m'
	alias gldiff='\\gl diff'
	alias glfuse='\\gl fuse'
	alias glhist='\\gl history'
	alias glinit='\\gl init'
	alias glmerge='\\gl merge'
	alias glpub='\\gl publish'
	alias glrem='\\gl remote'
	alias glremc='\\gl remote -c'
	alias glremd='\\gl remote -d'
	alias glres='\\gl resolve'
	alias glst='\\gl status'
	alias glsw='\\gl switch'
	alias gltag='\\gl tag'
	alias gltagc='\\gl tag -c'
	alias gltagd='\\gl tag -d'
	alias gltagr='\\gl tag -l'
	alias gltr='\\gl track'
	alias glutr='\\gl untrack'
fi

if isvalid xclip; then
	alias pbcopy='xclip -selection clipboard'
	alias pbpaste='xclip -selection clipboard -o'
elif isvalid xsel; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
fi

# global definitions
export EDITOR=vim

# To customize prompt, run $(p10k configure).
if [ -n "${P10K_LEAN_THEME}" ] || [ "${TERM}" = "linux" ]; then
	source "${HOME}/.config/zsh/lean-ansi.zsh"
else
	source "${HOME}/.config/zsh/rainbow-dracula-unicode.zsh"
fi

unfunction lsalias

if isvalid pyenv; then
	eval "$(pyenv init -)"
	eval "$(pyenv virtualenv-init -)"
fi

# added by Nix installer
if [ -e /home/werner/.nix-profile/etc/profile.d/nix.sh ]; then
	. /home/werner/.nix-profile/etc/profile.d/nix.sh
fi

if [ -e /usr/local/bin/aws_completer ]; then
	autoload bashcompinit && bashcompinit
	autoload -Uz compinit && compinit
	complete -C '/usr/local/bin/aws_completer' aws
fi

if [ -e /usr/bin/terraform ]; then
	autoload -U +X bashcompinit && bashcompinit
	complete -o nospace -C /usr/bin/terraform terraform
fi

export GPG_TTY=$(tty)

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
	export PATH=/opt/homebrew/opt/ruby/bin:$PATH
	export PATH=`gem environment gemdir`/bin:$PATH
fi

if [ -f "/usr/local/lib/antlr-4-complete.jar" ]; then
    alias antlr4="java -Xmx500M org.antlr.v4.Tool"
    alias grun="java org.antlr.v4.gui.TestRig"
fi

if [ -d "/opt/homebrew/opt/groovy/libexec" ]; then
	export GROOVY_HOME=/opt/homebrew/opt/groovy/libexec
fi

if [ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]; then
	export SDKMAN_DIR="$HOME/.sdkman"
	source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

if [ -d "$HOME/.cargo/bin" ]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

isvalid nvim && alias vim="nvim"

if isvalid tre; then
	tre() { 
		command tre "$@" -e &&\
		source "/tmp/tre_aliases_$USER" 2>/dev/null; 
	}
fi

# Added by Windsurf
#export PATH="/Users/werner/.codeium/windsurf/bin:$PATH"

PATH=~/.console-ninja/.bin:$PATH

# bun completions
if [ -s "~/.bun/_bun" ]; then
	source "/Users/werner/.bun/_bun"
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"
fi

