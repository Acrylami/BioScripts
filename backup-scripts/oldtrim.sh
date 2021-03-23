#!/bin/bash
#author: Aryln
#SBATCH --job-name=sradownload
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=1
#SBATCH --mem=16000
#SBATCH --error=%J.err
#SBATCH --output=%J.out

#workingdir
dir="/mnt/scratch/c1803625"

#seq reads without direction and without fastq.gz
seq_reads="name"

#output folder
out="ass"
module load fastqc/v0.11.7
module load Trimmomatic/0.39


srafile=(ERR4971212)
softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-centos_linux64/bin"

for i in {0..1}; do
trimmomatic PE  ${srafile[i]}_1.fastq.gz ${srafile[i]}_2.fastq.gz
fastqc -t 2 ${srafile[i]}_1.fastq.gz ${srafile[i]}_2.fastq.gz
 
done;
