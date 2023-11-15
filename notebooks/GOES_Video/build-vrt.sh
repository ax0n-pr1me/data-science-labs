#!/bin/bash

# Directory containing NetCDF files
input_dir="./noaa-goes16_b2-7-14/ABI-L1b-RadC/2022/076/21"
# Output directory for VRT files
output_dir="./output"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Function to extract start time from filename
extract_start_time() {
    echo "$1" | grep -oP 's\d+'
}

# Function to generate VRT
generate_vrt() {
    local start_time=$1
    local output_file="$output_dir/$start_time.vrt"
    local files=("${@:2}")

    # Construct gdalbuildvrt command
    local cmd="gdalbuildvrt -overwrite -resolution highest -separate -r cubic $output_file"
    for file in "${files[@]}"; do
        cmd+=" NETCDF:$input_dir/$file:Rad"
    done

    # Execute command
    echo "Generating VRT: $output_file"
    eval "$cmd"
}

# Main loop
declare -A file_groups
for file in "$input_dir"/*; do
    filename=$(basename "$file")
    start_time=$(extract_start_time "$filename")
    file_groups[$start_time]+="$filename "
done

for start_time in "${!file_groups[@]}"; do
    files=($start_time ${file_groups[$start_time]})
    generate_vrt "${files[@]}"
done

echo "Batch VRT generation complete."
