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

module load parallel/20200522

sem -j 2 'sleep 1;echo 1 finished';   echo sem 1 exited
sem -j 2 'sleep 2;echo 2 finished';   echo sem 2 exited
sem -j 2 'sleep 3;echo 3 finished';   echo sem 3 exited
sem -j 2 'sleep 4;echo 4 finished';   echo sem 4 exited
sem --wait; echo sem --wait done
