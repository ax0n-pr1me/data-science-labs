#!/bin/bash

echo "Script started."

# Parse arguments
while getopts i:o:v:p:n:s:t option; do
    case "${option}" in
    i) INPUT_DIR=${OPTARG} ;;
    o) OUTPUT_DIR=${OPTARG} ;;
    v) VRT_BANDS=${OPTARG} ;;
    p) PAN_BAND=${OPTARG} ;;
    n) ENABLE_PANSHARPEN=true ;;
    s) SAVE_VRT=true ;;
    t) SAVE_GEOTIFF=true ;;
    esac
done

echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "VRT Bands: $VRT_BANDS"
echo "Pan Band: $PAN_BAND"
echo "Pan Sharpen: $ENABLE_PANSHARPEN"
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

# Function to perform pan-sharpening
pan_sharpen() {
    local pan_band=$1
    local input_file=$2
    local start_time=$3
    local output_file="${input_file%.vrt}_pansharpened.vrt"

    # Construct the path for the pan-sharpening file
    local pan_file=$(find "$INPUT_DIR" -type f -name "*M6C${pan_band}_G16_s${start_time}*.nc")

    # Convert NetCDF pan band to TIFF
    local pan_file_tiff="${pan_file%.nc}.tif"
    if [ -f "$pan_file" ]; then
        echo "Converting NetCDF pan band to TIFF: $pan_file -> $pan_file_tiff"
        gdal_translate -of GTiff NETCDF:"$pan_file":Rad "$pan_file_tiff"
    fi

    echo "Looking for pan band file with pattern: *M6C${pan_band}_G16_s${start_time}*.nc"
    echo "Pan band file found: $pan_file"
    echo "Input VRT file: $input_file"

    if [ -f "$pan_file_tiff" ] && [ -f "$input_file" ]; then
        echo "Performing pan-sharpening on $input_file with pan band file $pan_file_tiff"
        echo "running gdal_pansharpen.py $pan_file_tiff $input_file $output_file"
        gdal_pansharpen.py "$pan_file_tiff" "$input_file" "$output_file"
        if [ -f "$output_file" ]; then
            echo "Pan-sharpened VRT created: $output_file"
            return 0
        else
            echo "Error: Pan-sharpened VRT not created."
            return 1
        fi
    else
        echo "Error: Pan band TIFF file or input VRT file not found."
        return 1
    fi
}

# Function to process each start time
process_start_time() {
    local start_time=$1
    matched_files=$(match_files "$start_time")
    if [ -n "$matched_files" ]; then
        read -a files_array <<<$matched_files # Convert string to array
        local vrt_file="${OUTPUT_DIR}/${start_time}.vrt"

        if [ "$SAVE_VRT" = true ] || [ "$SAVE_GEOTIFF" = true ]; then
            echo "Generating VRT for start time: $start_time"
            generate_vrt "$start_time" "${files_array[@]}"
        fi

        if [ "$ENABLE_PANSHARPEN" = true ]; then
            echo "Applying pan-sharpening to VRT"
            pan_sharpen "$PAN_BAND" "$vrt_file" "$start_time"
            if [ $? -eq 0 ]; then
                vrt_file="${vrt_file%.vrt}_pansharpened.vrt" # Update VRT file path to the pansharpened VRT
            else
                echo "Pan-sharpening failed. Proceeding without it."
            fi
        fi

        if [ "$SAVE_GEOTIFF" = true ]; then
            echo "Generating GeoTIFF from VRT"
            generate_geotiff "$vrt_file"
        fi
    else
        echo "No matched files for start time: $start_time"
    fi
}

# Main processing loop
for file in "$INPUT_DIR"/*; do
    echo "Processing file: $file"
    if [[ $file =~ M6C([0-9]{2})_G16_s([0-9]+)_ ]]; then
        start_time=${BASH_REMATCH[2]}
        echo "Found start time: $start_time"
        process_start_time "$start_time"
    else
        echo "File $file does not match the pattern."
    fi
done

echo "Script finished."
