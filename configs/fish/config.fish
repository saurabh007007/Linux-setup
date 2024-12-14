source /usr/share/cachyos-fish-config/cachyos-config.fish
function is_git_repo
    if test -d .git
        return 0
    else
        set git_root (git rev-parse --show-toplevel 2>/dev/null)
        if test -n "$git_root"
            cd $git_root   # Change directory to the root of the Git repository
            return 0
        else
            return 1
        end
    end
end

if status is-interactive
    if is_git_repo
        onefetch
    else
        fastfetch
    end
    zoxide init fish | source
    source /opt/miniconda3/etc/fish/conf.d/conda.fish
    # Commands to run in interactive sessions can go here
end
