
import os
import scipy as sp
from pathlib import Path
import pandas as pd

# change the current working directory to the location of this script
SCRIPT_DIR = Path(__file__).parent.resolve().absolute()
print(f"[debug] SCRIPT_DIR: {SCRIPT_DIR}")

os.chdir(SCRIPT_DIR)
print(f"[debug] current working directory: {os.getcwd()}")

SYNSET_FPATH = SCRIPT_DIR / "synsets.csv"
print(f"[debug] SYNSET_FPATH: {SYNSET_FPATH}")

df = pd.read_csv(SYNSET_FPATH).iloc[:1000]
mapping = dict(zip(df["ILSVRC2012_ID"].values, df["WNID"]))

assert len(mapping) == 1000, "ERROR: len(mapping) != 1000"
assert tuple(set(mapping.keys())) == tuple(range(1, 1001)), "ERROR: set(mapping.keys()) != set(range(1, 1001))"

VAL_GROUND_TRUTH_FPATH = SCRIPT_DIR / "ILSVRC2012_devkit_t12/data/ILSVRC2012_validation_ground_truth.txt"
print(f"[debug] VAL_GROUND_TRUTH_FPATH: {VAL_GROUND_TRUTH_FPATH}")

val_gt_idx = VAL_GROUND_TRUTH_FPATH.read_text().splitlines()
val_gt_idx = list(map(int, val_gt_idx))

assert len(val_gt_idx) == 50000, "ERROR: len(val_gt_idx) != 50000"
assert tuple(set(val_gt_idx)) == tuple(range(1, 1001)), "ERROR: set(val_gt_idx) != set(range(1, 1001))"

VAL_DIR = Path("val")
VAL_IMGS_DIR = Path("val_imgs")

if VAL_IMGS_DIR.exists():
    raise Exception("ERROR: VAL_IMGS_DIR already exists!")

thereis_dir_in_val = any(f.is_dir() for f in VAL_DIR.iterdir())

if thereis_dir_in_val:
    raise Exception("ERROR: there is a directory in VAL_DIR!")

print("renaming val dir to val_imgs")
VAL_DIR.rename(VAL_IMGS_DIR)
VAL_DIR.mkdir()

val_image_fpaths = list(VAL_IMGS_DIR.glob("*.JPEG"))
assert len(val_image_fpaths) == 50000, f"ERROR: len(val_image_fpaths) = {len(val_image_fpaths)} != 50000"

print("creating synset folders")
synset_dirs = {}
for synset in mapping.values():
    synset_dirs[synset] = synset_dir = VAL_DIR / synset
    synset_dir.mkdir(exist_ok=True)
    
print("creating symlinks")
for gt_idx, fpath in zip(val_gt_idx, val_image_fpaths):
    synset = mapping[gt_idx]
    link = synset_dirs[synset] / fpath.name
    link.symlink_to(f"../../{VAL_IMGS_DIR.name}/{fpath.name}")

print("done")