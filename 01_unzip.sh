#!/usr/bin/env bash
set -e  # stops the execution of a script if a command or pipeline has an

function get_this_script_dir() {
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    SCRIPT_DIR=$(realpath $SCRIPT_DIR)
}

get_this_script_dir
echo "[debug] SCRIPT_DIR=${SCRIPT_DIR}"

cd ${SCRIPT_DIR}
echo "[debug] pwd=$(pwd)"

TARGZ_train="ILSVRC2012_img_train.tar"  
TARGZ_val="ILSVRC2012_img_val.tar"  
TARGZ_test="ILSVRC2012_img_test_v10102019.tar"
TARGZ_devkit_t12="ILSVRC2012_devkit_t12.tar.gz"

SPLIT=$1
echo "[debug] SPLIT=${SPLIT}"

if [ -d ${SPLIT} ]; then
    echo "[debug] folder '${SPLIT}' already exists"
    exit 0
fi


if [ "$SPLIT" == "train" ]; then
    TARGZ=$TARGZ_train
    EXTRACT_DIR="-C train"
    echo "Expected number of files: 1,000 tar.gz, which combined have 1,281,167 images"

elif [ "$SPLIT" == "val" ]; then
    TARGZ=$TARGZ_val
    EXTRACT_DIR="-C val"
    echo "Expected number of files: 50,000 images"

elif [ "$SPLIT" == "test" ]; then
    TARGZ=$TARGZ_test
    EXTRACT_DIR=""
    echo "Expected number of files: 100,000 images"

elif [ "$SPLIT" == "devkit" ]; then
    TARGZ=$TARGZ_devkit_t12
    EXTRACT_DIR="-C ."

else
    echo "ERROR: unknown SPLIT=${SPLIT}"
    echo "please choose one of the following: train, val, test, devkit"
    exit 1
fi

echo "[debug] TARGZ=${TARGZ}"
echo "[debug] EXTRACT_DIR=${EXTRACT_DIR}"

if [ $SPLIT == "devkit" ]; then
    echo "unziping devkit"
    tar -xf ${TARGZ} ${EXTRACT_DIR}
    echo "done"
    exit 
fi

mkdir -p ${SPLIT}

echo "unzipping the tar.gz"
tar -xf ${TARGZ} ${EXTRACT_DIR}

if [ "$SPLIT" == "train" ]; then
    echo "unzipping the train tar.gz files"

    cd train
    echo "[debug] pwd=$(pwd)"

    echo "number of tar.gz to unzip"
    ls -1 *.tar | wc -l

    for f in *.tar; do
        echo "unzipping $f"
        SYNSET="${f%.*}"
        mkdir -p ${SYNSET}
        tar -xf "$f" -C ${SYNSET}  # -C: extract files to the with same name as the tar file
        rm "$f"
    done

    echo "number of images"
    find . -maxdepth 2 -type f | grep JPEG |  wc -l

    cd ..
    echo "[debug] pwd=$(pwd)"

else
    echo "number of images"
    ls -l ${SPLIT} | grep JPEG | wc -l
fi

