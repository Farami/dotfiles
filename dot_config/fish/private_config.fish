set fish_greeting ""

# fish_add_path -gP is idempotent and skips missing dirs, so nested shells
# cannot duplicate entries and dead paths drop out on their own.
fish_add_path -gP /opt/homebrew/bin
fish_add_path -gP /opt/homebrew/sbin

set -g fish_prompt_pwd_dir_length 1

# aliases
alias g lazygit
alias lg lazygit
alias c "cursor ."
alias tt taskwarrior-tui
alias t task
alias tw timew
alias cursor-cli cursor-agent

set -gx EDITOR nvim

fish_add_path -gP $HOME/bin
fish_add_path -gP $HOME/.local/bin

# Go
set -gx GOPATH $HOME/go
fish_add_path -gP $GOPATH/bin

#Android
set -gx ANDROID_HOME $HOME/Library/Android/sdk
fish_add_path -gP $ANDROID_HOME/emulator
fish_add_path -gP $ANDROID_HOME/platform-tools

# DotNet
# See https://github.com/dotnet/sdk/issues/9415#issuecomment-406915716
fish_add_path -gP $HOME/.dotnet/tools

switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set -l LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# pnpm
set -gx PNPM_HOME $HOME/Library/pnpm
fish_add_path -gP $PNPM_HOME

# Rust
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end

# Added by Windsurf
fish_add_path -gP $HOME/.codeium/windsurf/bin

# Mise
if status is-interactive
    mise activate fish | source
else
    mise activate fish --shims | source
end

# Added by LM Studio CLI (lms)
fish_add_path -gPa $HOME/.lmstudio/bin

# try.rb forks ruby, so keep it out of non-interactive shells and scripts
if status is-interactive; and test -f ~/.local/try.rb
    eval (env SHELL=(status fish-path) ~/.local/try.rb init ~/src/tries | string collect)
end
