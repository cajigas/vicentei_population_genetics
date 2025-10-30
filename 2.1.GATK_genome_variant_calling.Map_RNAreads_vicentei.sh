#!/bin/bash
#SBATCH --array=1-44
#SBATCH --nodes=1 --ntasks=88 --cpus-per-task=2
#SBATCH --account=nib00033
#SBATCH -p standard96
#SBATCH --dependency=singleton
#SBATCH --output=/scratch-emmy/usr/nibacg27/GATK/VICENTEI/slurm-vicentei-STAR-%x_%A_%a.oe  
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=12:00:00          #time limit per job (?)
# the array should be corresponding to number of samples


# Script to map RNA reads of O. vicentei against O. sylvatica genome
# adapted from: https://gatkforums.broadinstitute.org/gatk/discussion/3892/the-gatk-best-practices-for-variant-calling-on-rnaseq-in-full-detail

cd /scratch-emmy/usr/nibacg27/GATK/VICENTEI
#	module list available by typing :module avail 		in the terminal

module load gcc/9.3.0
module load openmpi/gcc.9/3.1.5
source ~/.bashrc

# provide the directory with the trimmed reads and 
# a tab separated table of PE reads trimmed samples in three columns (id mate-1 mate-2)
# READS_DIR=/scratch-emmy/projects/nib00033/vicentei/trimmed/
# sed "s/\.fastq\.gz/\.trim\.fastq\.gz/g" "/scratch-emmy/usr/nibacg27/SCRIPTS/GATK_VICENTEI/vicentei_samples_trimmed.txt" 
samplesheet="/scratch-emmy/usr/nibacg27/SCRIPTS/GATK_VICENTEI/vicentei_samples_trimmed.txt"
samplename=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $1}'`
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $2}'`
r2=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $3}'`


genomeDir="/scratch-emmy/usr/nibacg27/sylvatica_reference_genome/"
workDir=/scratch-emmy/usr/nibacg27/GATK/VICENTEI
mkdir $workDir
cd $workDir
# STAR array
STAR --readFilesCommand zcat --outFileNamePrefix $samplename \
	--outSAMtype BAM Unsorted --outSAMmapqUnique 60 \
	--outSAMattrRGline ID:$samplename CN:ZoolInst_TiHo \
	LB:PairedEnd PL:Illumina PU:Unknown SM:$samplename \
	--genomeDir $genomeDir --runThreadN $SLURM_NTASKS --readFilesIn $r1 $r2 --twopassMode Basic 
	

samtools sort -@ 2 -o $samplename"_sorted.bam" $samplename"Aligned.out.bam"
samtools index -c -@ 2 $samplename"_sorted.bam"
rm $workDir/$samplename"Aligned.out.bam"