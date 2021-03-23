#!/bin/bash
#author: Aryln
#SBATCH --job-name=spades
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH --error=%J.err
#SBATCH --output=%J.out

module load SPAdes/3.14.1

#workingdir
dir="/mnt/scratch/c1803625/trimming"

#seq reads without direction and without fastq.gz
seq_reads="ERR4971212"

#output folder
out="ass"

spades.py -t 8 -1 "${dir}/${seq_reads}_1_trim.fastq.gz" -2 "${dir}/${seq_reads}_2_trim.fastq.gz" -o ${out} 



