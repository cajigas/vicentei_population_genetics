#!/bin/bash
#SBATCH --account=nib00033
#SBATCH -p standard96
#SBATCH --dependency=singleton
#SBATCH --output=/scratch-emmy/usr/nibacg27/GATK/VICENTEI/slurm-vicentei-MERGETISSUES-%x_%A_%a.oe
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=12:00:00          #time limit per job (?)
# the array should be corresponding to number of samples

source /home/nibacg27/.bashrc
cd /scratch-emmy/usr/nibacg27/GATK/VICENTEI/
samtools merge --threads 8 CAL1_merged.sorted.deduped.bam CAL1*.sorted.deduped.bam
samtools merge --threads 8 CAL2_merged.sorted.deduped.bam CAL2*.sorted.deduped.bam
samtools merge --threads 8 CAL3_merged.sorted.deduped.bam CAL3*.sorted.deduped.bam
samtools merge --threads 8 CAL4_merged.sorted.deduped.bam CAL4*.sorted.deduped.bam
samtools merge --threads 8 CEI1_merged.sorted.deduped.bam CEI1*.sorted.deduped.bam
samtools merge --threads 8 CEI2_merged.sorted.deduped.bam CEI2*.sorted.deduped.bam
samtools merge --threads 8 CEI3_merged.sorted.deduped.bam CEI3*.sorted.deduped.bam
samtools merge --threads 8 CEI4_merged.sorted.deduped.bam CEI4*.sorted.deduped.bam
samtools merge --threads 8 CEI5_merged.sorted.deduped.bam CEI5*.sorted.deduped.bam
samtools merge --threads 8 CEI7_merged.sorted.deduped.bam CEI7*.sorted.deduped.bam
samtools merge --threads 8 CEI8_merged.sorted.deduped.bam CEI8*.sorted.deduped.bam
samtools merge --threads 8 EMP1_merged.sorted.deduped.bam EMP1*.sorted.deduped.bam
samtools merge --threads 8 EMP2_merged.sorted.deduped.bam EMP2*.sorted.deduped.bam
samtools merge --threads 8 EMP3_merged.sorted.deduped.bam EMP3*.sorted.deduped.bam
samtools merge --threads 8 EMP4_merged.sorted.deduped.bam EMP4*.sorted.deduped.bam
samtools merge --threads 8 EMP5_merged.sorted.deduped.bam EMP5*.sorted.deduped.bam
samtools merge --threads 8 LOM1_merged.sorted.deduped.bam LOM1*.sorted.deduped.bam
samtools merge --threads 8 LOM2_merged.sorted.deduped.bam LOM2*.sorted.deduped.bam
samtools merge --threads 8 LOM3_merged.sorted.deduped.bam LOM3*.sorted.deduped.bam
samtools merge --threads 8 LOM4_merged.sorted.deduped.bam LOM4*.sorted.deduped.bam
