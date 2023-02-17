#!/bin/bash

CONDA_INIT_PATH="$1"
OUTPUT_DIR="$2"
SCRIPT_DIR="$3"
SRR_TABLE_PATH="$4"

source $CONDA_INIT_PATH
conda activate bio

python -B $SCRIPT_DIR/script/build.py $OUTPUT_DIR $SRR_TABLE_PATH 