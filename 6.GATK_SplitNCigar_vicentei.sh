#!/bin/bash
#SBATCH --array=1-20
#SBATCH --nodes=6 --ntasks=40 --cpus-per-task=4
#SBATCH -p standard96
#SBATCH --account=nib00033
#SBATCH --dependency=singleton
#SBATCH --output=/scratch-emmy/usr/nibacg27/GATK/VICENTEI/slurm-vicentei-SPLITNCIGAR-%x_%A_%a.oe
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
#conda create --prefix /scratch-emmy/ur/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk4 -c conda-forge -c bioconda gatk4

#conda env create -n gatk -f gatkcondaenv.yml/scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0 
module load anaconda3/2019.03
module load java/8
conda init bash

# load the sample sheet
samplesheet="/scratch-emmy/usr/nibacg27/SCRIPTS/GATK_VICENTEI/vicentei_samples_merged_sorted_deduped.ok.bam.txt"
threads=$SLURM_JOB_CPUS_PER_NODE
name=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $1}'`
BAM=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $2}'`
reference="/scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa"
INDIR="/scratch-emmy/usr/nibacg27/GATK/VICENTEI"
OUTDIR="/scratch-emmy/usr/nibacg27/GATK/VICENTEI"
DEDUPED=$OUTDIR/"${name}"_merged.sorted.deduped.ok.bam
CIGAR=$OUTDIR/"${name}"_merged.sorted.deduped.ok.cigar.bam
###### INDIR es lo mismo que WORKDIR ######
########################   run these separately to create dictionary
#samtools faidx -c $reference 
#java -jar  picard.jar CreateSequenceDictionary R= /home/nibur564/ariel/Lace/superTranscriptome/SuperDuper.fasta O= /home/nibur564/ariel/Lace/superTranscriptome/SuperDuper.dict
### this would be my creating dictionary script: java -jar  picard.jar CreateSequenceDictionary R=/scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa O= /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.dict

mkdir /scratch/usr/nibacg27/temp
cd $OUTDIR
gatk SplitNCigarReads --java-options '-Xmx20G -XX:+UseParallelGC -XX:ParallelGCThreads=4' \
--input $DEDUPED --output $CIGAR --reference $reference --skip-mapping-quality-transform \
--tmp-dir /scratch/usr/nibacg27/temp --create-output-bam-index false

samtools index -c -@ 4 $CIGAR
# with this command line the default index is a .bai file, however it didnt create it, because the file size
# is too big to be stored in .bai files, so they suggest to do a .csi index, that would be with the option:
# samtools index -c $CIGAR (for creating the csi index for all the bam files resulting from the split N cigar step)
# when I tested this for just one sample with the following command, it worked and created the csi index:
# samtools index -c DAM2_merged.sorted.deduped.ok.cigar.bam 
# to create the csi index file in a run outside the array, for all the bam files in the same folder,
# at the same time, you run the following command:
# samtools index -c -M -@ 12 *.ok.cigar.bam 
# check: http://www.htslib.org/doc/samtools-index.html for more details

