<#
This script contains Windows Powershell Code for conducting a
temporal smooth (using a zero mean unit variance Gaussian filter)
on 4D fMRI timeseries. 
This script requires installation of BioImageSuite command line tools
https://bioimagesuiteweb.github.io/bisweb-manual/CommandLineTools.html

Author: Rory Boyle rorytboyle@gmail.com
Date: 20/11/2020
#>

# Set source paths
C:\yale\bioimagesuite35\setpaths

# Enter your input directory name here 
$inputdir = "A:\to_temporal_smooth"

# Enter your output directory name here
$outputdir = "A:\temporally_smoothed"

# Navigate to output directory
Set-Location $outputdir

# Read subdirs
$subdirs = Get-ChildItem -Path $inputdir

# Loop through subdirs
foreach($subdir in $subdirs){

# Get subid
$subid = $subdir.name

# Get 4D timeseries
$timeseries = Join-Path -Path $subdir.FullName -ChildPath $subid'_4D_timeseries.nii.gz'
$gm_mask = Join-Path -Path $subdir.FullName  -ChildPath $subid'_gm.nii.gz'

# replace backslashes with forward slashes - BioImageSuite won't find the .nii.gz files otherwise
$timeseries = $timeseries.replace("\", "/")
$gm_mask = $gm_mask.replace("\", "/")

# Run temporal smooth function
C:\yale\bioimagesuite35\bin\bis_temporalsmoothimage -out $subid'_temporally_smoothed.nii.gz' -blursigma 1 -usemask 1 -inp $timeseries -inp2 $gm_mask}