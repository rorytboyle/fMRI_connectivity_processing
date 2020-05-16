<# 
This script contains Windows Powershell Code for computing Fisher Normalised
Connectivity Matrices from ROI timeseries
This script requires installation of biswebnode (npm install biswebnode). Other
files/packages may be required - see below links for further details:
https://www.npmjs.com/package/biswebnode
https://bioimagesuiteweb.github.io/bisweb-manual/CommandLineTools.html
Only include the ROI timeseries .csv files in your output directory.

Author: Rory Boyle rorytboyle@gmail.com
Date: 16/05/2020
#>

# Enter your input directory name here 
$inputdir = "A:\ROI_timeseries"

# Enter your output directory name here
$outputdir = "A:\Connectivity_matrices"

# Navigate to output directory
Set-Location $outputdir

# Read files
$files = Get-ChildItem -Path $inputdir -Recurse -Include *.csv

# Loop through files, 
foreach($file in $files){
#Get subid of file
$subid = $file.Name.Substring(0,7);
# Call biswebnode and compute correlation matrix with z-scores, and save output
biswebnode computecorrelation -i $file.fullname -o $subid'_connMx_zscored.csv' --zscore}