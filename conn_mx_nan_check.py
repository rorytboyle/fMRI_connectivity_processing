def conn_mx_nan_check(conn_mx):
    """
    Counts number of NaNs in connectivity matrix and finds integer indices of
    NaNs. Returns a list of results and the OLS results object.

    :param conn_max: connectivity matrix
    :return num_nans: total number of nans in connectivity matrix (int)
    :return ix_nans: integer indices of NaNs in conn_mx (list)
    
    Author: Rory Boyle rorytboyle@gmail.com
    Date: 29/05/2020
    """
    
    import scipy.sparse as sp
    
    # Count NaNs
    num_nans = conn_mx.isna().sum().sum()

    # If there are NaNs, get indices
    if num_nans > 0:
        x, y = sp.coo_matrix(conn_mx.isnull()).nonzero()
        ix_nans = list(zip(x,y))
    else: 
        ix_nans = []
        
    return num_nans, ix_nans