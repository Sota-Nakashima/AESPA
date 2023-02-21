#import library
import sys
import pandas as pd
import glob
import pathlib

def convert_relative2absolute(PATH):
    p = pathlib.Path(PATH)
    return str(p.resolve())

#get argument
OUTPUT_DIR = sys.argv[1]
OUTPUT_DIR_PARENT = OUTPUT_DIR.rsplit('/',1)[0]
GENNOME_PATH_FILE = sys.argv[2]
ANNOTATION_PATH_FILE = sys.argv[3]

#get SRR_List_absolute_path
SRR_list = glob.glob(f'{OUTPUT_DIR}/SRR_list/*')
SRR_list = list(map(convert_relative2absolute,SRR_list))

#import dataframe
organism_series = pd.read_csv(f'{OUTPUT_DIR}/organism.txt', header = None)
genome_series = pd.read_csv(GENNOME_PATH_FILE, header = None)
annotation_series = pd.read_csv(ANNOTATION_PATH_FILE, header = None)
SRR_list_series = pd.Series(SRR_list)

whole_df = pd.concat([organism_series,genome_series,annotation_series,SRR_list_series],axis=1)

whole_df.to_csv(f'{OUTPUT_DIR_PARENT}/.aespa',sep=' ',header=None,index=None)