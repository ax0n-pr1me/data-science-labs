#!/bin/bash

# ---------------------------------------------------------
# clip_geotiffs.sh
#
# Description:
# This script is designed to clip GeoTIFF files using a specified GeoJSON file.
# It loops through all GeoTIFF files in a given directory, clips them based on the
# GeoJSON boundary, and saves the output in a specified directory with each filename
# prefixed with 'clp_'.
#
# Usage:
# ./clip_geotiffs.sh -g <path_to_geojson> -fp <path_to_geotiff_dir> -o <output_dir>
#
# Arguments:
# -g  Path to the GeoJSON file used for clipping.
# -fp Path to the directory containing GeoTIFF files to be clipped.
# -o  Output directory where clipped GeoTIFF files will be saved.
#
# Requirements:
# - GDAL: This script uses the 'gdalwarp' tool from the GDAL library. Ensure GDAL is
#   installed and accessible in your system's PATH.
#
# Example:
# ./clip_geotiffs.sh -g /path/to/boundary.geojson -fp /path/to/geotiffs -o /path/to/output
#
# Author: Ax0n
# ---------------------------------------------------------

# Function to show usage
usage() {
    echo "Usage: $0 -g <path_to_geojson> -f <path_to_geotiff_dir> -o <output_dir>"
    exit 1
}

# Function to check for GDAL installation
check_gdal() {
    if ! command -v gdalwarp &>/dev/null; then
        echo "Error: gdalwarp is not installed or not in the PATH."
        exit 1
    fi
}

# Initialize variables
GEOTIFF_DIR=""
OUTPUT_DIR=""
GEOJSON_PATH=""

# Parse command line options
while getopts ':g:f:o:' flag; do
    case "${flag}" in
    g) GEOJSON_PATH="${OPTARG}" ;;
    f) GEOTIFF_DIR="${OPTARG}" ;;
    o) OUTPUT_DIR="${OPTARG}" ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        usage
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        usage
        ;;
    esac
done

# Check if all required options were provided
if [ -z "$GEOJSON_PATH" ]; then
    echo "Error: Path to geojson is missing."
    usage
fi

if [ -z "$GEOTIFF_DIR" ]; then
    echo "Error: Path to geotiff directory is missing."
    usage
fi

if [ -z "$OUTPUT_DIR" ]; then
    echo "Error: Output directory is missing."
    usage
fi

# Check for GDAL installation
check_gdal

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Loop through each .tif file in the geotiff directory
for GEOTIFF in "$GEOTIFF_DIR"/*.tif; do
    if [ ! -f "$GEOTIFF" ]; then
        echo "No GeoTIFF files found in $GEOTIFF_DIR."
        continue
    fi

    # Extract filename without extension
    FILENAME=$(basename "$GEOTIFF" .tif)

    # Construct output file path
    OUTPUT_FILE="$OUTPUT_DIR/clp_${FILENAME}.tif"

    # Clip the geotiff with the geojson and save to output file
    echo "Clipping $GEOTIFF..."
    if ! gdalwarp -cutline "$GEOJSON_PATH" -crop_to_cutline -dstalpha "$GEOTIFF" "$OUTPUT_FILE"; then
        echo "Error occurred while clipping $GEOTIFF."
        continue
    fi
done

echo "Clipping complete."
