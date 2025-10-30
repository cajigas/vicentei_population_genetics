#!/bin/bash
#SBATCH --array=1-20
#SBATCH --cpus-per-task=40
#SBATCH --account=nibacg27
#SBATCH -p standard96:shared
#SBATCH --output=/scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/slurm-vicentei-VARIANTCALLING-%x_%A_%a.oe
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=48:00:00          #time limit per job (?)
# the array should be corresponding to number of samples


# Modify the .bashrc file to contain the path to GATK folder and load it
source /home/nibacg27/.bashrc
# create a conda environment for the python dependencies of GATK
module load anaconda3/2019.03
module load java/8
conda init bash

# load the sample sheet
samplesheet="/scratch-emmy/usr/nibacg27/SCRIPTS/GATK_VICENTEI/vicentei_samples_merged_sorted_deduped.ok.cigar.bam.txt"
threads=$SLURM_JOB_CPUS_PER_NODE
name=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $1}'`
BAM=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $2}'`
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
reference="/scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa"
INDIR="/scratch-emmy/usr/nibacg27/GATK/VICENTEI"
OUTDIR="/scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/"
cd $INDIR

gatk HaplotypeCaller --java-options '-Xmx160G' --native-pair-hmm-threads 40 \
-R $reference -I $BAM -ERC GVCF -O $OUTDIR/$name".vcf" --dont-use-soft-clipped-bases false 






























