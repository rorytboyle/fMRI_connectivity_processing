"""
Script to move 4D_timeseries.nii and gm.nii files to new directories

Author: Rory Boyle rorytboyle@gmail.com
Date: 19/11/2020
"""
import os
import gzip
import shutil

# get parent dirs
dirs = [r'A:\batch1_preprocessed', 'A:\batch2_preprocessed', 
        r'A:\batch3_preprocessed', r'A:\batch4_preprocessed',
        r'A:\batch5_preprocessed']

out_dir = r'A:\to_temporal_smooth'

# Loop through each dir and get individual participants folders
for subdir in dirs:
    ppt_folder = os.listdir(subdir)
    
    # append subdir name to ppt_folder
    ppt_folder = [os.path.join(subdir, folder) for folder in ppt_folder]
    
    # Loop through participant folders, create new subdir and copy files
    for ppt in ppt_folder:
        
        # get ppt id (subid)
        subid = ppt[-7:]
        
        # get .nii file names
        timeseries = os.path.join(ppt, subid + '_4D_timeseries.nii')
        gm_mask = os.path.join(ppt, subid + '_gm.nii')
        
        # check ppt has a 4D timeseries image
        if os.path.exists(timeseries):
        
            # make subdir for that participant in new directory
            new_subdir = os.path.join(out_dir, subid)
            os.mkdir(new_subdir)
            
            # create output file names (gzipped file names)
            gzip_timeseries = os.path.join(new_subdir, 
                                           timeseries.split('\\')[-1]+'.gz')
            gzip_gm_mask = os.path.join(new_subdir, 
                                        gm_mask.split('\\')[-1]+'.gz')
            
            # gzip timeseries image and copy to new directory
            with open(timeseries, 'rb') as f_in:
                with gzip.open(gzip_timeseries, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)
            
            # gzip GM mask and copy to new directory
            with open(gm_mask, 'rb') as f_in:
                with gzip.open(gzip_gm_mask, 'wb') as f_out:
                    shutil.copyfileobj(f_in, f_out)

    