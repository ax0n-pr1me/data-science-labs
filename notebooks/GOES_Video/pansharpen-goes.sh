#!/bin/bash

# Parse arguments
while getopts i:o:v:p:sv:t option; do
    case "${option}" in
    i) INPUT_DIR=${OPTARG} ;;
    o) OUTPUT_DIR=${OPTARG} ;;
    v) VRT_BANDS=${OPTARG} ;;
    p) PAN_BAND=${OPTARG} ;;
    s) SAVE_VRT=true ;;
    t) SAVE_GEOTIFF=true ;;
    esac
done

# Function to match files based on band and start time
match_files() {
    local start_time=$1
    local bands=(${VRT_BANDS//,/ })
    local matched_files=()

    for band in "${bands[@]}"; do
        # Find files with matching start time and band
        local file=$(find "$INPUT_DIR" -type f -name "*M6C${band}_G16_s${start_time}*.nc")
        if [ -n "$file" ]; then
            matched_files+=("$file")
        fi
    done

    echo "${matched_files[@]}"
}

# Function to generate VRT
generate_vrt() {
    local start_time=$1
    local files=($2)
    local vrt_command="gdalbuildvrt -overwrite -resolution highest -separate -r cubic ${OUTPUT_DIR}/${start_time}.vrt"

    for file in "${files[@]}"; do
        vrt_command+=" NETCDF:\"$file\":Rad"
    done

    # Pan sharpening
    if [ -n "$PAN_BAND" ]; then
        local pan_file=$(find "$INPUT_DIR" -type f -name "*M6C${PAN_BAND}_G16_s${start_time}*.nc")
        if [ -n "$pan_file" ]; then
            vrt_command+=" NETCDF:\"$pan_file\":Rad"
        fi
    fi

    eval $vrt_command
}

# Function to generate GeoTIFF from VRT
generate_geotiff() {
    local vrt_file=$1
    gdal_translate "${vrt_file}" "${vrt_file%.vrt}.tif"
}

# Main processing loop
for file in "$INPUT_DIR"/*; do
    if [[ $file =~ M6C([0-9]{2})_G16_s([0-9]+)_ ]]; then
        local start_time=${BASH_REMATCH[2]}
        local matched_files=$(match_files "$start_time")
        if [ -n "$matched_files" ]; then
            if [ "$SAVE_VRT" = true ]; then
                generate_vrt "$start_time" "$matched_files"
            fi
            if [ "$SAVE_GEOTIFF" = true ]; then
                generate_geotiff "${OUTPUT_DIR}/${start_time}.vrt"
            fi
        fi
    fi
done
