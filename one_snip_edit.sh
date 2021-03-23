#!/bin/bash
#author: Aryln
#SBATCH --job-name=snippy-pipeline
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
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

module load samtools #Snippy needs this
module load snippy #Also loads bioperl, run with snippy
module load snp-sites #run with snp-sites
module load fasttree #run with FastTree

#User directory
dir="/mnt/scratch/c1803625"

#Folders
input="${dir}/trimming/*1_trim.fastq.gz"
trimming="${dir}/trimming"
output="${dir}/snippy"
reference="${dir}/fishing/NC_045512_DNA.fasta"

file1=""
file2=""
filepath=""
base=""

for f in $input
do
  filepath="${f%_1_trim.fastq.gz}"
  base=$(basename $filepath)

  file1="${trimming}/${base}_1_trim.fastq.gz"
  file2="${trimming}/${base}_2_trim.fastq.gz"

  echo "Will snip ${file1} and ${file2} using ${reference}"
  snippy --cpus ${SLURM_CPUS_PER_TASK} --ref "${reference}" --outdir "${output}" --R1 "${file1}" --R2 "${file2}" --force
done
