#!/bin/bash

echo "Script started."

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

echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "VRT Bands: $VRT_BANDS"
echo "Pan Band: $PAN_BAND"
echo "Save VRT: $SAVE_VRT"
echo "Save GeoTIFF: $SAVE_GEOTIFF"

# Function to match files based on band and start time
match_files() {
    local start_time=$1
    local bands=(${VRT_BANDS//,/ })
    local matched_files=()

    for band in "${bands[@]}"; do
        local file=$(find "$INPUT_DIR" -type f -name "*M6C${band}_G16_s${start_time}*.nc")
        if [ -n "$file" ]; then
            matched_files+=("$file")
        fi
    done

    printf '%s\n' "${matched_files[@]}"
}

# Function to generate VRT
generate_vrt() {
    local start_time=$1
    shift # remove the first argument (start_time)
    local files=("$@")
    local vrt_command="gdalbuildvrt -overwrite -resolution highest -separate -r cubic ${OUTPUT_DIR}/${start_time}.vrt"

    for file in "${files[@]}"; do
        vrt_command+=" NETCDF:\"$file\":Rad"
    done

    echo "Executing VRT command: $vrt_command"
    eval "$vrt_command"
}

# Function to generate GeoTIFF from VRT
generate_geotiff() {
    local vrt_file=$1
    echo "Converting VRT to GeoTIFF for $vrt_file"
    gdal_translate "${vrt_file}" "${vrt_file%.vrt}.tif"
}

# Main processing loop
for file in "$INPUT_DIR"/*; do
    echo "Processing file: $file"
    if [[ $file =~ M6C([0-9]{2})_G16_s([0-9]+)_ ]]; then
        start_time=${BASH_REMATCH[2]}
        echo "Found start time: $start_time"
        matched_files=$(match_files "$start_time")
        if [ -n "$matched_files" ]; then
            read -a files_array <<<$matched_files # Convert string to array
            if [ "$SAVE_VRT" = true ]; then
                echo "Generating VRT for start time: $start_time"
                generate_vrt "$start_time" "${files_array[@]}"
            fi
            if [ "$SAVE_GEOTIFF" = true ]; then
                echo "Generating GeoTIFF for start time: $start_time"
                generate_geotiff "${OUTPUT_DIR}/${start_time}.vrt"
            fi
        else
            echo "No matched files for start time: $start_time"
        fi
    else
        echo "File $file does not match the pattern."
    fi
done

echo "Script finished."
