#!/bin/bash

readonly SCRIPT_NAME="AESPA run"
readonly VERSION=0.1.0

SCRIPT_DIR=$(cd $(dirname $0); pwd)
OUTPUT_DIR="./AESPA"
SSERAFIM_PATH="sserafim"
SET_ANNOTATION_PATH_FILE_SINGLE=false
SET_ANNOTATION_PATH_FILE_PAIR=false
SET_GENNOME_PATH_FILE_SINGLE=false
SET_GENNOME_PATH_FILE_PAIR=false

# get conda init path and activate env
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
${SCRIPT_NAME} version $VERSION
END
}

print_help()
{
    cat << END
This command build parent directory from file.
File can be install from SRA Run Selector. 
https://0-www-ncbi-nlm-nih-gov.brum.beds.ac.uk/Traces/study/

Example
    aespa build [OPTION] [-t SRR_TABLE_PATH] [-o OUTPUT_DIR]

OPTION
-o OUTPUT_DIR       set output directory(default: ./AESPA)

#########################################################
CAUTION : YOU HAVE TO SET THESE PARAMETERS ABSOLUTELY!!
>>better absolute path than relative path<<
#########################################################
-t SRR_TABLE_PATH (.txt)
#########################################################


-c CONDA_INIT_PATH  if printed error "you have to check ...",please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-h HELP             show help                 
-V VERSION          show version
END
}

print_short_help()
{
    cat << END
Example
    aespa build [OPTION] [-t SRR_TABLE_PATH] [-o OUTPUT_DIR]

OPTION
-o OUTPUT_DIR       set output directory(default: ./AESPA)

#########################################################
CAUTION : YOU HAVE TO SET THESE PARAMETERS ABSOLUTELY!!
>>better absolute path than relative path<<
#########################################################
-t SRR_TABLE_PATH (.txt)
#########################################################


-c CONDA_INIT_PATH  if printed error "you have to check ...",please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-h HELP             show help                 
-V VERSION          show version
END
}

while getopts :o:c:a:A:g:G:S:hV option
do
    case "$option" in
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        c)
            CONDA_INIT_PATH=$OPTARG
            ;;
        a)
            ANNOTATION_PATH_FILE_SINGLE=$OPTARG
            SET_ANNOTATION_PATH_FILE_SINGLE=true
            ;;
        A)
            ANNOTATION_PATH_FILE_PAIR=$OPTARG
            SET_ANNOTATION_PATH_FILE_PAIR=true
            ;;
        g)
            GENNOME_PATH_FILE_SINGLE=$OPTARG
            SET_GENNOME_PATH_FILE_SINGLE=true
            ;;
        G)
            GENNOME_PATH_FILE_PAIR=$OPTARG
            SET_GENNOME_PATH_FILE_PAIR=true
            ;;
        S)
            SSERAFIM_PATH=$OPTARG
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

#check conda path
if [[ ! -e $CONDA_INIT_PATH ]] ; then
    printf '%s\n\n' "${SCRIPT_NAME}: you have to check CONDA_INIT_PATH. please use -c option." 1>&2
    print_short_help
    exit 1
fi

#check command SSERAFIM
if type "$SSERAFIM_PATH" > /dev/null 2>&1; then
    echo "Confirmed SSERAFIM..." 
else
    echo "Not exist SSERAFIM. Please install and add path or use -S option." 1>&2
    exit 1
fi

#check "aespa build" command
if [[ ! -f $OUTPUT_DIR/.aespa ]] ; then
    echo "Did you do \"aespa build\"?" 1>&2
    exit 1    
fi

if [[ -d $OUTPUT_DIR/pair ]] ; then

    #check option
    if [[ "${SET_ANNOTATION_PATH_FILE_PAIR}" != "true" || "${SET_GENNOME_PATH_FILE_PAIR}" != "true" ]] ; then
        printf '%s\n\n' "${SCRIPT_NAME}: need more option" 1>&2
        print_short_help
        exit 1
    fi
    #check path exist
    if [[ ! -e $ANNOTATION_PATH_FILE_PAIR || ! -e $GENNOME_PATH_FILE_PAIR ]] ; then
        printf '%s\n\n' "${SCRIPT_NAME}: options path is not exist." 1>&2
        print_short_help
        exit 1
    fi

fi

if [[ -d $OUTPUT_DIR/single ]] ; then

    #check option
    if [[ "${SET_ANNOTATION_PATH_FILE_SINGLE}" != "true" || "${SET_GENNOME_PATH_FILE_SINGLE}" != "true" ]] ; then
        printf '%s\n\n' "${SCRIPT_NAME}: need more option" 1>&2
        print_short_help
        exit 1
    fi
    #check path exist
    if [[ ! -e $ANNOTATION_PATH_FILE_SINGLE || ! -e $GENNOME_PATH_FILE_SINGLE ]] ; then
        printf '%s\n\n' "${SCRIPT_NAME}: options path is not exist." 1>&2
        print_short_help
        exit 1
    fi

fi

