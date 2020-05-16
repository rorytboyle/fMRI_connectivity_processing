"""
This script conducts a sanity check to compare connectivity matrices created 
in Python vs connectivity matrices created using BioImageSuite

Author: Rory Boyle rorytboyle@gmail.com
Date: 16/05/2020
"""
import pandas as pd
import numpy as np

#%% 1) Read in files
timeseries = pd.read_csv("A:\\ROI_timeseries\\1255811_timeseries.csv",
                         header=None)

bis_conn_mx = pd.read_csv("A:\\Connectivity_matrices\\1255811_connMx_zscored.csv",
                          header=None)

#%% 2) Get correlation matrix
corr_mx = np.corrcoef(timeseries.transpose())

#%% 3) Fisher Transform the correlation matrix
# Fisher transform is equivalent to the inverse hyperbolic tangent (np.arctanh)
conn_mx = np.arctanh(corr_mx)

# Convert to dataframe
conn_mx = pd.DataFrame.from_records(conn_mx)

#%% 4) Clean up dataframes for comparison
# Set diagonals to nans (to enable comparison
for i in range(len(bis_conn_mx)):
    bis_conn_mx.iloc[i, i] = np.inf
    conn_mx.iloc[i,i] = np.inf

#%% 5) Compare files
dfCompare = bis_conn_mx.eq(conn_mx)

# Get total number of cells that are equal
equal_cells = dfCompare.sum().sum()

# Check if total number of equal cells is = to total number of cells
total_cells = np.prod(list(conn_mx.shape))

# find index of cells that are not equal
def getIndexes(dfObj, value):
    ''' Get index positions of value in dataframe i.e. dfObj.
    Function copied from here: https://thispointer.com/python-find-indexes-of-an-element-in-pandas-dataframe/
    '''
 
    listOfPos = list()
    # Get bool dataframe with True at positions where the given value exists
    result = dfObj.isin([value])
    # Get list of columns that contains the value
    seriesObj = result.any()
    columnNames = list(seriesObj[seriesObj == True].index)
    # Iterate over list of columns and fetch the rows indexes where value exists
    for col in columnNames:
        rows = list(result[col][result[col] == True].index)
        for row in rows:
            listOfPos.append((row, col))
    # Return a list of tuples indicating the positions of value in the dataframe
    return listOfPos

# get indices of unequal cells
unequal_ix = getIndexes(dfCompare, False)

# Print unequal values
for i in unequal_ix:
    print("Matrix index: " + str(i))
    print("BioImageSuite Connectivity Matrix value = " + str(bis_conn_mx.iloc[i]))
    print("Python Connectivity Matrix value = " + str(conn_mx.iloc[i]))
    print("Difference between values = " + str(bis_conn_mx.iloc[i] - conn_mx.iloc[i]))
    print('\n')

# Get list of difference between values
diffs = [bis_conn_mx.iloc[i] - conn_mx.iloc[i] for i in unequal_ix]

# If any differences are larger than 4th decimal place (arbitary decision!),
# maybe something suspect has happened.
# Most differences will just be due to rounding error.
if max(diffs) > 0.0001:
    print("Check connectivity matrices - difference might not be a result of a rounding error")
else:
    print("differences likely just due to rounding error - proceed")