#!/bin/bash
#author: Peter Kille
#SBATCH --partition=jumbo
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=64000
#SBATCH --error="%J.err"
#SBATCH --output="%J.out"

echo "General Env Var Info:"
echo "================================="
echo "hostname=$(hostname)"
echo \$SLURM_JOB_ID=${SLURM_JOB_ID}
echo \$SLURM_NTASKS=${SLURM_NTASKS}
echo \$SLURM_NTASKS_PER_NODE=${SLURM_NTASKS_PER_NODE}
echo \$SLURM_CPUS_PER_TASK=${SLURM_CPUS_PER_TASK}
echo \$SLURM_JOB_CPUS_PER_NODE=${SLURM_JOB_CPUS_PER_NODE}
echo \$SLURM_MEM_PER_CPU=${SLURM_MEM_PER_CPU}

module load fastqc/v0.11.9
module load multiqc/1.9

#core sample name no direction or fastq.gz

#declare input files - do not include _R1_001.fastq.gz or _R2_001.fastq.gz
declare -a rawdata=(\
"G702391761_S16_L001"
"G702391821_S18_L001"
"G702391904_S11_L001"
"G702391970_S10_L001"
"G702396357_S23_L001"
"G702406540_S21_L001"
"G702406690_S22_L001"
"G702406797_S19_L001"
"G702406821_S20_L001"
"G702428701_S6_L001"
"G702428822_S9_L001"
"G702438014_S7_L001"
"G702438087_S5_L001"
"G702438179_S4_L001"
"G702447305_S12_L001"
"G702447484_S13_L001"
"G702447546_S15_L001"
"G702458893_S1_L001"
"G702458968_S2_L001"
"G702460506_S3_L001"
"G702473309_S8_L001"
"G702473373_S14_L001"
"NC_045512_DNA.fasta"
"Positive-control_S24_L001"
)


##Set up the filepaths and names
#User directory
dir="/mnt/scratch/c1803625"
#Input folder
input="1-rawdata"
#Input folder
input="${dir}/downloaded/test/*_1.fastq.gz" #Get all forwards reads

#output folder
out="2-trim"
#reports folder
report="reports"

#Filepaths
outpath="${dir}/${out}"
trimmedpath="${dir}/trimming"
#filepath="${dir}/${input}"
reportpath="${dir}/${report}"


for f in $input
do
 filepath="${f%_1.fastq.gz}" #Get filepath without _1.fastq.gz or _2.fastq.gz
 base="$(basename $filepath)" #Get just base name like: ERR407592
 echo "Generating 4 reports for $base"
 fastqc -t 4 "${filepath}_1.fastq.gz" "${filepath}_2.fastq.gz" "${trimmedpath}/${base}_1_trim.fastq.gz" "${trimmedpath}/${base}_2_trim.fastq.gz" -o "${reportpath}"
# echo "Output to: ${reportpath}/${base}_1_trim.fastq.gz"
done


#for (( i=0 ; i<${#rawdata[@]} ; i++ ));do

#fastqc -t 4 "${filepath}/${rawdata[${i}]}_R1_001.fastq.gz" "${filepath}/${rawdata[${i}]}_R2_001.fastq.gz" "${outpath}/${rawdata[${i}]}_1_trim.fastq.gz" "${outpath}/${rawdata[${i}]}_2_trim.fastq.gz"  

#fastqc "${outpath}/${rawdata[${i}]}_2_trim.fastq.gz"

#done

multiqc ${dir} -o ${reportpath}

#fastp cgenerates it's own reports 
#fastqc -t 4 "${reportpath}_1.fastq.gz" "${reportpath}_2.fastq.gz" "${reportpath}_1_trim.fastq.gz" "${reportpath}_2_trim.fastq.gz" 
