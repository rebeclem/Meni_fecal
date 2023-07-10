#!/bin/bash

#SBATCH --time=4:00:00   # walltime
#SBATCH --array=0-25
#SBATCH -p short,tiny,debug,debug-gpu,graphical
#SBATCH -o kneaddata.%A_%a.out
#SBATCH -e kneaddata.%A_%a.err
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu



#SAVEIFS=$IFS   # Save current IFS
#IFS=$'\n'      # Change IFS to new line
#list=("L1000-15a-m-Hourigan-190107_S8" "L1001-12-m-Hourigan-190107_S7"
# .....insert the name of the files.....)
#name1=$(sed -n "$SLURM_ARRAY_TASK_ID"p ../samps.txt)
list=($(cat ../samps.txt))
name1=${list[${SLURM_ARRAY_TASK_ID}]}
echo $name1
# DATABASE = "/GWSPH/home/rebeccaclement/glustre/Allison/refs/kneaddata/"

module load trimmomatic
module load fastQC

kneaddata --input1 $name1/${name1}_R1.fastq.gz --input2 $name1/${name1}_R1.fastq.gz -t 8 -p 32 \
--reference-db /GWSPH/home/rebeccaclement/glustre/Allison/refs/kneaddata/ \
--output kneadDataOutput/kneaddata_"$name1"_output \
--run-fastqc-start --run-fastqc-end --run-trim-repetitive
#--trimmomatic #[path_of_your_trimmomatic, e.g. myMiniconda3/envs/humann/share/trimmomatic-0.39-2/]

# kneaddata -i merged/"$filename".fastq -t 8 -p 32 \
