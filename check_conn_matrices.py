"""
Code for checking for NaNs in connectivity matrices and plotting heatmaps

Author: Rory Boyle rorytboyle@gmail.com
Date: 29/05/2020
"""
# Import libraries
import pandas as pd
import numpy as np
import os

# Specify input and ouput directories - .csvs in input directory should only
# be connectivity matrices. 
input_dir = "A:\\Connectivity_matrices\\"
output_dir = "A:\connectivity_matrices_heatmaps\\"

# Read in list of files and get full file paths if file is a .csv file
file_list = os.listdir(input_dir)
fullfiles = [input_dir + file for file in file_list if file[-4:] == '.csv']

# Set up dataframe for storing number of nans and indices of nans
# convert datatype of df to object so that list of nan indices can be saved
nan_df = pd.DataFrame(np.zeros((len(fullfiles), 3)), columns = ['subid', 
                      'num_nans', 'ix_nans']).astype('object')

# Loop through each connectivity matrix, check for NaNs and plot heatmap
for count, file in enumerate(fullfiles):
    
    # Read in data
    conn_mx = pd.read_csv(file, header=None)
    
    # Get subid
    subid = file.split("\\")[-1].split("_")[0]
    
    # Count nans and get indices
    num_nans, ix_nans = conn_mx_nan_check(conn_mx)
    
    # Add subid and nan info to nan_df
    nan_df.loc[nan_df.index[count], "subid"] = subid
    nan_df.loc[nan_df.index[count], "num_nans"] = num_nans
    nan_df.loc[nan_df.index[count], "ix_nans"] = ix_nans

    # Create filename for heatmap figure
    saveFile = output_dir + subid + "_heatmap.png"
    
    # Make heatmap
    conn_mx_heatmap(conn_mx, subid, saveFile, fisher_transformed=True, 
                    show=False)
    
# Save nan_df as pickle file 
nan_df.to_pickle(output_dir + "conn_mx_nan_check.pkl")
