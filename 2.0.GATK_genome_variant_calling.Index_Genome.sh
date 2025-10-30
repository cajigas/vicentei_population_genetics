# Script to map RNA reads of O. granulifera against O. sylvatica genome
# adapted from: https://gatkforums.broadinstitute.org/gatk/discussion/3892/the-gatk-best-practices-for-variant-calling-on-rnaseq-in-full-detail

#	first generate the GENOME INDEX
/scratch-emmy/usr/nibacg27/SOFTWARES/STAR/STAR-2.7.11b/bin/Linux_x86_64_static/STAR --runThreadN 32 \
--runMode genomeGenerate --genomeDir /scratch-emm27/sylvatica_reference_genome \
--genomeFastaFiles /scratch-emmy/usr/nibacg27/sylvatica_reference_genome/GCA_033576555.1_ASM3357655v1_genomic.fa

#


