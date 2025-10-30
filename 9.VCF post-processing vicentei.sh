### Post-processing O. vicentei vcf ###

# Filter in vcftools
cd /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_RNA_VCF/

/scratch-emmy/usr/nibacg27/SOFTWARES/vcftools-0.1.16/src/cpp/vcftools --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.vcf --minDP 3 --maf 0.05 --max-missing 0.75 --recode --recode-INFO-all --out /scratch-emmy/projects/nib00033/Anaisa/VICENTEI_RNA_VCF/vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8

# Remove loci in LD (linkage disequilibrium) with PLINK

/scratch-emmy/usr/nibacg27/SOFTWARES/plink2 --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.recode.vcf --allow-extra-chr --set-all-var-ids @:#\$r,\$a --indep-pairwise 50 1 0.7 --bad-ld 
/scratch-emmy/usr/nibacg27/SOFTWARES/plink2 --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.recode.vcf --allow-extra-chr --set-all-var-ids @:#\$r,\$a --exclude plink2.prune.out --make-bed --export ped --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK


# Export in different formats
/scratch-emmy/usr/nibacg27/SOFTWARES/plink --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK --allow-extra-chr --recode A --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK

/scratch-emmy/usr/nibacg27/SOFTWARES/plink --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK --allow-extra-chr --recode --tab --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK

/scratch-emmy/usr/nibacg27/SOFTWARES/plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK --allow-extra-chr --freq
/scratch-emmy/usr/nibacg27/SOFTWARES/plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK --allow-extra-chr --make-rel square --read-freq plink2.afreq

/scratch-emmy/usr/nibacg27/SOFTWARES/plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK --allow-extra-chr --export vcf --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP3mac3maxmissing8.LDpruned.PLINK 


