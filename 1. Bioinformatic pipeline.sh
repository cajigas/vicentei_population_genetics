### Bioinformatic pipeline followed to do haplotype calling of Oophaga vicentei RNA reads
# when using the reference genome of Oophaga sylvatica (NCBI accession: GCA_033576555.1) ###

Author: Anaisa Cajigas Gandia
License: GNU
Last updated: 16.04.2026

Main steps included:
1- RNA reads quality trimming
2- Mapping reads against reference using STAR
3- Mark duplicates
4- Merge tissues per individuals
5- Fix groups ID
6- SplitNCigar 
7- GATK Haplotype Calling
8- GATK Merge individuals
9- VCF postprocessing

Note that all bioinformatic analyses were conducted in a remote server
of HPC from the Emmy/Grete at NHR–Nord@Göttingen.
Accounts, and resource allocation to different nodes and partitions might vary, 
and are not provided here.

Please check the repository: 
"Bioinformatic_pipeline" in: https://github.com/cajigas/granulifera_selection 
to find the scripts used for this analysis. 
Note that function and software settings were the same for both species, 
but the number and name of samples, as well as threads varied accordingly. 
For any specific question, contact me directly. 

### The only different step is VCF postprocessing, and for O. vicentei I show the script below:

cd .../vicentei/population_genetics/VCF

# Filter for minimum depth, minor allele count and missing data
vcftools --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.vcf \
--minDP 10 --mac 3 --max-missing 0.75 --bed non-coding_OopSyl_NCBI_genome.bed \
--out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding \
--recode --keep-INFO-all
# After filtering, kept 50320 out of 3856452 possible sites

# Remove loci in LD with PLINK
plink2 --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.recode.vcf \
--allow-extra-chr --set-all-var-ids @:#\$r,\$a --indep-pairwise 50 1 0.7 --bad-ld 
# After filtering, kept 26296 SNPs  

plink2 --vcf vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.recode.vcf \
--allow-extra-chr --set-all-var-ids @:#\$r,\$a --exclude plink2.prune.out --make-bed --recode \
--out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK

# Export in different formats for further analyses
plink --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK \
--allow-extra-chr --recode A --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK

plink --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK \
--allow-extra-chr --recode --tab --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK

plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK \
--allow-extra-chr --freq

plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK \
--allow-extra-chr --make-rel square --read-freq plink2.afreq

plink2 --bfile vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK \
--allow-extra-chr --export vcf --out vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK
