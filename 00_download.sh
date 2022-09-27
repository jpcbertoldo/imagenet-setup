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

URLS_FNAME="urls.sh"

if [ ! -f ${URLS_FNAME} ]; then
    echo "[error] ${URLS_FNAME} does not exist"
    echo "please create a file named ${URLS_FNAME} in the current directory ($(pwd)) and add the following variables to it:"
    echo "DOWNLOAD_URL_train"
    echo "DOWNLOAD_URL_val"
    echo "DOWNLOAD_URL_test"
    echo "DOWNLOAD_URL_devkit_t12"
    echo "you will find them at image-net.org"
    echo "you should specifically go to"
    echo "https://image-net.org/challenges/LSVRC/2012/2012-downloads.php"
    exit 1
fi

source ${URLS_FNAME}

MD5_train="1d675b47d978889d74fa0da5fadfb00e"
MD5_val="29b22e2961454d5413ddabcf34fc5622"
MD5_test="e1b8681fff3d63731c599df9b4b6fc02"

SPLIT=$1
echo "[debug] SPLIT=${SPLIT}"

if [ "$SPLIT" == "train" ]; then
    DOWNLOAD_URL=$DOWNLOAD_URL_train
    MD5=$MD5_train

elif [ "$SPLIT" == "val" ]; then
    DOWNLOAD_URL=$DOWNLOAD_URL_val
    MD5=$MD5_val

elif [ "$SPLIT" == "test" ]; then
    DOWNLOAD_URL=$DOWNLOAD_URL_test
    MD5=$MD5_test

elif [ "$SPLIT" == "devkit" ]; then
    DOWNLOAD_URL=$DOWNLOAD_URL_devkit_t12

else
    echo "ERROR: unknown split"
    echo "please choose one of the following: train, val, test, devkit"
    exit 1
fi

if [ -d ${SPLIT} ]; then
    echo "[debug] folder '${SPLIT}' already exists"
    exit 0
fi

echo "[debug] DOWNLOAD_URL=${DOWNLOAD_URL}"
echo "[debug] MD5=${MD5}"

TARGZ_FNAME=${DOWNLOAD_URL##*/}
echo "[debug] TARGZ_FNAME=${TARGZ_FNAME}"

if [ -f ${TARGZ_FNAME} ]; then
    echo "[debug] file '${TARGZ_FNAME}' already exists"
    exit 0
fi

echo "downloading the tar.gz"
wget ${DOWNLOAD_URL}

if [ $SPLIT == "devkit" ] ; then
    exit 0
fi

md5sum -c <<< "${MD5}  ${TARGZ_FNAME}"

