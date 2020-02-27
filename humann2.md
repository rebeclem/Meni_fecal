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
5. [`h2_regroup_go.sh`](https://github.com/kmgibson/EV_konzo/blob/master/scripts/h2_regroup_go.sh)


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

For Keylie's samples, she added a STATUS line but we had a lot of problems, and in the end couldn't get h2_associate to work. Instead, we downloaded the samples and ran them using Maaslin2 on R. We will need to edit the files `humann2_genefamilies.tsv`, `humann2_pathabundance.tsv`, and `humann2_pathcoverage.tsv` to include a "STATUS" line and an "ID" line.

### Step 6. h2_regroup_go.sh

This step regroups the pathways and genefamilies into GO terms.

```
sbatch ../scripts/h2_regroup_go.sh
```

There are two output files from this command: `humann2_pathabundance_go.tsv` and `humann2_genefamilies_go.tsv`.

<br />

---
## *Now you are finished with functional analysis. You can take the output files and put through MaAsLin or complete your own filtering/exploration in excel or R.*
