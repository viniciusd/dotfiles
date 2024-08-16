# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

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
plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/opt/local/bin:/usr/texbin"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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
%{$fg_bold[red]%}$(arch)%{$reset_color%} %{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
$(prompt_char) '
RPROMPT='${VIMODE}'

setopt INC_APPEND_HISTORY

# Highlight on LESS, note you must have gnu's source-highlight
# export LESSOPEN="| src-hilite-lesspipe.sh %s"
export LESS=' -R '

if [ -z "$VIMRUNTIME" ]
then
    # VI mode
    bindkey -v
    export KEYTIMEOUT=1

    # allow v to edit the command line (standard behaviour)
    autoload -Uz edit-command-line
    bindkey -M vicmd 'v' edit-command-line
fi

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

_direnv_hook() {
  eval "$("/usr/local/bin/direnv" export zsh)";
}

typeset -ag precmd_functions;

if hash direnv 2>/dev/null
then
    if [[ -z ${precmd_functions[(r)_direnv_hook]} ]]
    then
      precmd_functions+=_direnv_hook;
    fi
fi

[ -f $HOME/.profile ] && source $HOME/.profile

# On OS X, path_helper builds PATH based on /etc/paths.d and /etc/manpaths.d
if [ -x /usr/libexec/path_helper ]; then
        eval `/usr/libexec/path_helper -s`
fi

alias vim='nvim -p'

setopt noincappendhistory
setopt nosharehistory

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

. $HOME/.asdf/asdf.sh

# . $HOME/.asdf/completions/asdf.bash
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
hash vtop 2>/dev/null && alias top='vtop'

# Multiple Homebrews on Apple Silicon
if [ "$(arch)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="/opt/homebrew/opt/python@3.8/bin:$PATH"
    # export LDFLAGS="-L/opt/homebrew/opt/python@3.8/lib" # For compilers to find python@3.8
    export PATH="/bin:/opt/homebrew:/opt/homebrew/bin/:$PATH"
else
    eval "$(/usr/local/bin/brew shellenv)"
    export PATH="/usr/local/opt/python@3.7/bin:$PATH"
    export PATH="/usr/local/opt/python@3.9/bin:$PATH"
    # export LDFLAGS="-L/usr/local/opt/python@3.7/lib" # For compilers to find python@3.7
    export PATH="/bin:/usr/local/bin/:$PATH"
fi
export LDFLAGS="-L$(brew --prefix)/lib"
export CPPFLAGS="-I$(brew --prefix)/include"
export LIBRARY_PATH="$(brew --prefix)/lib:$LIBRARY_PATH"
export CPATH=$(brew --prefix)/include
export C_INCLUDE_PATH=$(brew --prefix)/include
export CPLUS_INCLUDE_PATH=$(brew --prefix)/include
export OBJC_INCLUDE_PATH=$(brew --prefix)/include
export DYLD_FALLBACK_LIBRARY_PATH=$(brew --prefix)/lib
export CC=$(brew --prefix llvm)/bin/clang
export CXX=$(brew --prefix llvm)/bin/clang++
export CMAKE_OSX_ARCHITECTURES=arm64
export CMAKE_APPLE_SILICON_PROCESSOR=1
