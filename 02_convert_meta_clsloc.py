""" 

similarly, to access the stuff in the ground_truth.mat file, you can do something like this:

meta = sp.io.loadmat("ILSVRC2012_devkit_t12/data/meta.mat")
type(meta)
meta.keys()
rec = meta["rec"]
type(rec), rec.shape
rec.dtype
len(rec[0, 0])
arec = rec[0, 0][0]
dict(zip(arec.dtype.fields.keys(), map(lambda t: t[0].tolist() if t.shape[1] > 1 else t[0, 0], arec[0, 0])))

"""

import os
import scipy as sp
from pathlib import Path
import pandas as pd

# change the current working directory to the location of this script
SCRIPT_DIR = Path(__file__).parent.resolve().absolute()
print(f"[debug] SCRIPT_DIR: {SCRIPT_DIR}")

os.chdir(SCRIPT_DIR)
print(f"[debug] current working directory: {os.getcwd()}")

META_MAT_FPATH = Path("ILSVRC2012_devkit_t12/data/meta.mat")
print(f"[debug] META_MAT_FPATH: {META_MAT_FPATH}")

assert META_MAT_FPATH.exists(), "ERROR: META_MAT_FPATH does not exist!"

print("loading")
synsets = sp.io.loadmat(str(META_MAT_FPATH))["synsets"]
keys = list(synsets.dtype.fields.keys())

def get_data(key, arr):
    
    if key != "children":
        assert arr.size == 1, f"ERROR: arr.size = {arr.size} != 1"
        ret = arr.ravel()[0]
    
    else: 
        if arr.size == 0:
            ret = None
        else: 
            ret = tuple(arr.ravel().tolist())

    return key, ret
    
print("creating dataframe")
df = pd.DataFrame.from_records([
    dict(get_data(k, a) for k, a in zip(keys, ss))
    for ss in synsets.ravel()
])

print("saving synsets.csv")
df.to_csv("synsets.csv", index=False)
