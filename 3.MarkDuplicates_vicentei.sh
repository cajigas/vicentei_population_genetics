#!/bin/bash
#SBATCH --array=1-44
#SBATCH --nodes=1 --ntasks=88 --cpus-per-task=2
#SBATCH -p standard96
#SBATCH --account=nib00033
#SBATCH --dependency=singleton
#SBATCH --output=/scratch-emmy/usr/nibacg27/GATK/VICENTEI/slurm-vicentei-MARKDUPLICATES-%x_%A_%a.oe
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=12:00:00          #time limit per job (?)
# the array should be corresponding to number of samples

# Modify the .bashrc file to contain the path to GATK folder and load it
source /home/nibacg27/.bashrc
# create a conda environment for the python dependencies of GATK
#cd /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0
#conda env create --prefix /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk_conda -f gatkcondaenv.yml
#conda create --prefix /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk4 -c conda-forge -c bioconda gatk4

#conda env create -n gatk -f gatkcondaenv.yml/scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0 
module load anaconda3/2019.03
module load java/16
conda init bash


samplesheet="/scratch-emmy/usr/nibacg27/SCRIPTS/GATK_VICENTEI/vicentei_samples_sorted.bam.txt"
threads=$SLURM_JOB_CPUS_PER_NODE
sample=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $1}'`
BAM=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $2}'`

INDIR="/scratch-emmy/usr/nibacg27/GATK/VICENTEI"
OUTDIR="/scratch-emmy/usr/nibacg27/GATK/VICENTEI"
DEDUPED=$OUTDIR/"${sample}".sorted.deduped.bam
METRICS=$OUTDIR/"${sample}".picard-output.metrics
reference="/scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa"
#samtools faidx $reference
#java -jar  picard.jar CreateSequenceDictionary R= $reference O= ${reference%%.fa}".dict"

cd $OUTDIR
gatk MarkDuplicates -I $BAM -O $DEDUPED -VALIDATION_STRINGENCY SILENT -M $METRICS #-CREATE_INDEX true 
