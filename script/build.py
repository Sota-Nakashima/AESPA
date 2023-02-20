import sys
import pandas as pd
import os

OUTPUT_DIR = sys.argv[1]
SRR_TABLE_PATH = sys.argv[2]


#############################
#function
#############################
#sort organism by alphabet → extract each dataframe by organism
def make_SRR_list(df,DIR_PATH):
    organism_list = sorted(df["Organism"].unique())
    for i in organism_list:
        df_organism = df[df["Organism"] == i]
        ORGANISM_NAME = i.replace(' ','_')
        df_organism["Run"].to_csv(f"{DIR_PATH}/{ORGANISM_NAME}_SRR_list.txt",index=False,header=False)

def make_organism_list(df,DIR_PATH):
    #output organism list
    organism_list = sorted(df["Organism"].unique())
    #change blannk into underbar
    organism_series = pd.Series(organism_list)
    organism_series = organism_series.str.replace(" ","_")
    organism_series.to_csv(f"{DIR_PATH}/organism.txt",index=False,header=False)
#############################

#import dataframe
df_origin = pd.read_csv(SRR_TABLE_PATH)

#check nesessary columns
column_nesessary = ["Run","LibraryLayout","Organism"]
for i in column_nesessary:
    if not i in df_origin.columns:
        print(f"Need column {i}. Please add {i} in dataframe.")
        sys.exit(1)

#extract columns from dataframe
column_origin = ["Run","LibraryLayout","Organism","source_name","sex","TISSUE"]
column_cut = []

for i in column_origin:
    if i in df_origin.columns:
        column_cut.append(i)

df_cut = df_origin[column_cut]

#output whole dataframe
df_cut.to_csv(f"{OUTPUT_DIR}/dataframe.csv",index=False)

#devide dataframe into single and pair
df_cut_single = df_cut[df_cut["LibraryLayout"] == "SINGLE"]
df_cut_pair = df_cut[df_cut["LibraryLayout"] == "PAIRED"]

#single
if not df_cut_single.empty:
    #make directory
    DIR_PATH = f"{OUTPUT_DIR}/single"
    DIR_PATH_SRR = f"{DIR_PATH}/single_SRR_list"
    os.makedirs(DIR_PATH,exist_ok=True)
    os.makedirs(DIR_PATH_SRR,exist_ok=True)

    #output organism list
    make_organism_list(df_cut_single,DIR_PATH)

    #output SRR list
    make_SRR_list(df_cut_single,DIR_PATH_SRR)

if not df_cut_pair.empty:
    #output whole dataframe
    DIR_PATH = f"{OUTPUT_DIR}/pair"
    DIR_PATH_SRR = f"{DIR_PATH}/pair_SRR_list"
    os.makedirs(DIR_PATH,exist_ok=True)
    os.makedirs(DIR_PATH_SRR,exist_ok=True)

    #output organism list
    make_organism_list(df_cut_pair,DIR_PATH)

    #output SRR list
    make_SRR_list(df_cut_pair,DIR_PATH_SRR)