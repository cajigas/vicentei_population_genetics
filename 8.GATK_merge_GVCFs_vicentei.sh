#!/bin/bash
#SBATCH --account=nibacg27
#SBATCH -p standard96:shared
#SBATCH --output=/scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/slurm-vicentei-MERGEINDIVIDUALS-%x_%A_%a.oe
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=anaisa.cajigas.gandia@tiho-hannover.de
#SBATCH --time=48:00:00          #time limit per job (?)
#SBATCH --mem=120G               # Request 120 GB of memory

module load anaconda3/2019.03
module load java/8
module load python/3.10.13

cd /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/
/scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk CombineGVCFs --java-options '-Xmx100G -XX:+UseParallelGC -XX:ParallelGCThreads=20' \
-R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CAL1.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CAL2.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CAL3.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CAL4.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI1.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI2.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI3.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI4.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI5.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI7.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/CEI8.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/EMP1.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/EMP2.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/EMP3.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/EMP4.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/EMP5.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/LOM1.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/LOM2.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/LOM3.vcf \
--variant /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/LOM4.vcf \
-O vicentei_GATK_variants.gvcf

# Convert GVCF to VCF
/scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk GenotypeGVCFs --java-options '-Xmx100G -XX:+UseParallelGC -XX:ParallelGCThreads=20' \
-R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa \
-V vicentei_GATK_variants.gvcf -O vicentei_GATK_variants.vcf

# Variant Filtration
# sleep 12h

cd /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0
java -jar /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar VariantFiltration -R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa -V /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.vcf -window 35 -cluster 3 --filter-name FSQD -filter "FS > 30.0 || QD < 2.0" -O  /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.vcf 2> vicentei_GATK_variants.VariantFilter.log

java -Xmx60g -Xms60g -XX:+UseParallelGC -XX:ParallelGCThreads=20 -jar /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar SelectVariants -R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa -V /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.vcf --restrict-alleles-to BIALLELIC --exclude-filtered true -O /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.biallelic.vcf 2>vicentei_GATK_variants.filtered.SelectVariants_BIALLELIC.log

# Divide into SNPs and Indels
java -Xmx60g -Xms60g -XX:+UseParallelGC -jar /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar SelectVariants \
-R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa -V /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.biallelic.vcf --select-type-to-include SNP -O /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.biallelic.SNPs.vcf 

java -Xmx60g -Xms60g -XX:+UseParallelGC -jar /scratch-emmy/usr/nibacg27/SOFTWARES/gatk-4.1.2.0/gatk-package-4.1.2.0-local.jar SelectVariants \
-R /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa -V /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.biallelic.vcf --select-type-to-include INDEL -O /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_VCF/vicentei_GATK_variants.filtered.biallelic.INDELS.vcf
