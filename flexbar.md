# QC using Flexbar

Before we can use PathoScope to map our reads to genomes, we first need to "clean" our reads. Now, we call it cleaning because here we remove low quality reads, low quality nucleotides, and any adapter sequences that were left behind by the Illumina processing software. This step is also referred to as trimming our reads.

### __In this step, we will clean our raw sequencing reads.__
<br />

You will need to put the adapter sequences that you used when library prepping your samples into a fasta file. Save adapter sequences for paired-end as `refs/adapters_PE.fa.`

* You can get an adapters file from trimmomatic for Nextera XT by navigating to where trimmomatic is located `module show trimmomatic` and then finding the file called [NexteraPE-PE.fa](NexteraPE-PE.fa).

<br />

Make sure your `samp.txt` is in the folder that contains Analysis, refs, and scripts before submitting [flexbar.sh](flexbar.sh). 

Submit a job to Slurm to call Flexbar on the raw sequence files.
```
sbatch ../scripts/flexbar.sh
```

<br />

The default parameters (the parameters that I use) are:

```
flexbar --threads 10 \
 --adapters refs/adapters_PE.fa \
 --adapter-trim-end RIGHT \
 --adapter-min-overlap 7 \
 --pre-trim-left 5 \
 --max-uncalled 100 \
 --min-read-length 25 \
 --qtrim TAIL \
 --qtrim-format sanger \
 --qtrim-threshold 20 \
 --reads $(read1) \
 --reads2 $(read2) \
 --target flexcleaned
 ```

 If you want to, you can change any of these parameters in the file `flexbar.sh`. You can also add parameter options. To see addition options that you can include call:
 
 ```
 module use /groups/cbi/shared/modulefiles
 module load flexbar/3.0.3
 flexbar -h
 ```
 This will give you a help menu that lists and explains all of the available trimming/filtering options. 


 See [Flexbar's manual](https://github.com/seqan/flexbar/wiki/Manual) for more help if need be.

<br />

 After finishing flexbar, you will now have 3 files:
 1. flexcleaned_1.fastq
 2. flexcleaned_2.fastq
 3. flexcleaned.log

 The first two are the cleaned read1 and read2 fastq files that will be used in subsequent applications (PathoScope). The `flexcleaned.log` will be used in Part 5 where you count the number of raw and cleaned reads. This will tell you how strigent your filtering was. Ideally you want to retain as much of your reads as possible, so if you see in Part 5 or in the `flexcleaned.log` that you only retained, say, about 75% of your reads, maybe you should try less strict filtering options. Unless, of course, you started with very dirty (unreliable, low quality, high adapter contamination,etc) data, then maybe 75% read retainment is alright.

 Understand your starting quality to see if the amount of reads you removed is reasonable.
 
 Next step: run [fastQC](fastqc.md) using [this script](fastqcflexbar.sh) on your cleaned samples inside the `Analysis` folder



You will get two output files for each fastq files (total of 4 files):
1.  `flexcleaned_1_fastqc.html`
2.  `flexcleaned_1_fastqc.zip`
3.  `flexcleaned_2_fastqc.html`
4.  `flexcleaned_2_fastqc.zip`

<br />

Again, the `html` files are the ones that we are interested in. We're going to move all the `html` files into a directory so we can look at all the files at the same time.
```
# remember we're still in the Analysis folder
mkdir -p fastqc_cleaned
mv */flexcleaned*.html fastqc_cleaned/
```
Now download that folder to your computer with this command. This command needs to be excuted on your local computer (not within colonial one). I recommend opening up another tab on your terminal and then executing this command:
```
scp your_username@login.colonialone.edu:path/to/Analysis/fastqc_cleaned /local/dir
```
>You will need to replace a few things, same thing as above. As an example for you, I have used my path and username.
>
>| your_username | path/to/Analysis | local/dir |
>| --- | --- | --- |
>| kmgibson | /lustre/EV_konzo/Analysis | ~/Documents/EVKonzo |
>

<br />
<br />

All of the files can be opened up through Safari/Chrome/etc. (whatever internet browser you use). If you open the downloaded folder in your Finder (if on mac), you can select a file (so it is highlighted) and press the *space* button. A temporary window should show up with your results. Now you can press the *down arrow* and scroll through all the files relatively quickly.

See this [PDF](https://github.com/kmgibson/EV_konzo/blob/master/FastQC_Manual.pdf) explaining the FastQC results or this [website by the creators of FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) that also has explaination of the results. 
- The PDF was downloaded from the [University of Missouri sequencing core](https://dnacore.missouri.edu).

<br />

Finally, we need to remove unncessary files:
```
rm Konzo*/flexcleaned*fastqc.zip
```

<br />
