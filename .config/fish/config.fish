set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias lsa "ls -a"
alias g lazygit
alias lg lazygit
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -gx PATH $GOPATH/bin $PATH

#Android
set -gx ANDROID_HOME $HOME/Library/Android/sdk
set -gx PATH $ANDROID_HOME/emulator $PATH
set -gx PATH $ANDROID_HOME/platform-tools $PATH


# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    else
    end
end

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# pnpm
set -gx PNPM_HOME /Users/work/Library/pnpm
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/work/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /Users/farami/miniconda3/bin/conda
    eval /Users/farami/miniconda3/bin/conda "shell.fish" hook $argv | source
end
# <<< conda initialize <<<

# Java
set PATH $HOME/.jenv/bin $PATH
status --is-interactive; and jenv init - | source

# Python
pyenv init - | source
