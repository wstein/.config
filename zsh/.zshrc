#!/bin/env zsh

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
fpath=("${HOME}"/.local/share/zsh/site-functions $fpath)

source "${HOME}"/.local/bin/antigen.zsh

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

# call morecompletions from command line to get completions which do not work from current .zshrc
morecompletions() {
	. <(taskctl completion zsh)
	! test -f ~/.antigen/bundles/svenXY/timewarrior/_timew || . ~/.antigen/bundles/svenXY/timewarrior/_timew
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
	if isvalid "exa"; then
		alias "${ALIAS}"="${EXA_CMD}"
	elif [ -n "${LS_CMD}" ]; then
		alias "${ALIAS}"="${LS_CMD}"
	fi
}

# ========================== HELPER end ===============================

if isvalid "rg"; then
	export FZF_DEFAULT_COMMAND='rg --files --hidden --no-ignore-vcs --glob "!.git/*"'
else
	export FZF_DEFAULT_COMMAND='find -not -path "*/.git"'
fi

if isvalid "bat"; then
	export MANPAGER="bat -l man -p"
fi

# extend path
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
if [ -f "${HOME}/.rbenv/bin/rbenv" ]; then
	export PATH="${PATH}:${HOME}/.rbenv/bin"
	eval "$(${HOME}/.rbenv/bin/rbenv init -)"
fi

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
#antigen bundle github < does not work with get-extras
antigen bundle git
isvalid git-extras && antigen bundle git-extras
isvalid fossil && antigen bundle fossil
isvalid fzf && antigen bundle fzf
isvalid docker && antigen bundle docker
isvalid docker-compose && antigen bundle docker-compose
isvalid ripgrep && antigen bundle ripgrep
isvalid terraform && antigen bundle terraform
isvalid vagrant && antigen bundle vagrant
isvalid tmux && antigen bundle tmux
isvalid kitty && antigen bundle kitty
antigen bundle command-not-found
isvalid taskw && antigen bundle taskwarrior

# Load the zsh-users bundles.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# other bundles.
antigen bundle Aloxaf/fzf-tab
antigen bundle erichs/composure
antigen bundle denysdovhan/gitio-zsh
antigen bundle wstein/zsh-syntax-highlighting # adapted dracula theme
antigen bundle wstein/git-toolbelt-zsh
isvalid timew && antigen bundle svenXY/timewarrior

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# aliases
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
isvalid pwgen && alias pwg='pwgen -Bsy -r"[]{}=-+_/?\\|'"'"'\`;:@#^&*()<>~\"yYzZ"'

isvalid fzf && {
	alias fzff='fzf --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}"'
	alias fzffm='fzf -m --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}"'
	alias fzfd='find -type d -not -path "*/.*" 2>/dev/null | fzf --ansi --preview="exa -alh --git --color=always {}"'
	alias fzfdm='find -type d -not -path "*/.*" 2>/dev/null | fzf -m --ansi --preview="exa -alh --git --color=always {}"'
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
lsalias l='exa -Fx --icons':'ls -Fx'
lsalias l.='exa -Fdx --icons .*':'ls -Fdx .*'
lsalias la='exa -Fax --icons':'ls -AFhlx'
lsalias laa='exa -Faax --icons':'ls -Fahlx'

lsalias ll='exa -Fhlx --icons --time-style long-iso':'ls -Fhl'
lsalias ll.='exa -Fdhlx --icons --time-style long-iso .*':'ls -Fdhl .*'
lsalias lla='exa -Fahlx --icons --time-style long-iso':'ls -AFhl'
lsalias llaa='exa -Faahlx --icons --time-style long-iso':'ls -Fahl'

lsalias lg='exa -Fhlx --git --icons --time-style long-iso':
lsalias lg.='exa -Fdhlx --git --icons --time-style long-iso .*':
lsalias lga='exa -Fahlx --git --icons --time-style long-iso':
lsalias lgaa='exa -Faahlx --git --icons --time-style long-iso':

lsalias lt='exa -FThlx --icons':
lsalias lt.='exa -FTdhlx --icons .*':
lsalias lta='exa -FTahlx --icons':
lsalias ltg='exa -FThlx --git --icons':
lsalias ltg.='exa -FTdhlx --git --icons .*':
lsalias ltga='exa -FTahlx --git --icons':

isvalid git && alias gtlo="git log --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --tags --no-walk"

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
