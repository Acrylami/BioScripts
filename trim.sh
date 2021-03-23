#!/bin/bash
#author: Peter Kille
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH --error="/mnt/scratch/c1803625/logs/%J.err"
#SBATCH --output="/mnt/scratch/c1803625/logs/%J.out"

module load fastp/v0.20

#core sample name no direction or fastq.gz
raw="ERR4971212"

##Set up the filepaths and names
#User directory
dir="/mnt/scratch/c1803625"
#Input folder
input="downloaded"
#output folder
out="trimming"
#reports folder
report="reports"

#Filepaths
outpath="${dir}/${out}/new_${raw}"
filepath="${dir}/${input}/${raw}"
reportpath="${dir}/${report}/${raw}/${raw}"


#input file name
out_dir="/mnt/scratch/c1803625/trimming"

fastp -i "${filepath}_1.fastq.gz" -I "${filepath}_2.fastq.gz" -o "${outpath}_1_trim.fastq.gz" -O "${outpath}_2_trim.fastq.gz" -w ${SLURM_NTASKS}

fastqc -t 4 "${reportpath}_1.fastq.gz" "${reportpath}_2.fastq.gz" "${reportpath}_1_trim.fastq.gz" "${reportpath}_2_trim.fastq.gz" 
