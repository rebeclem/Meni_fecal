#!/bin/bash
#SBATCH -N 1
#SBATCH -t 1-00:00:00
#SBATCH -J prinseq
#SBATCH -p defq,short,gpu
#SBATCH --array=1-26
#SBATCH -o out_err_files/prinseq_%A_%a.out
#SBATCH -e out_err_files/prinseq_%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p list.txt)

#--- Start the timer
t1=$(date +"%s")

echo $name

# Running Fastqc on all samps
module load prinseq


prinseq-lite  -fastq $(ls $name/flexbar_1.fastq) \
 -fastq2 $(ls $name/flexbar_2.fastq) \
 -min_len 40 \
 -min_qual_mean 20 \
 -derep 23 \
 -lc_method dust \
 -lc_threshold 7 \
 -trim_qual_left 20 \
 -trim_qual_right 20 \
 -trim_ns_left 1 \
 -trim_ns_right 1


#---Complete job
t2=$(date +"%s")
diff=$(($t2-$t1))
echo "[---$SN---] ($(date)) $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "[---$SN---] ($(date)) $SN COMPLETE."
