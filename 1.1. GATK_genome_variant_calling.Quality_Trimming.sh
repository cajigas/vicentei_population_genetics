#!/bin/bash
#SBATCH --account=nib00033
#SBATCH --job-name=vicentei
#SBATCH --nodes=2 --ntasks=88 --ntasks-per-node=44 --cpus-per-task=4
#SBATCH --array=1-44
#SBATCH --time=12:00:00          #time limit per job
#SBATCH -p standard96
#SBATCH --dependency=singleton
#SBATCH --mail-type=begin        # send email when job begins
#SBATCH --mail-type=end          # send email when job ends
#SBATCH --mail-user=vasiliki.mantzana.oikonomaki@tiho-hannover.de
#SBATCH --output=/home/nibvasmo/scripts/slurmOut/slurm-fastp-%x-%A_%a-2024.oe

cd /scratch-emmy/projects/nib00033/vicentei/rawfiles
module load openmpi/gcc.9/3.1.5
source ~/.bashrc
module load perl/5.22.0
export SLURM_CPU_BIND=none
export OMP_NUM_THREADS=176

# provide the directory with the reads and 
# a tab separated table of PE reads samples in three columns (id mate-1 mate-2)
READS_DIR="/scratch-emmy/projects/nib00033/vicentei/rawfiles"
samplesheet="/home/nibvasmo/array_samplesheets/vicentei/vicentei.txt"
samplename=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $1}'`
r1=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $2}'`
r2=`sed -n "$SLURM_ARRAY_TASK_ID"p $samplesheet | awk '{print $3}'`
echo "This is array task ${SLURM_ARRAY_TASK_ID}, the sample name is ${samplename} and r1 is ${r1} an r2 is ${r2}." >> output_array_fastpv.txt
fastp --thread 176 --detect_adapter_for_pe \
--in1 $r1 \
--in2 $r2 \
--out1 ${r1%%.fastq.gz}".trim.fastq.gz" \
--out2 ${r2%%.fastq.gz}".trim.fastq.gz" \
--html ${samplename}".fastp.html" \
--json ${samplename}".fastp.json"