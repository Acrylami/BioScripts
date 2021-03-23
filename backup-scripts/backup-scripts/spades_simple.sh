#!/bin/bash
#author: Aryln
#SBATCH --job-name=spades
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH --error="/mnt/scratch/c1803625/logs/%J.err"
#SBATCH --output="/mnt/scratch/c1803625/logs/%J.out"

module load SPAdes/3.14.1

##FILE NAME, CHANGE THIS:
#seq reads without direction and without fastq.gz
seq_reads="ERR4971212"

##Set up the filepaths and names
#User directory
dir="/mnt/scratch/c1803625"
#Input folder
input="trimming"
#output folder
out="assembly"
outpath="${dir}/${out}/${seq_reads}"
#Filepath
filepath="${dir}/${input}/${seq_reads}"

spades.py -t 8 -1 "${filepath}_1_trim.fastq.gz" -2 "${filepath}_2_trim.fastq.gz" -o "${outpath}"



