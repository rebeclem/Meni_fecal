# Part 6 - Pathoscope

We will map to Pathoscope twice. First, targetting human. We want to know how much human "contamination" is in our samples - how many reads belong to human. Second, we will map to the bacterial databases.

You must be in the Analysis folder before calling any of the Pathoscope scripts.
```
cd Analysis
```
These pathoscope files have been changed from Keylie's in the following ways: Removed the PhiX174, and got rid of the 1-91 array line.
### **_Mapping to Human_**
You will need the [`pathoscope_human.sh`](pathoscope_human.sh) file.
```
sbatch -a 1-$(wc -l < ../samps.txt) ../scripts/pathoscope_human.sh
```

### **_Mapping to Bacteria_**
You will need the [`pathoscope_bacteria.sh`](pathoscope_bacteria.sh) file.
```
sbatch -a 1-$(wc -l < ../samps.txt) ../scripts/pathoscope_bacteria.sh
```

In both of these files you will see the same format:
1. Make a directory for the files.
2. Load the software needed.
3. Call PathoScope MAP
    - This maps the reads to the genomes in the databases that we have listed. It then filters out any reads that map *better* to any of the genomes in the filter databases that we have listed.
4. Call PathoScope ID
    - This assigns taxonomic ID numbers to all of the mapped reads.
5. Removes all of the unnecessary `sam` files, because `sam` files take up a lot of room (we're talking Terabytes worth of data room).

<br />

---
---

Once finished, you need to do one more thing. 
Run the following command on your local computer. This command downloads the `tsv` files from each sample. The `tsv` files are the output from PathoID that we will take into R to visualize.

This command needs to be excuted on your local computer (not within colonial one). I recommend opening up another tab on your terminal and then executing this command:
```
mkdir -p pathoscope_output
while read k; do
    scp your_username@login.colonialone.edu:path/to/Analysis/${k}/pathoid-sam-report.tsv local/dir/pathoscope_output/${k}_pathoid-sam-report.tsv
done <samps.txt
```
>Remember, you will need to replace a few things. As an example for you, I have used my path and username.
>
>| your_username | path/to/Analysis | local/dir |
>| --- | --- | --- |
>| kmgibson | /lustre/EV_konzo/Analysis | ~/Documents/EVKonzo |
>
