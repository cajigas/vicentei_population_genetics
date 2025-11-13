### Bioinformatic pipeline followed to do haplotype calling of Oophaga vicentei RNA reads
# when using the reference genome of Oophaga sylvatica ###

Author: Anaisa Cajigas Gandia
License: GNU
Last updated: 30.10.2025

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
