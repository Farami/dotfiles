function ide
    tmux split-window -v -l 30% -c "#{pane_current_path}"
    tmux split-window -h -l 66% -c "#{pane_current_path}"
    tmux split-window -h -l 50% spotify_player
    tmux select-pane -t 0

    # Check for optional parameters
    for arg in $argv
        switch $arg
            case yarn
                tmux select-pane -t 2
                tmux send-keys "yarn start" C-m
            case tailwind
                tmux select-pane -t 1
                tmux send-keys "yarn dev:tailwind" C-m
        end
    end

    # Always finish on pane 0
    tmux select-pane -t 0
end
