# GOES Video

## Links

<https://en.wikipedia.org/wiki/GOES-16#Earth-facing>

<https://home.chpc.utah.edu/~u0553130/Brian_Blaylock/cgi-bin/goes16_download.cgi>

<https://cimss.ssec.wisc.edu/goes/GOESR_QuickGuides.html>

<https://github.com/blaylockbk/goes2go>

<https://github.com/blaylockbk/goes2go/blob/main/goes2go/product_table.txt>

<https://unidata.github.io/python-training/gallery/mapping_goes16_truecolor/>

<https://geonetcast.wordpress.com/2019/08/02/plot-0-5-km-goes-r-full-disk-regions/>

<https://github.com/deeplycloudy/glmtools/>

<https://agupubs.onlinelibrary.wiley.com/doi/epdf/10.1029/2019JD030874>

<https://github.com/pytroll/satpy>

<https://satpy.readthedocs.io/en/stable/overview.html>

## Notes for Manual Investigation

### Incident Times

UTC Date / Time
Start ~ 03/17/2022 2100
Death ~ 03/17/2022 2300

Local Time CDT (Daylight Savings Time)

### Data Notes

<https://github.com/blaylockbk/goes2go#download-data>

<https://goes2go.readthedocs.io/en/latest/user_guide/notebooks/DEMO_download_goes_timerange.html>

<https://goes2go.readthedocs.io/en/latest/reference_guide/index.html>

<https://corteva.github.io/rioxarray/stable/examples/clip_geom.html>

<https://unidata.github.io/python-gallery/examples/mapping_GOES16_TrueColor.html#sphx-glr-download-examples-mapping-goes16-truecolor-py>

<https://www.goes-r.gov/downloads/resources/documents/Beginners_Guide_to_GOES-R_Series_Data.pdf>

<https://docs.opendata.aws/noaa-goes16/cics-readme.html#accessing-goes-data-on-aws>

### Fire Hotspot Characterization

<https://home.chpc.utah.edu/~u0553130/Brian_Blaylock/cgi-bin/goes16_download.cgi?source=aws&satellite=noaa-goes16&domain=C&product=ABI-L2-FDC&date=2022-03-17&hour=21>

<https://cimss.ssec.wisc.edu/goes/OCLOFactSheetPDFs/QuickGuide_GOESR_FireHotSpot_v2.pdf>

`/product/year/day_of_year/hour/file_name`

```sh
OR_ABI-L2-FDCC-M6_G16_s20220762106174_e20220762108547_c20220762109141.nc
OR_ABI-L2-FDCC-M6_G16_s20220762111174_e20220762113547_c20220762114171.nc
OR_ABI-L2-FDCC-M6_G16_s20220762116174_e20220762118547_c20220762119146.nc
OR_ABI-L2-FDCC-M6_G16_s20220762121174_e20220762123547_c20220762124148.nc
OR_ABI-L2-FDCC-M6_G16_s20220762126174_e20220762128547_c20220762129148.nc
OR_ABI-L2-FDCC-M6_G16_s20220762131174_e20220762133547_c20220762134155.nc
OR_ABI-L2-FDCC-M6_G16_s20220762136174_e20220762138547_c20220762139137.nc
OR_ABI-L2-FDCC-M6_G16_s20220762141174_e20220762143547_c20220762144143.nc
OR_ABI-L2-FDCC-M6_G16_s20220762146174_e20220762148547_c20220762149144.nc
OR_ABI-L2-FDCC-M6_G16_s20220762151174_e20220762153547_c20220762154140.nc
OR_ABI-L2-FDCC-M6_G16_s20220762156174_e20220762158547_c20220762159138.nc
OR_ABI-L2-FDCC-M6_G16_s20220762201174_e20220762203547_c20220762204150.nc
OR_ABI-L2-FDCC-M6_G16_s20220762206174_e20220762208547_c20220762209131.nc
OR_ABI-L2-FDCC-M6_G16_s20220762211174_e20220762213547_c20220762214159.nc
OR_ABI-L2-FDCC-M6_G16_s20220762216174_e20220762218547_c20220762219131.nc
OR_ABI-L2-FDCC-M6_G16_s20220762221174_e20220762223547_c20220762224156.nc
OR_ABI-L2-FDCC-M6_G16_s20220762226174_e20220762228547_c20220762229143.nc
OR_ABI-L2-FDCC-M6_G16_s20220762231174_e20220762233547_c20220762234137.nc
OR_ABI-L2-FDCC-M6_G16_s20220762236174_e20220762238547_c20220762239142.nc
OR_ABI-L2-FDCC-M6_G16_s20220762241174_e20220762243547_c20220762244142.nc
OR_ABI-L2-FDCC-M6_G16_s20220762246174_e20220762248547_c20220762249134.nc
OR_ABI-L2-FDCC-M6_G16_s20220762251174_e20220762253547_c20220762254125.nc
OR_ABI-L2-FDCC-M6_G16_s20220762256174_e20220762258547_c20220762259128.nc
OR_ABI-L2-FDCC-M6_G16_s20220762301174_e20220762303547_c20220762304136.nc
OR_ABI-L2-FDCC-M6_G16_s20220762306174_e20220762308547_c20220762309134.nc
OR_ABI-L2-FDCC-M6_G16_s20220762311174_e20220762313547_c20220762314143.nc
OR_ABI-L2-FDCC-M6_G16_s20220762316174_e20220762318547_c20220762319132.nc
OR_ABI-L2-FDCC-M6_G16_s20220762321174_e20220762323547_c20220762324139.nc
OR_ABI-L2-FDCC-M6_G16_s20220762326174_e20220762328547_c20220762329145.nc
OR_ABI-L2-FDCC-M6_G16_s20220762331174_e20220762333547_c20220762334147.nc
OR_ABI-L2-FDCC-M6_G16_s20220762336174_e20220762338547_c20220762339131.nc
OR_ABI-L2-FDCC-M6_G16_s20220762341174_e20220762343547_c20220762344131.nc
OR_ABI-L2-FDCC-M6_G16_s20220762346174_e20220762348547_c20220762349141.nc
OR_ABI-L2-FDCC-M6_G16_s20220762351174_e20220762353547_c20220762354132.nc
OR_ABI-L2-FDCC-M6_G16_s20220762356174_e20220762358547_c20220762359127.nc
```

### Clipping all the scenes

<https://corteva.github.io/rioxarray/stable/examples/clip_geom.html>

## GDAL for VRT

We need a bash script to batch generate VRTs for GOES NetCDF data. here is an example of a single command
we need to make a bash script that accepts an input directory, an output directory, an input order of bands and a band for pan sharpening, and provide an option to save vrts and geotiffs
for example `goes-sharpen.sh -i ../netcdf -o ./output/ -vrt '7, 14, 15,' -pan 2 -save_vrt True -save_geotiff true`
this would create a vrt with band 7, 14, and 15 in that order, then pan sharpen it with band 2
the challenge will be finding the right files and matching them for the vrt.
files are named like "OR_ABI-L1b-RadC-M6C02_G16_s20220762101174_e20220762103547_c20220762103571.nc"
the band designation is the last two digits in the section M6C02 (for band 2)
then, each vrt can only contain bands with the same start time, designated with the s (s20220762101174 for this example)
the output should save s20220762101174.vrt and s20220762101174.tiff
the input directory contains files like this...

```sh
OR_ABI-L1b-RadC-M6C02_G16_s20220762101174_e20220762103547_c20220762103571.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762106174_e20220762108547_c20220762108571.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762111174_e20220762113547_c20220762113572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762116174_e20220762118547_c20220762118573.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762121174_e20220762123547_c20220762123572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762126174_e20220762128547_c20220762128572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762131174_e20220762133547_c20220762133572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762136174_e20220762138547_c20220762138571.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762141174_e20220762143547_c20220762143573.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762146174_e20220762148547_c20220762148572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762151174_e20220762153547_c20220762153572.nc
OR_ABI-L1b-RadC-M6C02_G16_s20220762156174_e20220762158547_c20220762158572.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762101174_e20220762103558_c20220762103593.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762106174_e20220762108558_c20220762108597.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762111174_e20220762113558_c20220762113596.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762116174_e20220762118558_c20220762119004.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762121174_e20220762123558_c20220762124008.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762126174_e20220762128558_c20220762128594.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762131174_e20220762133558_c20220762134024.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762136174_e20220762138558_c20220762138596.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762141174_e20220762143558_c20220762143597.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762146174_e20220762148558_c20220762148586.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762151174_e20220762153558_c20220762153583.nc
OR_ABI-L1b-RadC-M6C07_G16_s20220762156174_e20220762158558_c20220762159009.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762101174_e20220762103547_c20220762104020.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762106174_e20220762108547_c20220762109020.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762111174_e20220762113547_c20220762114014.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762116174_e20220762118547_c20220762119006.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762121174_e20220762123547_c20220762124017.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762126174_e20220762128547_c20220762129014.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762131174_e20220762133547_c20220762134007.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762136174_e20220762138547_c20220762139005.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762141174_e20220762143547_c20220762144025.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762146174_e20220762148547_c20220762149020.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762151174_e20220762153547_c20220762154019.nc
OR_ABI-L1b-RadC-M6C14_G16_s20220762156174_e20220762158547_c20220762159003.nc
```

and here is an example of the VRT command usign gdalbuildvrt

```sh
gdalbuildvrt -overwrite -resolution highest -separate -r cubic ./s20220762101174.vrt 
NETCDF:.OR_ABI-L1b-RadC-M6C02_G16_s20220762101174_e20220762103547_c20220762103571.nc:Rad 
NETCDF:.OR_ABI-L1b-RadC-M6C07_G16_s20220762101174_e20220762103558_c20220762103593.nc:Rad 
NETCDF:.OR_ABI-L1b-RadC-M6C14_G16_s20220762101174_e20220762103547_c20220762104020.nc:Rad
```

## Man Pages To Do

This documentation is written in the standard format used for Unix/Linux manual pages. To make this available via the man command, you would typically place this text in a file (e.g., pansharpen-goes.1) in a directory that is part of the MANPATH, such as /usr/share/man/man1/. Additionally, the file needs to be formatted with groff - the GNU troff text-formatting system.

Remember to replace placeholders like [Your Name/Your Organization], [Date of Release], and [Version Number] with the actual details. The SEE ALSO section references related commands (gdalbuildvrt and gdal_translate), assuming they are relevant to users of this script.

After creating the manual page, use gzip to compress it and then place it in the appropriate man directory (e.g., /usr/share/man/man1/). This will make it accessible via the man pansharpen-goes command.-++-