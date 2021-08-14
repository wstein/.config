#!/bin/env zsh

# put additional paths to fpath
fpath=($fpath)

source "${HOME}"/.local/bin/antigen.zsh

# ========================== HELPER start =============================

# helper to check if command is available
isvalid() {
	command -v "$1" >/dev/null
}

# create folder inclusive parents and change to folder
mkcd() {
	mkdir -p "$1" && cd "$1" || exit
}

# call morecompletions from command line to get completions which do not work from current .zshrc
morecompletions() {
	. <(taskctl completion zsh)
	! test -f /.antigen/bundles/svenXY/timewarrior/_timew || . $_
}

result() {
	local ERRORCODE=$?
	local MESSAGE=${*:-\=>}

	if [ $ERRORCODE = 0 ]; then
		echo "${MESSAGE} \e[32m\e[1msuccess"
	else
		echo "${MESSAGE} \e[31m\e[1merror ${ERRORCODE}"
	fi

	return $ERRORCODE
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

export FZF_BASE=$(command -v fzf)
if isvalid "rg"; then
	export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
else
	export FZF_DEFAULT_COMMAND='find -not -path "*/.git"'
fi

# extend path
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

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

# Load the zsh-users bundles.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

# other bundles.
antigen bundle erichs/composure
antigen bundle denysdovhan/gitio-zsh
antigen bundle nvie/git-toolbelt
antigen bundle wstein/git-toolbelt-zsh
isvalid timew && antigen bundle svenXY/timewarrior

# Load the theme.
antigen theme romkatv/powerlevel10k

# Tell Antigen that you're done.
antigen apply

# aliases
alias ccat='ccat -C always -G Comment=red'
alias dcat='rougify --require ~/.config/rouge/themes/dracula_colorful.rb highlight --theme dracula_colorful'

alias dockrun='docker run -it --rm -e TERM="xterm-256color" -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime -v /var/run/docker.sock:/var/run/docker.sock -v $PWD:/mnt -w /mnt -e HOST_GROUPNAME=`id --name --group` -e HOST_USERNAME=`id --name --user` -e HOST_GID=`id --group` -e HOST_UID=`id --user`'
alias dockrunx='dockrun -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix'

alias kssh='kitty +kitten ssh'
alias lhzsh='HISTFILE=$PWD/.zsh_history exec zsh'
alias lhbash='HISTFILE=$PWD/.bash_history exec bash'

alias fzff='fzf --ansi --preview="rougify --require ~/.config/rouge/themes/dracula_colorful.rb highlight --theme dracula_colorful {}"'
alias fzffm='fzf -m --ansi --preview="rougify --require ~/.config/rouge/themes/dracula_colorful.rb highlight --theme dracula_colorful {}"'
alias fzfd='find -type d -not -path "*/.*" 2>/dev/null | fzf --ansi --preview="exa -alh --git --color=always {}"'
alias fzfdm='find -type d -not -path "*/.*" 2>/dev/null | fzf -m --ansi --preview="exa -alh --git --color=always {}"'
alias vimz='vim `fzff`'
alias vimzd='vim `fzfd`'
alias cdz='cd `fzfd`'
isvalid code && alias codez='code $(fzff)'
isvalid code && alias codezd='code $(fzfd)'

# restart GNOMEShell like Alt-F2 r
alias restart="busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart(\"Restarting…\")'"

alias ls="ls --color=auto"
isvalid xsel && {
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
}

# global definitions
export EDITOR=vim

# To customize prompt, run $(p10k configure).
if [ -n "${P10K_LEAN_THEME}" ] || [ "${TERM}" = "linux" ]; then
	source "${HOME}/.config/zsh/lean-ansi.zsh"
else
	source "${HOME}/.config/zsh/rainbow-dracula-unicode.zsh"
fi

unfunction lsalias
