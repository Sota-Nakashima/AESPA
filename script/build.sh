#!/bin/bash

readonly SCRIPT_NAME="AESPA build"
readonly VERSION=0.1.0

SCRIPT_DIR=$(cd $(dirname $0); pwd)
OUTPUT_DIR="./AESPA"

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

##################
RESULT_DIRECTORY
##################
OUTPUT_DIR
│
├─── dataframe.csv
├─── pair
│       ├─── organism.txt
│       └─── single_SRR_List
│               ├─── organism1
│               ├─── organism2
│               │       :
│       
└─── single
        ├─── organism.txt
        └─── single_SRR_List
                ├─── organism1
                ├─── organism2
                │       :
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

#confirm path, directory exist
####################################
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

if [[ -d "$OUTPUT_DIR" ]] ; then
printf '%s\n' "${SCRIPT_NAME}: the same directory is already exist." 1>&2
exit 1
fi
####################################
echo "..build mode.."

#make parent directory
mkdir -p "$OUTPUT_DIR"


#core program

bash $SCRIPT_DIR/create_df.sh $CONDA_INIT_PATH $SCRIPT_DIR $OUTPUT_DIR $SRR_TABLE_PATH

if [ $? -ne 0 ]; then
rm -rf $OUTPUT_DIR
exit 1
fi

#make tag file
touch $OUTPUT_DIR/.aespa
chmod 755 $OUTPUT_DIR/.aespa

if [[ -d $OUTPUT_DIR/pair ]] ; then
    printf '\n\033[31m%s\033[m\n' 'PAIR-END'
    printf '\n%s\n' "*organism*"
    cat $OUTPUT_DIR/pair/organism.txt
    printf '\n%s\033[33m%s\033[m%s\n%s\n' \
    "Please prepare" " each absolute path list" " (.txt) of these reference genomes (.fasta) and anotations (.gtf)." \
    "Use -g and -a option."
fi
if [[ -d $OUTPUT_DIR/single ]] ; then
    printf '\n\033[31m%s\033[m\n' 'SINGLE-END'
    printf '\n%s\n' "*organism*"
    cat $OUTPUT_DIR/single/organism.txt
    printf '\n%s\033[33m%s\033[m%s\n%s\n' \
    "Please prepare" " each absolute path list " "(.txt) of these reference genomes (.fasta) and anotations (.gtf)." \
    "Use -G and -A option."
fi