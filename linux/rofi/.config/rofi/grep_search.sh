#!/bin/bash

# Ask for the search term
search_term=$(rofi -dmenu -p "Search for")

# Exit if nothing typed
[ -z "$search_term" ] && exit

# Run rg to search content in the home directory, limit to first 1000 results
result=$(rg --no-heading --line-number --color=never "$search_term" ~/ \
    2>/dev/null | head -n 1000 | rofi -dmenu -i -p "Select match")

# Exit if nothing selected
[ -z "$result" ] && exit

# Extract file path and line number
file=$(echo "$result" | cut -d: -f1)
line=$(echo "$result" | cut -d: -f2)

# Ask for the editor choice (Neovim or IntelliJ IDEA)
editor_choice=$(echo -e "1. Neovim\n2. IntelliJ IDEA" | rofi -dmenu -p "Choose editor: " -i)

[ -z "$editor_choice" ] && exit

case "$editor_choice" in
"1. Neovim") # Neovim
    #!/bin/bash
    echo "Running Neovim with file: $file, line: $line"

    gnome-terminal -- nvim +"$line" "$file"
    ;;
"2. IntelliJ IDEA")
    idea --line "$line" "$file" || nvim "$file"
    ;;
*)
    echo "Invalid choice"
    exit 1
    ;;
esac
