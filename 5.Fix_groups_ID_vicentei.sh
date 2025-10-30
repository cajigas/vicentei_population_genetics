#!/bin/bash
#SBATCH --account=nib00033
#SBATCH -p standard96
#SBATCH --dependency=singleton
#SBATCH --output=/scratch-emmy/usr/nibacg27/GATK/VICENTEI/slurm-vicentei-FIXREADSID-%x_%A_%a.oe
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=12:00:00          #time limit per job (?)
# the array should be corresponding to number of samples 

# module load
module load anaconda3/2019.03
module load java/16
conda init bash
# Fix Reads groups ID

cd $workDir
for bamfile in /scratch-emmy/usr/nibacg27/GATK/VICENTEI/*_merged.sorted.deduped.bam ; do
    sample_name=$(basename -s _merged.sorted.deduped.bam $bamfile)
    echo -e "["$(date)"]\tRenaming.." $bamfile
gatk AddOrReplaceReadGroups -I $bamfile -O ${bamfile%%.bam}".ok.bam" \
       --RGID $sample_name \
       --RGLB PairedEnd \
       --RGPL Illumina \
       --RGPU merged \
       --RGSM $sample_name
done