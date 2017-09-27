# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$HOME/opt/emacs/bin:$HOME/opt/tmux/bin

export PATH

source /usr/share/doc/git2u-core-doc-2.11.1/contrib/completion/git-prompt.sh

export RBENV_ROOT="${HOME}/opt/rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
eval "$(rbenv init -)"
export PS1='[\e[38;5;210m\u@\h\e[0m \e[38;5;115m$(__git_ps1 "(%s)")\w\e[0m]\e[38;5;223m\$\!\e[0m: '
