"""
Code for checking for missing values (NaNs and zeros) in timeseries files

Author: Rory Boyle rorytboyle@gmail.com
Date: 24/11/2020
"""
# Import libraries
import pandas as pd
import numpy as np
import os

# Specify input and ouput directories - .csvs in input directory should only
# be ROI timeseries (200 timepoints * 268 ROIs). 
input_dir = "A:\old\ROI_timeseries\\"

# Read in list of files and get full file paths if file is a .csv file
file_list = os.listdir(input_dir)
fullfiles = [input_dir + file for file in file_list if file[-4:] == '.csv']

# Set up dataframe for storing number of nans and indices of nans
# convert datatype of df to object so that list of nan indices can be saved
timeseries_missing_value_df = pd.DataFrame(np.zeros((len(fullfiles), 3)), 
                                 columns = ['subid', 'num_nans', 'num_zeros'
                                            ]).astype('object')

# Loop through each timeseries file and check for NaNs
for count, file in enumerate(fullfiles):
    
    timeseries = pd.read_csv(file, header=None)
    
#    if timeseries.isna().sum().sum() > 0:
#        timeseries_with_NaNs.append(timeseries)

    
    # Get subid
    subid = file.split("\\")[-1].split("_")[0]
    
    # Count nans
    num_nans = timeseries.isna().sum().sum()
    
    # Count zeros
    num_zeros = (timeseries==0).sum().sum()
    
    # Add subid to missing_value_df
    timeseries_missing_value_df.loc[
            timeseries_missing_value_df.index[count], "subid"] = subid
            
    # Add nan info to missing_value_df
    timeseries_missing_value_df.loc[
            timeseries_missing_value_df.index[count], "num_nans"] = num_nans

    # Add info on zeros to missing_value_df        
    timeseries_missing_value_df.loc[
            timeseries_missing_value_df.index[count], "num_zeros"] = num_zeros
            

# Save df as csv file 
timeseries_missing_value_df.set_index('subid', inplace=True)    
timeseries_missing_value_df.to_csv("A:\\timeseries_missing_values_check_unsmoothed.csv")
