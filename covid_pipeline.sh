##########################
##Set up the filepaths and names
#User directory
dir="/mnt/scratch/c1803625"

#Input: Textfile of ERRs to trim
#allfiles="${dir}/scripts/filelist.txt"
#Input folder
input="${dir}/downloaded/nanopore/*_1.fastq.gz" #Get all forwards reads
#reports folder
report="reports"
#output folder
out="trimming"

#Filepaths
outpath="${dir}/${out}"
#filepath="${dir}/${input}"
reportpath="${dir}/${report}"

module load fastp/v0.20
module load fastqc/v0.11.9
module load multiqc/1.9



softwaredir="/mnt/data/GROUP-smbpk/PROJECTS/shared_scripts/sratoolkit.2.9.0-$

for f in $input
do
 filepath="${f%_1.fastq.gz}" #Get filepath without _1.fastq.gz or _2.fastq.gz
 base="$(basename $filepath)" #Get just base name like: ERR407592
 echo "Trimming $base"
 fastp -i "${filepath}_1.fastq.gz" -I "${filepath}_2.fastq.gz" -o "${outpath$
 echo "Output to: ${outpath}/${base}_1_trim.fastq.gz"
done
#############################

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
 fastqc -t 4 "${filepath}_1.fastq.gz" "${filepath}_2.fastq.gz" "${trimmedpat$
# echo "Output to: ${reportpath}/${base}_1_trim.fastq.gz"
done

multiqc ${dir} -o ${reportpath}


