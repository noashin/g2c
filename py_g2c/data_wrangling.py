import pandas as pd
import numpy as np

def prepare_target(csv_file):
    df = pd.read_csv(csv_file).set_index('Unnamed: 0')

    connectivity_mat = df.as_matrix()
    N = connectivity_mat.shape[0]
    connectivity_mat[connectivity_mat > 0.05] = 0.
    connectivity_mat[connectivity_mat > 0.] = 1.

    connectivity_mat_flatten = connectivity_mat.flatten()

    target = np.delete(connectivity_mat_flatten, np.arange(0, N*N, N))

    return target