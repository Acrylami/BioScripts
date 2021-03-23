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
out="downloaded"

module load parallel/20200522

#srafile=( ERR4970050 ERR4970078 ERR4971212 ) #last one twice because is missed 
srafile=( ERR4971212 )

softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-centos_linux64/bin"
echo Beginning download...
for i in ${srafile[@]}
do
	echo Downloading  $i
	sem --wait --id slim.${SLURM_JOB_ID} -j ${SLURM_NTASKS} "${softwaredir}/fastq-dump" -O "${out}" --gzip --split-files $i
done;
#Last one does not get downloaded, so try it again
sem --id slim.${SLURM_JOB_ID} -j ${SLURM_NTASKS} "${softwaredir}/fastq-dump" -O "${out}" --gzip --split-files "${srafile[-1]}"
sem --wait; echo Finished
