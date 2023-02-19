#!/bin/bash

readonly SCRIPT_NAME=${0##*/}
readonly VERSION=0.1.0

SCRIPT_DIR=$(cd $(dirname $0); pwd)
OUTPUT_DIR="./AESPA"

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

print_version()
{
    cat << END
AESPA build version $VERSION
END
}

print_help()
{
    cat << END
test version.
END
}

print_short_help()
{
    cat << END
test version.
END
}

while getopts :o:c:t:hV option
do
    case "$option" in
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        t)
            SRR_TABLE_PATH=$OPTARG
            SET_SRR_TABLE_PATH=true
            ;;
        c)
            CONDA_INIT_PATH=$OPTARG
            ;;
        h)
            print_help
            exit 0
            ;;
        V)
            print_version
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

if [[ "${SET_SRR_TABLE_PATH}" != "true" ]] ; then
    printf '%s\n\n' "${SCRIPT_NAME}: need more option" 1>&2
    print_short_help
    exit 1
fi

if [[ ! -e $SRR_TABLE_PATH ]] ; then
    printf '%s\n\n' "${SCRIPT_NAME}: options path is not exist." 1>&2
    print_short_help
    exit 1
fi

if [[ ! -e $CONDA_INIT_PATH ]] ; then
    printf '%s\n\n' "${SCRIPT_NAME}: you have to check CONDA_INIT_PATH. please use -c option." 1>&2
    print_short_help
    exit 1
fi

echo "..build mode.."