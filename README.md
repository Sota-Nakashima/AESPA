AESPA
====
[![Version](https://img.shields.io/badge/stable-main-gree)](https://github.com/Sota-Nakashima/AESPA)
[![Version](https://img.shields.io/badge/OS-Linux-gree)](https://github.com/Sota-Nakashima/AESPA)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](https://github.com/Sota-Nakashima/AESPA/blob/main/LICENCE)
#  Overview
AESPA is a SSERAFIM wrapper tool.  
AESPA makes AESPA support multiple spicies.  

|    | SSERAFIM only | AESPA & SSEARFIM |
| :----: | :----: | :----: |
| single spicies  |  ○  |  ○  | 
| multiple spicies |  ×  |  ○  | 

## Description
This tool simplifies and automates the workflow of gene expression analysis.
It estimates the expression level of each gene based on the SRR-List downloaded from [SRA](https://www.ncbi.nlm.nih.gov/sra), reference genome, and annotation data. SSERAFIM could only analyze one species at a time, but when combined with AESPA, multiple species can be analyzed simultaneously.
## Demo
1. Prepare SRR-List, Reference Genome, and Annotation Data  
   - SRR List can be download from [SRA Run Selector](https://0-www-ncbi-nlm-nih-gov.brum.beds.ac.uk/Traces/study/)   
   ![img](https://github.com/Sota-Nakashima/SSERAFIM/blob/images/SRR_TABLE.png)  
   - Reference Genome can be download from [Ensemble](http://asia.ensembl.org/index.html)  
   - Annotation Data can be download from [Ensemble](http://asia.ensembl.org/index.html)

   Of course, you can use the file format from other sites as long as the file formats match. However, please make sure that the chromosome information match between the Reference Genome and the Annotation Data.

2. Run AESPA in build mode
   ```bash:build.sh
   aespa build -t ~/SraRunTable.txt
   ```

3. Confirm result and prepare reference genome path file and annotaion path file following console output.  
   
   Output example:
   ```
   PAIR-END

   *organism*
   Homo_sapiens

   Please prepare each absolute path list (.txt) of these reference genomes (.fasta) and anotations (.gtf).
   Use -g and -a option.

   SINGLE-END

   *organism*
   Gallus_gallus
   Gorilla_gorilla
   Homo_sapiens
   Macaca_mulatta
   Monodelphis_domestica
   Mus_musculus
   Ornithorhynchus_anatinus
   Xenopus_tropicalis

   Please prepare each absolute path list (.txt) of these reference genomes (.fasta) and anotations (.gtf).
   Use -G and -A option.
   ```
4. Run AESPA in run mode
   ```bash:run.sh
   aespa run -g ~/refernece_single_path.txt -G ~/refernece_pair_path.txt -a ~/annotaion_pair_path.txt -A ~/refernce_pair_path.txt -@ 20 -L
   ```
   This process is a little more complicated. If you are not sure, see [example file](https://github.com/Sota-Nakashima/AESPA/tree/sample/example_file).
## Requirement
AESPA works on conda, [conda-forge](https://github.com/conda-forge) and [bioconda](https://github.com/bioconda).  

AESPA depends on [SSERAFIM](https://github.com/Sota-Nakashima/SSERAFIM). Please install it at the same time when you use [AESPA](https://github.com/Sota-Nakashima/AESPA).

## Usage
<span style="color: yellow; ">build mode</span>
```bash:usage.sh
aespa build [OPTION] [-t SRR_TABLE_PATH] [-o OUTPUT_DIR]
```
```
Mandatory arguments
-t SRR_TABLE_PATH (.txt) 

Default arguments
-o OUTPUT_DIR       Set output directory(default: ./AESPA)
-c CONDA_INIT_PATH  If SSERAFIM printed error "you have to check ...", please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-h HELP             Show help                 
-V VERSION          Show version
```

<span style="color: yellow; ">run mode</span>
```
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
```
```
Mandatory arguments
-g SINGLE-END_REFERENCE_GENNOME_PATH_FILE (.txt)
-a SINGLE-END_ANNOTATION_PATH_FILE (.txt)
-G PAIR_END_REFERENCE_GENNOME_PATH_FILE_PAIR (.txt)
-A PAIR-END_ANNOTATION_PATH_FILE (.txt)

Default arguments
-o OUTPUT_DIR       Set output directory(default: ./AESPA)
-S SSERAFIM_PATH    Sserafim path
-c CONDA_INIT_PATH  If printed error "you have to check ...",please reset path.
                    "~/{YOUR CONDA PACKAGE}/etc/profile.d/conda.sh"
-@ PARALLEL (int)   Set using CPU core(default: 1)
-L LIGHT_MODE       Don't make law_data.tar.gz
-h HELP             Show help                 
-V VERSION          Show version
```

## Output
```
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
```
## Install
- Create virtual environment in conda.  
  AESPA can run the same environment to SSERAFIM. Please show [SSERSFIM](https://github.com/Sota-Nakashima/SSERAFIM).
- Use docker  
  Please see [this page](https://github.com/Sota-Nakashima/SEERAFIM_AESPA_docker).

## Benchmark
Still getting ready
## Acknowledgements
[Evolutionary Genetics Lab](http://www.biology.kyushu-u.ac.jp/~kteshima/), [Kyushu Univ.](https://www.kyushu-u.ac.jp/en/)
## Licence

[MIT](https://github.com/Sota-Nakashima/SSERAFIM/blob/main/LICENCE)

## Author

[Sota Nakashima](https://github.com/Sota-Nakashima)