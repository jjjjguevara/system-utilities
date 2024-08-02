#!/bin/bash

# Define the input file containing the directory structure
INPUT="Dewey Decimal Classification.md"

# Function to create directories from a markdown list
create_directories() {
    local base_dir="$1"
    local indent_level="$2"
    local current_indent=""
    local target_dir="$base_dir"

    while IFS= read -r line || [[ -n "$line" ]]; do
        # Extract the current indentation level and directory name
        current_indent=$(echo "$line" | sed -E 's/^(\s*).*/\1/' | tr -d '\n')
        dir_name=$(echo "$line" | sed -E 's/^\s*- (.*)/\1/' | tr -d '\n')

        # Calculate the relative path based on indentation
        if [[ ${#current_indent} -eq ${#indent_level} ]]; then
            target_dir="$base_dir/$dir_name"
        elif [[ ${#current_indent} -gt ${#indent_level} ]]; then
            base_dir="$target_dir"
            target_dir="$target_dir/$dir_name"
        else
            base_dir="${base_dir%/*}"
            target_dir="$base_dir/$dir_name"
        fi

        # Create the directory
        mkdir -p "$target_dir"
        indent_level="$current_indent"
    done < "$INPUT"
}

# Start creating directories from the markdown file
create_directories "." ""
