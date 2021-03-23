#!/bin/bash
#author: Aryln
#SBATCH --job-name=multi-trim
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16000
#SBATCH --error=%J.err
#SBATCH --output=%J.out

echo "General Env Var Info:"
echo "================================="
echo "hostname=$(hostname)"
echo \$SLURM_JOB_ID=${SLURM_JOB_ID}
echo \$SLURM_NTASKS=${SLURM_NTASKS}
echo \$SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}
echo \$SLURM_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}
echo \$SLURM_JOB_CPUS_PER_NODE=${SLURM_JOB_CPUS_PER_NODE}
echo \$SLURM_MEM_PER_CPU=${SLURM_MEM_PER_CPU}


##Set up the filepaths and names
#User directory
dir="/mnt/scratch/c1803625"

#Input: Textfile of ERRs to trim
#allfiles="${dir}/scripts/filelist.txt"
#Input folder
input="${dir}/downloaded/nanopore/*_1.fastq.gz" #Get all forwards reads
#reports folder
report="reports"
#output folder
out="trimming"

#Filepaths
outpath="${dir}/${out}"
#filepath="${dir}/${input}"
reportpath="${dir}/${report}"

module load fastp/v0.20



softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-centos_linux64/bin"

for f in $input
do
 filepath="${f%_1.fastq.gz}" #Get filepath without _1.fastq.gz or _2.fastq.gz
 base="$(basename $filepath)" #Get just base name like: ERR407592
 echo "Trimming $base"
 fastp -i "${filepath}_1.fastq.gz" -I "${filepath}_2.fastq.gz" -o "${outpath}/${base}_1_trim.fastq.gz" -O "${outpath}/${base}_2_trim.fastq.gz" -w ${SLURM_NTASKS} -h "${outpath}/${base}.html"
 echo "Output to: ${outpath}/${base}_1_trim.fastq.gz"
done
