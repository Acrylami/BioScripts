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

##TO CHANGE##
dir="/mnt/scratch/c1803625" #Working directory
input_folder="trimming" #Location of trimmed fastq files (from dir)
output_folder="snippy" #Output directory (from dir)
forward_read_extension="_1_trim.fastq.gz" #What do all the forward read filenames end in?
backward_read_extension="_2_trim.fastq.gz" #What do all the backward read filenames end in?
reference="${dir}/fishing/NC_045512_DNA.fasta" #DNA reference template
#############


#Folders (Shouldn't need to change, just change above variables
input="${dir}/${input_folder}/*${forward_read_extension}" #Every forward read in trim folder
trimming="${dir}/${input_folder}" #Trimmed input directory
output="${dir}/${output_folder}" #Snippy output directory
snip_pre="snip_" #Prepend all snippy folders generated with this

#Initialising empty variables for loop, ignore
#file1=""
#file2=""
#filepath=""
#base=""

mkdir "${output}" #Creates output folder if not already existing

#Run snippy on every forward and backwards reads in input folder
for f in $input
do
  filepath="${f%_1_trim.fastq.gz}"
  base=$(basename $filepath) #get the name of the sequence, e.g. SRR13297091

  #Get filepath for forward and backward read, e.g. SRR13297091_1_trim.fastq.gz
  file1="${trimming}/${base}${forward_read_extension}"
  file2="${trimming}/${base}${backward_read_extension}"

  echo "Will snip ${file1} and ${file2} using ${reference}"
  snippy --cpus ${SLURM_CPUS_PER_TASK} --ref "${reference}" --outdir "${output}/${snip_pre}${base}" --R1 "${file1}" --R2 "${file2}" --force
done

#Generate core genome alignment from mapping runs
snippy-core --ref "${reference}" --prefix "${output}/output-alignment" ${output}/${snip_pre}* 

#Generate variant alignment
snp-sites -cb -o "${output}/snp-alignment.aln" "${output}/output-alignment.aln"

#Draw phylogenetic tree
FastTreeMP -nt -gtr < "${output}/snp-alignment.aln" > "${output}/tree.tre"
