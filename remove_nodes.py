def remove_nodes(timeseries, ix_nodes_to_remove):
    """
    Removes nodes/ROIs from a timeseries (e.g. for scans with poor coverage)

    :param timeseries: n(rows) * m (columns) dataframe where n = number of 
    frames/volumes and m = number of ROIs in 4D timeseries. 
    :param ix_nodes_to_remove: column indices of ROIs/nodes to be removed from
    timeseries
        
    :return restricted_timeseries: n * (m - number of removed nodes) dataframe
    :return node_ix: dictionary where keys = original column index of
    ROI/node (i.e. in timeseries) and values = new column index of ROI/node 
    (i.e in restricted_timeseries). Removed nodes will have a NaN value.

    Author: Rory Boyle rorytboyle@gmail.com
    Date: 12/01/2021
    """
    import pandas as pd
    import numpy as np
    
    # remove nodes from original timeseries
    restricted_timeseries = timeseries.drop(ix_nodes_to_remove, axis=1)
      
    # loop through original indices and create list of new indices
    new_ix = []
    counter = 0
    removed_counter = 0
    
    for ix in timeseries.columns.values:
        
        if ix not in ix_nodes_to_remove:
            new_ix.append(counter)
            counter += 1
        elif ix in ix_nodes_to_remove:
            new_ix.append(np.nan)
        
    # create dictionary connection original indices to new indices
    node_ix = dict(zip(timeseries.columns.values, new_ix))

    return restricted_timeseries, node_ix
    
    