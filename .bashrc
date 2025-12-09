#!/bin/bash
# SPDX-FileCopyrightText: 2023-2025 Jason Pena <jasonpena@awkless.com>
# SPDX-License-Identifier: MIT

# Add default shell environment...
if [ -f "$HOME/.shrc" ]; then
  # shellcheck source=/dev/null
  . "$HOME/.shrc"
else
  echo ".shrc not found, bash environment maybe unstable" 2>&1
fi

# Enable programmable completion features...
if ! shopt -oq posix; then
  if [ -f "/usr/share/bash-completion/bash_completion" ]; then
    # shellcheck source=/dev/null
    . "/usr/share/bash-completion/bash_completion"
  elif [ -f "/etc/bash_completion" ]; then
    # shellcheck source=/dev/null
    . "/etc/bash_completion"
  else
    echo "cannot find bash completion features" 2>&1
  fi
fi

# Check  the window size after each command and if necessary, update the values
# of LINES and COLUMNS...
shopt -s checkwinsize

# Do not put duplicate lines in history...
HISTCONTROL=ignoredups:ignorespace

# Append to history file, do not overwrite it...
shopt -s histappend

# Set history sizes...
HISTSIZE=1000
HISTFILESIZE=1000

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/awkless/usr/local/opt/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/awkless/usr/local/opt/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/awkless/usr/local/opt/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/awkless/usr/local/opt/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

