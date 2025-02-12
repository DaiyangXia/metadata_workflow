#!/bin/bash
#SBATCH --account=emm1
#SBATCH --job-name=cutadapt
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=1-380%30
#SBATCH --output=logs/cutadapt.%A.%a.out
#SBATCH --error=logs/cutadapt.%A.%a.err
#SBATCH --mem=16G
#SBATCH  --export=ALL

module load cutadapt/1.16

# adapter sequences taken from cutadapt website: https://cutadapt.readthedocs.io/en/stable/guide.html#illumina-truseq

truseqR1=AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
truseqR2UNI=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT

sample=$(awk "NR==$SLURM_ARRAY_TASK_ID" sample.names | awk '{print $1}')

reads=/mnt/smart/scratch/emm1/projects/prodigio/metagenomes/3rd.batch/raw.reads/renamed/raw.reads
out=/mnt/smart/scratch/emm1/projects/prodigio/metagenomes/3rd.batch/raw.reads/renamed/clean.reads

# Run cutadapt
cutadapt -a ${truseqR1} -A ${truseqR2UNI} -o ${out}/${sample}_R1.clean.fastq.gz -p ${out}/${sample}_R2.clean.fastq.gz  --minimum-length=75 -q 20,20 --nextseq-trim=20 --max-n=0 ${reads}/${sample}_R1.fastq.gz ${reads}/${sample}_R2.fastq.gz
