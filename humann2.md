Follow [`humann2.md`](https://github.com/kmgibson/EV_konzo/blob/master/humann2.md) instructions.

Here we will complete functional analysis on the whole shotgun metagenomic reads. We will get a list of pathways and GO terms.


HUMAnN2: The HMP Unified Metabolic Analysis Network 2
<br/>
See [general overview here](http://huttenhower.sph.harvard.edu/humann2), [manual here](https://bitbucket.org/biobakery/humann2/wiki/Home) and a [tutorial here](https://bitbucket.org/biobakery/biobakery/wiki/humann2).


# Working Pipeline for Vilain's group
# Part 8 - Functional Analysis with HUMAnN2

Here we will call a set of scripts to complete HUMAnN2 functional analysis.

1. [`humann2.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/humann2.sh)
2. [`h2_renorm.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_renorm.sh)
3. [`h2_join_tab.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_join_tab.sh)
4. [`h2_associate.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_associate.sh)
5. [`h2_regroup_go.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_regroup_go.sh)
6. [`h2_go_associate.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_go_associate.sh)


You must be in the Analysis folder before calling any of the HUMAnN2 scripts.
```
cd Analysis
```

You will need to make a new list that doesn't include the control. An easy way to do that is by this command:
```
ls -d Konzo?? > humann_list.txt
```
There should only be 88 samples.

<br />

---
### Step 1. `humann2.sh`

This step runs HUMAnN2 on all the samples. Call the script as such:

```
sbatch ../scripts/humann2.sh
```
The results form this step will give you three main output files for each input file named `${name}_genefamilies.tsv`, `${name}_pathabundance.tsv`, and `${name}_pathcoverage.tsv` all in each of the samples' directory (example: `Analysis/Konzo01/humann2_full/`.

<br />

---
### Step 2. `h2_renorm.sh`

The next step is to normalize the abundance output files. First we want to create a directory where all of the output files will be placed.
```
mkdir -p humann2_results &&
sbatch ../scripts/h2_renorm.sh
```

After this step, the directory `/Analysis/humann2_results/` now has all of the `.tsv` files from all of the samples. 
Example for Konzo01: 
- `Konzo01_genefamilies_relab.tsv`
- `Konzo01_genefamilies.tsv`
- `Konzo01_pathabundance_relab.tsv`
- `Konzo01_pathabundance.tsv`
- `Konzo01_pathcoverage.tsv`

<br />

---
### Step 3. `h2_join_tab.sh`

This step joins all the output files (gene families, coverage, and abundance) from the HUMAnN2 runs from all samples into three files.

```
sbatch ../scripts/h2_join_tab.sh
```
The resulting files from this step are:
`humann2_genefamilies.tsv`, `humann2_pathabundance.tsv`, and `humann2_pathcoverage.tsv` in the output directory `/Analysis/humann2_results/`.

<br />

---
### Step 4. Editing the 3 joined output files

We will need to edit the files `humann2_genefamilies.tsv`, `humann2_pathabundance.tsv`, and `humann2_pathcoverage.tsv` to include a "STATUS" line and an "ID" line.

On the first line of each file change "# Gene Family" (or "# Pathway") to "ID". This is a simple text edit to the file. 

The next step is to add this line: 
```
STATUS	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_casesKahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases
```
<br />

Add this whole line right below the "ID" line. It is the "STATUS" line. Each group is separated by a tab. This line needs to be added below each of the ID lines in each of the three output files.

Save each edited file as: `edited_humann2_genefamilies.tsv`, 
`edited_humann2_pathabundance.tsv`, and 
`edited_humann2_pathcoverage.tsv`, respectively.

<br />

---
### Step 5. h2_associate.sh

This step is a statistical aid. It uses the lines "ID" and "STATUS" from the previous step (Step 4).

```
sbatch ../scripts/h2_associate.sh
```

There are three output files after this command as well: `stats_genefamilies_test.txt`, `stats_pathabun_test.txt`, and `stats_pathcoverage_test.txt`. When looking at the results, use the Q-value column because the Q-value takes into account the multiple testings for p-value.

<br />

---
### Step 6. h2_regroup_go.sh

This step regroups the pathways and genefamilies into GO terms.

```
sbatch ../scripts/h2_regroup_go.sh
```

There are two output files from this command: `humann2_pathabundance_go.tsv` and `humann2_genefamilies_go.tsv`.

<br />

---
### Step 7. Editing the 3 joined output files

Basically repeat Step 4:

We will need to edit the files `humann2_pathabundance_go.tsv` and `humann2_genefamilies_go.tsv` to include a "STATUS" line and an "ID" line.

On the first line of each file change "# Gene Family" (or "# Pathway") to "ID". This is a simple text edit to the file. 

Again, add this line: 
```
STATUS	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kinshasa_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_control	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_casesKahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases	Kahemba_cases
```
<br />

Add this whole line right below the "ID" line. It is the "STATUS" line. Each group is separated by a tab. This line needs to be added below each of the ID lines in each of the three output files.

Save each edited file as: `humann2_pathabundance_go.tsv` and `humann2_genefamilies_go.tsv` , respectively.


<br />

---
### Step 8. h2_go_associate.sh

This step is a statistical aid. It uses the lines "ID" and "STATUS" from the previous step (Step 7).

```
sbatch ../scripts/h2_go_associate.sh
```

There are two output file with Q-values from this step: `stats_genefamilies_go.txt` and `stats_pathabun_go.txt`.


<br />

---
## *Now you are finished with functional analysis. You can take the output files and put through MaAsLin or complete your own filtering/exploration in excel or R.*
