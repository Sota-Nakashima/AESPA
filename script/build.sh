#!/bin/bash

# get conda init path
###################################
conda_path=`which conda`
conda_path_array=(${conda_path//\// })
list_number=$((${#conda_path_array[*]}-3))
for S in $(seq 0 $list_number); do
    CONDA_INIT_PATH+="/${conda_path_array[$S]}"
done

CONDA_INIT_PATH+="/etc/profile.d/conda.sh"

###################################

while getopts :c:hV option
do
    case "$option" in
        c)
            CONDA_INIT_PATH=$OPTARG
            echo $CONDA_INIT_PATH
            ;;
        h)
            echo "help"
            exit 0
            ;;
        V)
            echo "need"
            exit 0
            ;;
        :)
            print_error "option requires an argument -- '$OPTARG'"
            exit 1
            ;;
        \?)
            print_error "unrecognized option -- '$OPTARG'"
            exit 1
            ;;
    esac
done