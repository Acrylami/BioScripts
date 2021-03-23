#!/bin/bash
#author: Peter Kille
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH --error=%J.err
#SBATCH --output=%J.out

module load fastp/v0.20


#define working directory
in_dir="/mnt/scratch/c1803625/"

#core sample name no direction or fastq.gz
raw="ERR4971212"

#input file name
out_dir="/mnt/scratch/c1803625/trimming"

fastp -i "${in_dir}/${raw}_1.fastq.gz" -I "${in_dir}/${raw}_2.fastq.gz" -o "${out_dir}/${raw}_1_trim.fastq.gz" -O "${out_dir}/${raw}_2_trim.fastq.gz" -w ${SLURM_NTASKS}

fastqc -t 4 "${in_dir}/${raw}_1.fastq.gz" "${in_dir}/${raw}_2.fastq.gz" "${out_dir}/${raw}_1_trim.fastq.gz" "${out_dir}/${raw}_2_trim.fastq.gz" 
