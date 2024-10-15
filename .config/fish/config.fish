if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x PATH ~/app/nvim/bin $PATH
    set -x PATH ~/app/nodejs/bin $PATH
    clear && neofetch
end
