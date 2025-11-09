#!/bin/bash

selected=$(
    fzf --ansi \
        --prompt="Fuzzy Finder: " \
        --preview 'batcat --color=always {}' \
        --select-1 \
        --cycle \
        --keep-right \
        --scroll-off=4
)

[ -z "$selected" ] && exit 1

file=$(echo "$selected" | cut -d: -f1)

editor_choice=$(echo -e "1. Neovim\n2. IntelliJ IDEA" | fzf --prompt="Choose editor: ")

[ -z "$editor_choice" ] && exit

case "$editor_choice" in
"1. Neovim")
    #!/bin/bash
    echo "Running Neovim with file: $file"

    gnome-terminal -- nvim "$file"
    ;;
"2. IntelliJ IDEA")
    idea "$file" || nvim "$file"
    ;;
*)
    echo "Invalid choice"
    exit 1
    ;;
esac
