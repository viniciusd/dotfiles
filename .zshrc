# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=13

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/opt/local/bin:/usr/texbin"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '☿' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

VIMODE='[i]'

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(prompt_char) '
RPROMPT='${VIMODE}'

setopt INC_APPEND_HISTORY

# Highlight on LESS, note you must have gnu's source-highlight
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=' -R '

# VI mode
bindkey -v
export KEYTIMEOUT=1

function zle-line-init zle-keymap-select {
    #VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    #RPS1="$PROMPT ${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}"
    #RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    #RPS2=$RPS1
    setopt localoptions no_ksharrays
    [[ "${@[2]-}" == opp ]] && return
    VIMODE="${${KEYMAP/vicmd/[n]}/(main|viins)/[i]}"
    zle reset-prompt
    zle -R
}

function zle-line-finish {
  vim_mode=$vim_ins_mode
  zle -R
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
# Thanks Ron! (see comments)
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
}

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line

bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-w word deletion (standard behaviour)
bindkey '^w' backward-kill-word

# allow ctrl+r for search backward
bindkey '^R' history-incremental-search-backward

export EDITOR=vim


check_venv() {
    if [[ "$VIRTUAL_ENV" != "" ]]
    then
        if echo "$PWD" | grep -vq "$VIRTUAL_ENV"
        then
            deactivate
        fi
    else
        # Better not auto-activating if it does not belong to you, security reasons
        [ -f bin/activate ] && [ $(stat | awk '{print $5}') = "$USER" ] && source bin/activate
    fi
}

precmd_functions=(check_venv)

[ -f $HOME/.profile ] && source $HOME/.profile
