<# 
This script contains Windows Powershell Code for computing Shen Atlas ROIs from 
preprocessed 4D timeseries images.
This script requires installation of biswebnode (npm install biswebnode). Other
files/packages may be required - see below links for further details:
https://www.npmjs.com/package/biswebnode
https://bioimagesuiteweb.github.io/bisweb-manual/CommandLineTools.html
Only include the 4d timeseries .nii images in your output directory.

Note: these lines of code were ran separately in the Windows Powershell, the full script was
not executed.

Author: Rory Boyle rorytboyle@gmail.com
Date: 13/05/2020
#>

# Enter your output directory name here
Set-Location "A:\ROI_timeseries"

# Read in files from input directory
$files = Get-ChildItem -Path 'A:\preprocessed_4D_timeseries' -Recurse -Include *.nii

# Loop through files, get subid, call biswebnode and compute ROIs, save output as subid_timeseries.csv
foreach($file in $files){$subid = $file.Name.Substring(0,7); biswebnode computeroi -i $file.fullname -r A:\shen_2mm_268_parcellation.nii -o $subid’_timeseries.csv’}
