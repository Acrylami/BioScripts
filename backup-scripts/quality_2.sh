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
dir="/mnt/scratch/c1803625/downloaded"

#seq reads without direction and without fastq.gz
seq_reads="name"

#output folder
out="qc-output"

#Load modules
module load fastqc/v0.11.9
module load parallel/20200522


srafile=( ERR4970050 SRR518723 ERR4970078 ERR4971212 )
softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-centos_linux64/bin"

for i in ${srafile[@]}
do
	echo Generating report for $i
	fastqc -o "${out}" -t 2 "${dir}/${i}_1.fastq.gz" "${dir}/${i}_2.fastq.gz"
done;

sem --wait; echo Finished

