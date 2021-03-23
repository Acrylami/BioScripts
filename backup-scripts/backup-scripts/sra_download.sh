#!/bin/bash
#author: Aryln
#SBATCH --job-name=sradownload
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=1
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

module load parallel/20200522
srafile=(ERR4971212)
softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-centos_linux64/bin"
echo hello
for i in {0..1}; do
echo hi 
sem --id slim.${SLURM_JOB_ID} -j ${SLURM_NTASKS} "${softwaredir}/fastq-dump" --gzip --split-files ${srafile[i]}
 
done;
