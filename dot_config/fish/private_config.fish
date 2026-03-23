set fish_greeting ""

# Homebrew paths (needs to be early in config)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

#set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias g lazygit
alias lg lazygit
command -qv nvim && alias vim nvim
alias c "cursor ."
alias tt taskwarrior-tui
alias t task
alias tw timew
alias cursor-cli cursor-agent

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

# DotNet
# See https://github.com/dotnet/sdk/issues/9415#issuecomment-406915716
set -gx PATH $HOME/.dotnet/tools $PATH

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

# Java - using mise

# Rust
source "$HOME/.cargo/env.fish"

# Added by Windsurf
fish_add_path /Users/work/.codeium/windsurf/bin

# Mise
if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/work/.lmstudio/bin
# End of LM Studio CLI section
eval (~/.local/try.rb init ~/src/tries | string collect)

#Disable fancy prompts when Cursor Agent runs 
if set -q CURSOR_AGENT
    function fish_prompt
        echo (prompt_pwd)' $ '
    end
end

# Added by Antigravity
fish_add_path /Users/work/.antigravity/antigravity/bin
