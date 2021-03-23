#!/bin/bash
#author: Peter Kille
#SBATCH --partition=mammoth
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --mem=32G
#SBATCH --error=%J.err
#SBATCH --output=%J.out
#SBATCH --mail-user=user@cardiff.ac.uk
#SBATCH --mail-type=ALL
 
module load samtools/1.10
module load bioperl-live/release-1-7-2
module load bcftools/1.10.2
module load seqtk/v1.3
module load SPAdes/3.14.1
 
#call varibles
source ./variable_mtfish.txt


for f in $input_dir
do
  filepath="${f%_1_trim.fastq.gz}" 
 # echo $filepath
  base=$(basename $filepath)
  echo "Will fish for ${base}"
done


for f in $input_dir
do
  filepath="${f%_1_trim.fastq.gz}" 
 # echo $filepath
  base=$(basename $filepath)
  echo "Fishing in ${base}"

  /mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/bbmap/mapPacBio.sh ref=$bait in="${filepath}_1_trim.fastq.gz" in2="${filepath}_2_trim.fastq.gz" slow=f outm=$out_dir/${base}_${name}.sam nodisk threads=16
 
  #convert to bam
  samtools view -bS $out_dir/${base}_${name}.sam > $out_dir/${base}_${name}.bam
 
  #extract fastq reads and pairs
  samtools bam2fq $out_dir/${base}_${name}.bam > $out_dir/${base}_${name}.fq
 
  #make index for reference
  samtools faidx $bait
 
  #extract concensus
  samtools sort -o $out_dir/${base}_${name}_sort.bam -T sort_temp -@ 16 $out_dir/${base}_${name}.bam
  samtools index $out_dir/${base}_${name}_sort.bam
  samtools mpileup -C50 -uf $bait $out_dir/${base}_${name}_sort.bam | bcftools call -c | vcfutils.pl vcf2fq | gzip > $out_dir/${base}_${name}.fq.gz
 
  #generate fasta
  seqtk seq -a $out_dir/${base}_${name}.fq.gz > $out_dir/${base}_${name}.fa
 
  spades.py \
        -t 16 \
        -m 32 \
        --12 $out_dir/${base}_${name}.fq \
        -o $out_dir/${base}_${name} \ 
done

