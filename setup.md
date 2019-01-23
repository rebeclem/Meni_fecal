
## Do this in the fastq generation directory

### Creating a directory for each sample.
For every file inside a folder that has a L001 and an R1, make an object samp that is the folder name. Print the folder name and then make a directory that is called the sample name with a designated prefix.
* The ${f%%_*}; is essentially calling the file name and taking out the longest possible thing that includes _* in it
```
   for f in */*L001*R1*.gz;
   do samp=${f%%_*};
   echo ${samp};
   mkdir -p $samp;
done
```
### Moving all sequence files into sample directory.
Move all the files into the folders that match their directory.
```
for f in */*.gz;
   do samp=${f%%_*};
   mv $f $samp;
done
```

### Combining all NextSeq sequencing runs into a single fastq file
```
for d in *;
     do     samp=${d%%_*};
     cat $d/*R1*.fastq.gz > $d/${samp}_R1.fastq.gz;
     cat $d/*R2*.fastq.gz > $d/${samp}_R2.fastq.gz;
     echo $samp;
 done
```
### removes all the extra fastq files
```
rm */*L00?_R1*.gz
rm */*L00?_R2*.gz
```

### Remove directories that have ds in them
```
rm -r *ds*
```
***
## Setting up workspace
### Make a list of samples that will be analyzed
```
mkdir Analysis
mkdir refs
mkdir scripts
```
### Move all directories that have more than one layer into the analysis folder
```
find . -maxdepth 1 -type d -exec mv '{}' ./Analysis \;
```

### Move into the analysis directory and put the directory names into a file called samp.txt
```
cd Analysis
ls -d * > ../samps.txt
```

### Set up reference databases
```
cd refs 
```

#### Human reference
```
for f in /lustre/groups/cbi/shared/References/Homo_sapiens/UCSC/hg38full/Sequence/Bowtie2Index/*.bt2;
 do
    ln -s $f
done
```
#### Bacteria references
```
for f in /lustre/groups/cbi/shared/Databases/NCBI_rep_genomes/latest/*.bt2;
do
    ln -s $f
done
```
### PhiX references -include this if you have PhiX in your samples (added during sequencing)
```
for f in /lustre/groups/cbi/shared/Databases/HMP/latest/phi*.bt2; do
    ln -s $f
done
```
***
Next Step: [Perform FastQC](fastqc.md)
