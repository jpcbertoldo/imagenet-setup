# ImageNet [1]

**Be careful** with the link bellow! If you are not logged in imagenet's website it will send you to the wrong page (version 2010) after the login.

src: [https://image-net.org/challenges/LSVRC/2017/2017-downloads.php](https://image-net.org/challenges/LSVRC/2017/2017-downloads.php)

src: [https://image-net.org/challenges/LSVRC/2012/2012-downloads.php](https://image-net.org/challenges/LSVRC/2012/2012-downloads.php)

## IMPORTANT DISCLAIMER 1

```text
Terms of use: by downloading the image data from the above URLs, you agree to the following terms:

You will use the data only for non-commercial research and educational purposes.
You will NOT distribute the above URL(s).
Stanford University and Princeton University and UNC Chapel Hill and MIT make no representations or warranties regarding the data, including but not limited to warranties of non-infringement or fitness for a particular purpose.
You accept full responsibility for your use of the data and shall defend and indemnify Stanford University and Princeton University and UNC Chapel Hill and MIT, including their employees, officers and agents, against any and all claims arising from your use of the data, including but not limited to your use of any copies of copyrighted images that you may create from the data.
```

## IMPORTANT DISCLAIMER 2

Some info below come from the devkit of 2017 but the data is from 2012.

---

## Download & extract

Prerequirements: just try to run the stuff and you will figure out as it breaks.

To download and extract the images in here, use the scripts (in the following order):

- `00_download.sh` (call it with four arguments: `train`, `val`, `test`, `devkit`);
- `01_unzip.sh` (call it with four arguments: `train`, `val`, `test`, `devkit`);
- `02_convert_meta_clsloc.py`;
- `03_build_val_class_folders.py`.

Example:

```bash
./download.sh val
./01_unzip.sh val
python 02_convert_meta_clsloc.py
python 03_build_val_class_folders.py
```

## Minimal documentation

Synset: a set of synonymous nouns in WordNet; i.e. a category, or class, in the image clssification problem.

The split `train` has 1,000 folders, which are named with the id of the synset in WordNet and contain their respective images.

The splits `val` and `test` have images in their directories.

Number of images:

- `train`: 1,281,167 (between 732 and 1300 per synset)
- `val`: 50,000 (50 per synset)
- `test`: 100,000 (100 per synset)

The script `download.sh` will not work by default because the URLS are missing (they should not be distributed).

You should create a file `urls.sh` and define the variables below containing their respective urls from imagenet's website:

- `DOWNLOAD_URL_train`;
- `DOWNLOAD_URL_val`;
- `DOWNLOAD_URL_test`;
- `DOWNLOAD_URL_devkit_t12`.

---

## Documentation

Below is **a modified version** the documentation of the `ILSVRC2016 Competitions Development Kit`.

ILSVRC201**7** is almost the same as ILSVRC201**6**, with some small changes.

There are five tasks covered in the original dataset, but this directory only covers "Object classification/localization (CLS-LOC)" (which is unchanged since ILSVRC201**2**), and the documentation was modified to only cover its relevant information.

Link to the page where I got it: [https://image-net.org/challenges/LSVRC/2017/2017-downloads.php](https://image-net.org/challenges/LSVRC/2017/2017-downloads.php)

Table of contents:

  1. Overview

  2. Classification and localization (CLS-LOC) details
    2.1 Object categories
    2.2 Images and annotations
    2.3 Submission format

Obs: Section `2.3` is not so necessary.

`ilsvrc@image-net.org` for questions, comments, or bug reports.

### 1. Overview

There are three sets of images and labels: training data, validation data, and test data.

There is no overlap between the three sets.

```text
                 Number of images

    Dataset      TRAIN      VALIDATION     TEST
    -------------------------------------------------
    CLS-LOC     1281167       50000       100000
```

Every image is collected using queries for a particular synset, focusing on single-object images.

There are 1000 object categories annotated.

Generally, the object categories tend to be fine-grained classes, e.g. different dog breeds.

Each annotated object category corresponds 1-1 to a synset (set of synonymous nouns) in WordNet.

There is no overlap between synsets: for any pair of synsets i and j in the dataset, i not an ancestor of j in the WordNet hierarchy.

Labels: every image in training, validation and test sets has a single image-level label specifying the presence of one object category.

Statistics:

  Training: 1,281,167 images, with between 732 and 1300 per synset.

  Validation: 50000 images, at 50 images per category.

  Test: 100000 images, at 100 images per category.

All images and bounding box annotations are packed in a single tar file.

All images are in JPEG format.

### 2. CLS-LOC details

The 1000 synsets in the dataset are part of the larger ImageNet hierarchy and we can consider the subset of ImageNet containing these low level synsets.

All information on the synsets is in the 'synsets' array in

  data/meta_clsloc.mat

This file is the same as in ILSVRC2012/13 devkits except the id field was renamed to `ILSVRC2015_CLSLOC_ID`.

To access this data in Matlab, type

  load data/meta_clsloc.mat;
  synsets

and you will see

   synsets =

   1x1000 struct array with fields:
       ILSVRC2015_CLSLOC_ID
       WNID
       name
       description
       num_train_images

Each entry in the struct array corresponds to a synset, i, and contains fields:

- `ILSVRC2015_CLSLOC_ID`: integer ID assigned to each synset. The synsets are sorted by `ILSVRC2015_CLSLOC_ID`.

- `WNID`: WordNet ID of a synset; uniquely identifies a synset in ImageNet or WordNet; used as (1) the file name of train image `tar.gz` files, their respective (decompressed) folders, and the object name in xml annotations.

#### 2.1 Images and annotations

##### 2.1.1 Training data

Each image is considered as belonging to a particular synset X.

This image is then guaranteed to contain an X.

See [2] for more details of the collection and labeling strategy.

The CLS-LOC training images may be downloaded as a single tar archive.

Within it there is a tar file for each synset, named by its `WNID`.

The image files are named as `x_y.JPEG`, where `x` is the `WNID` and `y` is an integer (not fixed width and not necessarily consecutive).

All images are in JPEG format.

The ground truth class of the training images can be deduced from their parent folder/tar.gz.

##### 2.1.2 Validation data

There are 50,000 validation images.

There are 50 validation images for each synset.

They are named as

```text
      ILSVRC2012_val_00000001.JPEG
      ILSVRC2012_val_00000002.JPEG
      ...
      ILSVRC2012_val_00049999.JPEG
      ILSVRC2012_val_00050000.JPEG
```

The classification ground truth of the validation images is in `data/ILSVRC2015_clsloc_validation_ground_truth.txt`.

Each line contains one `ILSVRC2015_ID` for one image, in the ascending alphabetical order of the image file names.

Notes:

1. `data/ILSVRC2015_clsloc_validation_ground_truth.txt` is unchanged since ILSVRC2012.
2. As in ILSVRC2012 and 2013, 1762 images (3.5%) in the validation set are discarded due to unsatisfactory quality of bounding boxes annotations. The indices to these images are listed in `data/ILSVRC2015_clsloc_validation_blacklist.txt`. The evaluation script automatically excludes these images. A similar percentage of images are discarded for the test set.

##### 2.1.3 Test data

There are 100,000 test images.

There are 100 test images for each synset.

**The ground truth annotations will not be released.**

The test files are named as

```text
      ILSVRC2012_test_00000001.JPEG
      ILSVRC2012_test_00000002.JPEG
      ...
      ILSVRC2012_test_00099999.JPEG
      ILSVRC2012_test_00100000.JPEG
```

#### 2.2 Submission format

I kept this section here for the sake of the readers culture, but it's probably unimportant now that the challenge is over so **feel free to skip this secion!**

##### 2.2.1 2017 version

**Disclaimer**: the 2017 version only talks about the submission including the localization so I included an extract from the documentation of the 2012 version (next subsection), where they talk about the submission of classification only.

The submission of results on test data will consist of a text file with one line per image, in the alphabetical order of the image file names, i.e. from `ILSVRC2012_test_00000001.JPEG` to `ILSVRC2012_test_0100000.JPEG`.

Each line contains up to 5 detected objects, sorted by confidence in descending order.

The format (**FOR LOCALIZATION!**) is as follows:

```text
    <label(1)> <xmin(1)> <ymin(1)> <xmax(1)> <ymax(1)> <label(2)> <xmin(2)> <ymin(2)> <xmax(2)> <ymax(2)> ....
```

The predicted labels are the `ILSVRC2015_IDs` (integers between 1 and 1000).  

The number of labels per line can vary, but not more than 5 (extra labels are ignored).

Example file on the validation data is `evaluation/demo.val.pred.loc.txt`:

```text
...
43 336 86 588 438 885 309 10 551 349 482 65 80 314 428 842 56 42 224 276 771 65 185 207 384 
...
```

##### 2.2.2 2012 version

For task 1 (classification), submission of results on test data will consist of a text file with one line per image, in the alphabetical order of the image file names, i.e. from `ILSVRC2012_test_00000001.JPEG` to `ILSVRC2012_test_0100000.JPEG`.

Each line contains the predicted labels, i.e. the `ILSVRC2012_IDs` (an integer between 1 and 1000) of the predicted categories, sorted by confidence in descending order.

The number of labels per line can vary but must be no more than 5.

## References

[1] Olga Russakovsky*, Jia Deng*, Hao Su, Jonathan Krause, Sanjeev Satheesh, Sean Ma, Zhiheng Huang, Andrej Karpathy, Aditya Khosla, Michael Bernstein, Alexander C. Berg and Li Fei-Fei. (* = equal contribution) ImageNet Large Scale Visual Recognition Challenge. arXiv:1409.0575, 2014.

```bibtex
@article{ILSVRC15,
    Author = {Olga Russakovsky and Jia Deng and Hao Su and Jonathan Krause and Sanjeev Satheesh and Sean Ma and Zhiheng Huang and Andrej Karpathy and Aditya Khosla and Michael Bernstein and Alexander C. Berg and Li Fei-Fei},
    Title = {{ImageNet Large Scale Visual Recognition Challenge}},
    Year = {2015},
    journal   = {International Journal of Computer Vision (IJCV)},
    doi = {10.1007/s11263-015-0816-y},
    volume={115},
    number={3},
    pages={211-252}
}
```

[2] J. Deng, W. Dong, R. Socher, L.-J. Li, K. Li and L. Fei-Fei, ImageNet: A Large-Scale Hierarchical Image Database. IEEE Computer Vision and Pattern Recognition (CVPR), 2009.
