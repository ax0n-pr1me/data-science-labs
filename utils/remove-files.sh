#!/bin/bash

# README for remove-files.sh
# --------------------------------------------------------------------------------------
# Script Name: remove-files.sh
# Description: This utility script recursively removes all files with a specified name
#              in the current directory and its subdirectories.
#
# Usage: ./remove-files.sh [FILENAME]
#   [FILENAME] : Specify the name of the files to be removed.
#
# Example: ./remove-files.sh example.txt
#          This will remove all files named 'example.txt' in the current directory
#          and all subdirectories.
#
# Notes:
# - Use this script with caution as deleted files cannot be easily recovered.
# - Ensure that you have the necessary permissions to delete the files in the desired
#   directory.
# - This script is intended for use on UNIX/Linux systems.
#
# --------------------------------------------------------------------------------------

# Check if the file name argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [FILENAME]"
    exit 1
fi

FILENAME=$1

# Confirmation prompt
read -p "Are you sure you want to delete all files named '$FILENAME'? [y/N] " confirmation
if [[ $confirmation != [Yy] ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Finding and removing the specified files
find . -type f -name "$FILENAME" -exec rm -v {} \;

echo "All files named '$FILENAME' have been removed."
