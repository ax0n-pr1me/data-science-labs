#!/bin/bash

# README for count-duplicates.sh
# --------------------------------------------------------------------------------------
# Script Name: count-duplicates.sh
# Description: This utility script finds and counts duplicate file names in the current
#              directory and all subdirectories. It lists each duplicate file name along
#              with the count of its occurrences.
#
# Usage: ./count-duplicates.sh -gt [NUMBER]
#   -gt [NUMBER] : Specify the minimum count of duplicates for a file to be listed.
#                  Replace [NUMBER] with the desired threshold.
#
# Example: ./count-duplicates.sh -gt 2
#          This will list files that have more than 2 duplicates.
#
# Notes:
# - The script considers files with the same name as duplicates, regardless of their content.
# - Ensure that you have the necessary permissions to execute this script in the desired directory.
# - This script is intended for use on UNIX/Linux systems.
#
# --------------------------------------------------------------------------------------

# Check if the argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 -gt [NUMBER]"
    exit 1
fi

# Extract the argument value
if [ "$1" == "-gt" ]; then
    MIN_COUNT=$2
else
    echo "Invalid argument. Use -gt [NUMBER]"
    exit 1
fi

# Main script to find and count duplicates
find . -type f | awk -F/ '{print $NF}' | sort | uniq -d | while read line; do
    count=$(find . -type f | grep -Fc "$line")
    if [ "$count" -gt "$MIN_COUNT" ]; then echo "$line $count"; fi
done
