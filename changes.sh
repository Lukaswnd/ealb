#!/bin/bash

# Function to update submodule if GITHUB_UPDATE_BUILDER is true
update_submodule() {
    if [ "$GITHUB_UPDATE_BUILDER" = "true" ]; then
        echo "Updating submodule..."
        cd original
        git checkout main # Or the branch you want to track
        git pull origin main
        cd ..
    else
        echo "Skipping submodule update..."
    fi
}

# Function to copy files from ./my-stuff/ to ./original/
copy_files() {
    echo "Copying files from ./my-stuff/ to ./original/..."

    # Iterate over all files and directories in ./my-stuff/
    for item in my-stuff/*; do
        # Get the base name of the item
        base_name=$(basename "$item")

        # Check if the item is a directory
        if [ -d "$item" ]; then
            # If it's a directory, copy its contents to the corresponding directory in ./original/
            cp -r "$item/"* "original/$base_name/"
        else
            # If it's a file, copy it to the ./original/ directory
            cp "$item" "original/$base_name"
        fi
    done
}

# Function to remove the folder ./original/components/fb_gfx
remove_folder() {
    echo "Removing folder ./original/components/fb_gfx..."
    rm -rf original/components/fb_gfx
}

# Load the submodule ./original
echo "Loading submodule..."
git submodule init
git submodule update

# Update the submodule if required
update_submodule

# Copy files from ./my-stuff/ to ./original/
copy_files

# Remove the specified folder
remove_folder

echo "Script execution completed."
