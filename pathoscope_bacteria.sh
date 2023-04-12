#!/bin/bash
#SBATCH -N 1
#SBATCH -t 4:00:00
#SBATCH -p highThru,graphical,debug,defq,small-gpu,short
#SBATCH -o PS_hg38.%A_%a.out
#SBATCH -e PS_hg38.%A_%a.err
#SBATCH --array=1-25
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rebeccaclement@gwu.edu

name=$(sed -n "$SLURM_ARRAY_TASK_ID"p ../samps.txt)

#--- Start the timer
t1=$(date +"%s")

echo $name
mkdir -p $name/human

module load pathoscope
module load bowtie2

# -targetIndexPrefixes ref_prok_rep_genomes.00_ti,ref_prok_rep_genomes.01_ti,ref_prok_rep_genomes.02_ti,ref_prok_rep_genomes.03_ti,ref_prok_rep_genomes.04_ti,ref_prok_rep_genomes.05_ti,ref_viruses_rep_genomes_ti,ref_viroids_rep_genomes_ti \

pathoscope MAP -numThreads $(nproc)\
 -outDir $name/human \
 -indexDir ../refs \
 -targetIndexPrefixes ref_prok_rep_genomes.00_ti,ref_prok_rep_genomes.01_ti,ref_prok_rep_genomes.02_ti,ref_prok_rep_genomes.03_ti,ref_prok_rep_genomes.04_ti,ref_prok_rep_genomes.05_ti,ref_viruses_rep_genomes_ti,ref_viroids_rep_genomes_ti \
 -filterIndexPrefixes hg38full \
 -1 $(ls $name/flexcleaned_1.fastq) \
 -2 $(ls $name/flexcleaned_2.fastq)

 echo "Completed running PathoMAP on human for $name"


pathoscope ID \
 -outDir $name/human \
 -thetaPrior 10000000 \
 -alignFile $name/human/outalign.sam

 echo "Completed running PathoID on human for $name"


# this removes all unnecessary files that are taking up a lot of room.
rm $name/human/pathomap-*

#---Complete job
t2=$(date +"%s")
diff=$(($t2-$t1))
echo "[---$SN---] ($(date)) $(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."
echo "[---$SN---] ($(date)) $SN COMPLETE."
