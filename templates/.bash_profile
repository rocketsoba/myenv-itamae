# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:$HOME/opt/emacs/bin:$HOME/opt/tmux/bin

export PATH

export PS1='[\[\e[38;5;210m\]\u@\h\[\e[0m\] \[\e[38;5;115m\]\w\[\e[0m\]]\[\e[38;5;223m\]\$\!\[\e[0m\]: '
