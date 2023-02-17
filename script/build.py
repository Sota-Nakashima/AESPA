import sys
import pandas as pd
import os

OUTPUT_DIR = sys.argv[1]
SRR_TABLE_PATH = sys.argv[2]


#############################
#library
#############################
def make_SRR_list(df,DIR_PATH):
    organism_list = sorted(df["Organism"].unique())
    for i in organism_list:
        df_organism = df[df["Organism"] == i]
        ORGANISM_NAME = i.replace(' ','_')
        df_organism["Run"].to_csv(f"{DIR_PATH}/{ORGANISM_NAME}_SRR_list.txt",index=False,header=False)
#############################

df_origin = pd.read_csv(SRR_TABLE_PATH)

column_origin = ["Run","LibraryLayout","Organism","source_name","sex","TISSUE"]
column_cut = []

for i in column_origin:
    if i in df_origin.columns:
        column_cut.append(i)

df_cut = df_origin[column_cut]

df_cut_single = df_cut[df_cut["LibraryLayout"] == "SINGLE"]
df_cut_pair = df_cut[df_cut["LibraryLayout"] == "PAIRED"]

if not df_cut_single.empty:
    DIR_PATH = f"{OUTPUT_DIR}/single"
    DIR_PATH_SRR = f"{DIR_PATH}/single_SRR_list"
    os.makedirs(DIR_PATH,exist_ok=True)
    os.makedirs(DIR_PATH_SRR,exist_ok=True)
    df_cut_single.to_csv(f"{DIR_PATH}/dataframe.csv",index=False)

    organism_list = sorted(df_cut_single["Organism"].unique())
    organism_series = pd.Series(organism_list)
    organism_series.to_csv(f"{DIR_PATH}/organism.txt",index=False,header=False)
    make_SRR_list(df_cut_single,DIR_PATH_SRR)

if not df_cut_pair.empty:
    DIR_PATH = f"{OUTPUT_DIR}/pair"
    DIR_PATH_SRR = f"{DIR_PATH}/pair_SRR_list"
    os.makedirs(DIR_PATH,exist_ok=True)
    os.makedirs(DIR_PATH_SRR,exist_ok=True)
    df_cut_pair.to_csv(f"{DIR_PATH}/dataframe.csv",index=False)
    
    organism_list = sorted(df_cut_pair["Organism"].unique())
    make_SRR_list(df_cut_pair,DIR_PATH_SRR)





