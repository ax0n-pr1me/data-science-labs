#!/bin/bash

# derived-contour.sh
#
# Description:
# This script processes TIFF files in a specified input directory, performing
# a band calculation and then generating contours from the result. It allows
# specifying the bands for the calculation, the calculation formula, and the
# contour interval and range. Optionally, it can also output the calculated TIFF.
# The contour outputs are saved as GeoPackage files.
#
# Usage:
# ./derived-contour.sh -i [input_folder] -o [output_folder] -a [band1] \
# -b [band2] -c [band3] -k "[formula]" -s [step] -m [min_contour] -x [max_contour] \
# -t [enable_tiff_output]

# Default parameters
A_BAND=1
B_BAND=2
C_BAND=3
CALC="A-0.25*B-0.25*C"
STEP=10
MIN_CONTOUR=
MAX_CONTOUR=
TIFF_OUTPUT=0

# Parse command-line arguments
while getopts "i:o:a:b:c:k:s:m:x:t:" opt; do
    case $opt in
    i) INPUT_FOLDER="$OPTARG" ;;
    o) OUTPUT_FOLDER="$OPTARG" ;;
    a) A_BAND="$OPTARG" ;;
    b) B_BAND="$OPTARG" ;;
    c) C_BAND="$OPTARG" ;;
    k) CALC="$OPTARG" ;;
    s) STEP="$OPTARG" ;;
    m) MIN_CONTOUR="-fl $OPTARG" ;;
    x) MAX_CONTOUR="-fh $OPTARG" ;;
    t) TIFF_OUTPUT=1 ;;
    ?)
        echo "Unknown option: -$OPTARG"
        exit 1
        ;;
    esac
done

# Check required parameters
if [ -z "$INPUT_FOLDER" ] || [ -z "$OUTPUT_FOLDER" ]; then
    echo "Error: Input and output folders are required."
    exit 1
fi

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Process each TIFF file in the input folder
for tif_file in "$INPUT_FOLDER"/*.tif; do
    # Define output file names
    base_name=$(basename "$tif_file" .tif)
    calc_output="${OUTPUT_FOLDER}/${base_name}_calc.tif"
    gpkg_output="${OUTPUT_FOLDER}/${base_name}_contours.gpkg"

    # Perform band calculation
    gdal_calc.py -A "$tif_file" --A_band=$A_BAND -B "$tif_file" --B_band=$B_BAND -C "$tif_file" --C_band=$C_BAND --outfile="$calc_output" --calc="$CALC"

    # Generate contours in GeoPackage format
    gdal_contour -a elevation "$calc_output" "$gpkg_output" -i $STEP $MIN_CONTOUR $MAX_CONTOUR -f GPKG

    # Remove the temporary calculated TIFF if TIFF output is not required
    if [ "$TIFF_OUTPUT" -eq 0 ]; then
        rm "$calc_output"
    fi
done

echo "Processing complete."
