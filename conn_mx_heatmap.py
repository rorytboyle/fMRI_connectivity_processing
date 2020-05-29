def conn_mx_heatmap(conn_mx, fig_title, saveto, fisher_transformed=True,
                    show=False):
    """
    Plots heatmap of a connectivity matrix and saves figure in specified folder.

    :param conn_max: connectivity matrix
    :param fig_title: string containing title to give heatmap figure
    :param saveto: string containing path to save figure
    :param fisher_transformed: Boolean flag indicating whether conn_mx is fisher
    z transformed or not. If conn_mx has been transformed, diagonal will be set
    to NaN, otherwise diagonal will not be altered (i.e. will be left as 1).
    :param show: Boolean flag to hide or show figure. show=False will suppress
    figure output
    True indicates conn_mx has been fisher z transformed.
    
    Author: Rory Boyle rorytboyle@gmail.com
    Date: 29/05/2020
    """
    import numpy as np
    import matplotlib.pyplot as plt
    import seaborn as sns
    
    # Change diagonals to NaNs if conn_mx has been fisher transformed
    # Fisher transformed matrices have diagonals = 6.103 which skews the heatmap
    if fisher_transformed == True:
        for i in range(len(conn_mx)):
            conn_mx.iloc[i,i] = np.nan
            
    # Create heatmap and save
    if show==False:  # Suppress plot output             
        ax = plt.axes()
        sns.heatmap(conn_mx, ax=ax)
        ax.set_title(fig_title)
        plt.savefig(saveto)
        plt.close()
        plt.clf()
    
    elif show==True:  # Show plot output
        ax = plt.axes()
        sns.heatmap(conn_mx, ax=ax)
        ax.set_title(fig_title)
        plt.savefig(saveto)
        plt.show()
        plt.close()
        plt.clf()
