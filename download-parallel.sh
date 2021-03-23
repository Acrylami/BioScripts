#!/bin/bash
#author: Aryln
#SBATCH --job-name=sradownload
#SBATCH --partition=defq
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
##srafile=("${dir}/scripts/wget_urls.txt")
echo hello
#for i in (wget_urls.txt)
#do
#wget "${i}"
#done;

#URL_LIST=("${dir}/scripts/wget_urls.txt")
mapfile -t URL_LIST < wget_urls.txt
for f in $URL_LIST
do
  echo $f
done
#echo $URL_LIST #| xargs -n 1 -P 8 wget -q
