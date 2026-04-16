Population genetics analyses were performed using the R package sambaR and included:
1- Population structure
2- Population genetic diversity
3- Population genetic differentiation

Author: Anaisa Cajigas Gandia
License: GNU
Last updated: 16.04.2026

setwd("path/to/working/directory")
list.files()

source("https://github.com/mennodejong1986/SambaR/raw/master/SAMBAR_v1.10.txt")
getpackages() ## this is to get all required packages and dependencies sambaR need, and load them
library(adegenet)
library(vcfR)
library (LEA)

# Load sample sheet with populations information
samples<-read.csv("populations.ingroup_vicentei.tab", sep="\t",header=T)

# Import data: the input PLINK file is available in Zenodo, please find the link in the "Data availability" statement in the publication
importdata(inputprefix="vicentei_GATK_variants.filtered.biallelic.SNPs.minDP10mac3maxmissing075.nonCoding.LDpruned.PLINK",
           samplefile="populations.ingroup_vicentei.tab", pop_order=c("CAL","CEI","EMP","LOM"), 
           colourvector=c("#FF0B0B","#095E92","#331B01","#0CFF1A"),
           geofile="geofile_vicentei.txt", do_citations=FALSE)

# Retain al data because it was previously filtered in GATK and PLINK)
filterdata(indmiss=1,snpmiss=1,min_mac=0,dohefilter=FALSE,min_spacing=0,
           nchroms=NULL,TsTvfilter=NULL)

findstructure(Kmin=1,Kmax=4,add_legend=TRUE, do_dapc=TRUE, quickrun=FALSE,legend_pos="right",legend_cex=2,pop_order=NULL)
inferdemography(do_LEA=TRUE,Kmin=1,Kmax=4,do_f3=TRUE,f3_preparefiles=FALSE,jk_blocksize=1000)
LEAce(min_demes=1,max_demes=4,runanalysis=TRUE,nruns=50,export="pdf")
calcdiversity(nrsites=NULL, do_sfs=FALSE,do_venn=FALSE)
calcdistance(nchroms=NULL, dodistgenpop=FALSE)

