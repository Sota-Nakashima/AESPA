#!/bin/bash

readonly SCRIPT_NAME="AESPA run"
readonly VERSION=0.1.0

SCRIPT_DIR=$(cd $(dirname $0); pwd)
OUTPUT_DIR="./AESPA"
SSERAFIM_PATH="sserafim"
PALARREL=1
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
This command execute sserafim based on directory made by "aespa build" command.
Because you must execute "aespa build" command before "aespa build".

Example
    <Both pair-end and single-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-g SINGLE-END_REFERENCE_GENNOME_PATH_FILE] [-G PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR] 
    [-a SINGLE-END_ANNOTATION_PATH_FILE] [-A PAIR-END_ANNOTATION_PATH_FILE]

    <Only pair-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-G PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR] [-A PAIR-END_ANNOTATION_PATH_FILE]

    <Only single-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-g SINGLE-END_REFERENCE_GENNOME_PATH_FILE] [-a SINGLE-END_ANNOTATION_PATH_FILE]

OPTION
-o OUTPUT_DIR       set output directory(default: ./AESPA)
* Please set same directory you set when you executed "aespa build" command.

#########################################################
CAUTION : YOU HAVE TO SET THESE PARAMETERS DEPENDING ON YOUR SITUATION!!
>>better absolute path than relative path<<
#########################################################
SINGLE-END_REFERENCE_GENNOME_PATH_FILE (.txt)
SINGLE-END_ANNOTATION_PATH_FILE (.txt)
PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR (.txt)
PAIR-END_ANNOTATION_PATH_FILE (.txt)
#########################################################

-S SSERAFIM_PATH    sserafim path
-c CONDA_INIT_PATH  if printed error "you have to check ...",please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-@ PARALLEL (int)   set using CPU core(default: 1)
-h HELP             show help                 
-V VERSION          show version
END
}

print_short_help()
{
    cat << END
Example
    <Both pair-end and single-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-g SINGLE-END_REFERENCE_GENNOME_PATH_FILE] [-G PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR] 
    [-a SINGLE-END_ANNOTATION_PATH_FILE] [-A PAIR-END_ANNOTATION_PATH_FILE]

    <Only pair-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-G PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR] [-A PAIR-END_ANNOTATION_PATH_FILE]

    <Only single-end>
    aespa run [OPTION] [-o OUTPUT_DIR] [-@ PALARREL]
    [-g SINGLE-END_REFERENCE_GENNOME_PATH_FILE] [-a SINGLE-END_ANNOTATION_PATH_FILE]

OPTION
-o OUTPUT_DIR       set output directory(default: ./AESPA)
* Please set same directory you set when you executed "aespa build" command.

#########################################################
CAUTION : YOU HAVE TO SET THESE PARAMETERS DEPENDING ON YOUR SITUATION!!
>>better absolute path than relative path<<
#########################################################
SINGLE-END_REFERENCE_GENNOME_PATH_FILE (.txt)
SINGLE-END_ANNOTATION_PATH_FILE (.txt)
PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR (.txt)
PAIR-END_ANNOTATION_PATH_FILE (.txt)
#########################################################

-S SSERAFIM_PATH    sserafim path
-c CONDA_INIT_PATH  if printed error "you have to check ...",please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-@ PARALLEL (int)   set using CPU core(default: 1)
-h HELP             show help                 
-V VERSION          show version
END
}

count_number_of_lines()
{
    local lines=`cat $1 | wc -l`
    echo $lines
}

while getopts :o:c:a:A:g:G:S:@:hV option
do
    case "$option" in
        o)
            OUTPUT_DIR=$OPTARG
            ;;
        c)
            CONDA_INIT_PATH=$OPTARG
            ;;
        @)
            PALARREL=$OPTARG
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

    #check matching organism number and input file lines
    organism_number=`count_number_of_lines $OUTPUT_DIR/pair/organism.txt`

    if [[ $organism_number -ne `count_number_of_lines $GENNOME_PATH_FILE_PAIR` || \
        $organism_number -ne `count_number_of_lines $ANNOTATION_PATH_FILE_PAIR` ]] ; then
        echo "(pair-end) Don't match the number of lines between organism and input file." 1>&2
        echo "(pair-end) Please check forgetting inserting LF in a last line."
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

    #check matching organism number and input file lines
    organism_number=`count_number_of_lines $OUTPUT_DIR/single/organism.txt`

    if [[ $organism_number -ne `count_number_of_lines $GENNOME_PATH_FILE_SINGLE` || \
        $organism_number -ne `count_number_of_lines $ANNOTATION_PATH_FILE_SINGLE` ]] ; then
        echo "(single-end) Don't match the number of lines between organism and input file." 1>&2
        echo "(single-end) Please check forgetting inserting LF in a last line." 1>&2
        exit 1
    fi

fi

#create path set and core program

if [[ -d $OUTPUT_DIR/pair ]] ; then

    bash $SCRIPT_DIR/create_path_df.sh $CONDA_INIT_PATH $OUTPUT_DIR/pair $SCRIPT_DIR $GENNOME_PATH_FILE_PAIR $ANNOTATION_PATH_FILE_PAIR
    
    #change IFS and input sra quary
    IFS=$'\n'
    file=(`cat "$OUTPUT_DIR/.aespa"`)
    #return IFS default
    IFS=$' \t\n'

    #sserafim
    echo "running sserafim..."
    for line in "${file[@]}"; do
        args=($line) 
        "$SSERAFIM_PATH" -o "$OUTPUT_DIR/pair/${args[0]}" -a "${args[2]}" -g "${args[1]}" \
        -s "${args[3]}" -@ $PALARREL -c $CONDA_INIT_PATH -P  
        if [ $? -ne 0 ]; then
            echo "sserafim encountered error. Please check \"{ORGASIM_NAME}/report.log\"." 1>&2
            exit 1
        fi
    done

    #remove unessesary file
    if [ $? -eq 0 ]; then
        rm -rf $OUTPUT_DIR/pair/SRR_list $OUTPUT_DIR/pair/organism.txt
        echo "pair-end was successful."
    fi
fi


if [[ -d $OUTPUT_DIR/single ]] ; then

    bash $SCRIPT_DIR/create_path_df.sh $CONDA_INIT_PATH $OUTPUT_DIR/single $SCRIPT_DIR $GENNOME_PATH_FILE_SINGLE $ANNOTATION_PATH_FILE_SINGLE

    #change IFS and input sra quary
    IFS=$'\n'
    file=(`cat "$OUTPUT_DIR/.aespa"`)
    #return IFS default
    IFS=$' \t\n'

    for line in "${file[@]}"; do
        args=($line)
        "$SSERAFIM_PATH" -o "$OUTPUT_DIR/single/${args[0]}" -a "${args[2]}" -g "${args[1]}" \
        -s "${args[3]}" -@ $PALARREL -c $CONDA_INIT_PATH
        if [ $? -ne 0 ]; then
            echo "sserafim encountered error. Please check \"{ORGASIM_NAME}/report.log\"." 1>&2
            exit 1
        fi
    done

    #remove unessesary file
    if [ $? -eq 0 ]; then
        rm -rf $OUTPUT_DIR/single/SRR_list $OUTPUT_DIR/single/organism.txt
        echo "single-end was successful."
    fi
fi