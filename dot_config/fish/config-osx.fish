# Unset the default fish greeting text which messes up Zellij
function fish_greeting
    if command -v fastfetch >/dev/null 2>&1
        # Small delay to ensure terminal is fully sized
        sleep 0.1
        command fastfetch --logo-width 20 --logo mac
    end
end

# Check if we're in an interactive shell
if status is-interactive

    # At this point, specify the Zellij config dir, so we can launch it manually if we want to
    export ZELLIJ_CONFIG_DIR=$HOME/.config/zellij

    # Check if our Terminal emulator is Ghostty
    if [ "$TERM" = xterm-ghostty ]
        # Launch zellij
        eval (zellij setup --generate-auto-start fish | string collect)
    end

    set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
    atuin init fish | source
    starship init fish | source
    carapace _carapace | source
    zoxide init fish --cmd cd | source
end

set -x NDK_HOME /Users/work/Library/Android/sdk/ndk/25.1.8937393/


# Mac specific aliases
if type -q eza
    alias ls "eza -F --icons"
    alias la "eza -a --icons"
    alias ll "eza -l --icons --git"
    alias lla "eza -la --icons --git"
    alias lsa "eza -aa --icons"
end

if type -q chezmoi
    alias cz chezmoi
end

if type -q brew
    # Disable Homebrew environment hints
    set -gx HOMEBREW_NO_ENV_HINTS 1

    alias b brew
    alias bu "brew upgrade"
end

alias tpa "cd ~/Sources/TrackPilotAdminN/TrackPilotAdminN/"
alias tpw "cd ~/Sources/TrackPilotN/"
