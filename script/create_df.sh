#!/bin/bash

CONDA_INIT_PATH=$1
SCRIPT_DIR=$2
OUTPUT_DIR=$3
SRR_TABLE_PATH=$4

source $CONDA_INIT_PATH

conda activate bio

python -B $SCRIPT_DIR/create_df.py $OUTPUT_DIR $SRR_TABLE_PATH

if [ $? -ne 0 ]; then
exit 1
fi