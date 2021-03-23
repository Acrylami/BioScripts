#!/bin/bash
#author: Aryln
#SBATCH --job-name=gatk
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
input="${dir}/fishing/*_covid_sort.bam"

#Filepaths
outpath="${dir}/variants"
inpath="${dir}/fishing"
#filepath="${dir}/${input}"


module load gatk-4.1.0.0-gcc-8.3.1-2fiyw2h 


for f in $input
do
 filepath="${f%*_covid_sort.bam}" #Get filepath without _1.fastq.gz or _2.fastq.gz
 base="$(basename $filepath)" #Get just base name like: ERR407592
 echo "Fixing $f"
 new_name="${base}_covid_sort_fixed.bam"
 gatk --java-options "-Xmx4g" AddOrReplaceReadGroups -I "$f" -O "${inpath}/${new_name}" --RGLB lib1 --RGPL illumina --RGPU unit1 --RGSM 20
 echo "New file created as ${inpath}/$new_name"
 gatk --java-options "-Xmx4g" HaplotypeCaller -R "${inpath}/NC_045512_DNA.fasta" -I "${inpath}/${new_name}" -O "${outpath}/${base}.vcf"
 echo "Output to: ${outpath}/${base}.vcf"
done


#gatk --java-options "-Xmx4g" AddOrReplaceReadGroups -I "${input}/SRR13297086_covid_sort.bam" -O "${input}/SRR13297086_covid_sort_fix1.bam" --RGLB lib1 --RGPL illumina --RGPU unit1 --RGSM 20
#gatk --java-options "-Xmx4g" HaplotypeCaller -R "${input}/NC_045512_DNA.fasta" -I "${input}/SRR13297086_covid_sort_fix1.bam" -O "${outpath}/output.vcf"

#gatk --java-options "-Xmx4g" CreateSequenceDictionary -R "${input}/NC_045512_DNA.fasta"
#gatk --java-options "-Xmx4g" ValidateSamFile -I "${input}/SRR13297086_covid_sort_fix1.bam" --MODE VERBOSE
#gatk --java-options "-Xmx4g" AddOrReplaceReadGroups -I "${input}/SRR13297086_covid_sort.bam" -O "${input}/SRR13297086_covid_sort_fix1.bam" --RGLB lib1 --RGPL illumina --RGPU unit1 --RGSM 20
