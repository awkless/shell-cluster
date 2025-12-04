#!/bin/sh
# SPDX-FileCopyrightText: 2023-2025 Jason Pena <jasonpena@awkless.com>
# SPDX-License-Identifier: MIT
# XDG base directory setup.
#
# See https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
: "${XDG_CONFIG_HOME:=$HOME/.config}" "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_STATE_HOME:=$HOME/.local/state}" "${XDG_CACHE_HOME:=$HOME/.cache}"
export XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME XDG_CACHE_HOME

# Configure session information settings...
: "${LOGNAME:=$(logname)}" "${HOSTNAME:=$(uname -n)}"
export LOGNAME HOSTNAME

# Load .shrc as default environment...
: "${ENV:=$HOME/.shrc}"
export ENV

# Add binaries to PATH if they arent added yet. Affix colons on either side of
# $PATH to simplify matching...
case ":${PATH}:" in
  *:"$HOME/.local/share/../bin":*)
    ;;
  *)
    # Prepending path in case a system-installed binary needs to be
    # overridden...
    export PATH="$HOME/.local/share/../bin:$PATH"
    ;;
esac

# Ruby stuff...
: "${GEM_HOME=$(ruby -e 'puts Gem.user_dir')}"
export GEM_HOME
export PATH="$PATH:$GEM_HOME/bin"

# Rust stuff...
export PATH="$PATH:$HOME/.cargo/bin"

: "${EDITOR:=vim}" "${FCEDIT:=$EDITOR}" "${VISUAL:=$EDITOR}" "${PAGER:=less -FX}"
: "${HISTFILE:=${XDG_DATA_HOME:-$HOME/.local/share}/history}"
: "${LESSHISTFILE:="-"}" "${GNUPGHOME:=${XDG_CONFIG_HOME:-$HOME/.config}/gnupg}"
: "${PASSWORD_STORE_DIR:=${XDG_DATA_HOME:-$HOME/.local/share}/password-store}"
: "${WGETRC:=${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc}"
: "${TMUX_TMPDIR:=${XDG_CACHE_HOME:-$HOME/.cache}/tmux}"
: "${QT_QPA_PLATFORMTHEME:="gtk2"}" "${MOZ_USE_XINPUT2:="1"}"
: "${AWT_TOOLKIT:="MToolkit wmname LG3D"}" "${_JAVA_AWT_WM_NONREPARENTING:=1}"
: "${DEBUGINFOD_URLS:="https://debuginfod.archlinux.org/"}"
: "${GDBHISTFILE:=${XDG_DATE_HOME:-$HOME/.local/share}/gdb_history}"
: "${XINITRC:=$HOME/.xinitrc}"
: "${XSERVERRC:=${XDG_CONFIG_HOME:-$HOME/.config}/X11/xserverrc}"
export EDITOR FCEDIT VISUAL PAGER HISTFILE LESSHISTFILE GNUPGHOME
export QT_QPA_PLATFORMTHEME MOZ_USE_XINPUT2 AWT_TOOLKIT
export _JAVA_AWT_WM_NONREPARENTING PASSWORD_STORE_DIR WGETRC
export DEBUGINFOD_URLS GDBHISTFILE XINITRC XSERVERRC

# Enable GPG SSH agent support. I like to use my GPG key for SSH
# authentication...
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  export SSH_AUTH_SOCK
fi

# Spawn GPG agent (must go here in .profile or else multiple agents will spawn
# ruining splits in TMUX)...
GPG_TTY="$(tty)"
export GPG_TTY
gpg-connect-agent updatestartuptty /bye > /dev/null

# Autostart X at login...
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec startx "$XINITRC"
fi
