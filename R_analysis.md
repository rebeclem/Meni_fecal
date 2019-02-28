# Part 8 : Visualizing Results with R


## **Files you will need:**
- `samps.txt`
    - List of all the sample names
- `read_count_meni.csv`
    - Created in Part 5 by counting sequencing reads.
- `reads_bac_human.csv`
    - Created in Part 7 by counting number of mapped reads.
- `meni_metadata.csv`
    - List of all the sample names with their corresponding group.
    - This file should be in this format:

| Samp | Group |
| --- | --- |
| Konzo01 | Kinshasa Control |


- `pathoscope_output` directory with all of the `tsv` files.


<br />
<br />

To run analysis, open the [konzo_visualization.Rmd](konzo_visualization.Rmd) file in R-Studio. 

If you do not have R-Studio, download the R-studio desktop version [here](https://www.rstudio.com/products/rstudio/download/#download). 

- Additionally, if you don't have R-studio and have never used it before, you will need to `install` all of the packages before loading them. Loading them is the first step in the `konzo_visualization.Rmd` file. To install a package, use the command:
```
install.packages("package_name")
# example: install.packages("ggplot2")
```
You will need to do this for all the packages that you don't have. 

<br />

###  Once you have all the necessary files and packages installed, run all the code in the `konzo_visualization.Rmd` file and you should be able to produce all the result files.

---
---

## Yay! You've completed analysis for your project!
![alt text](https://github.com/kmgibson/helpful/blob/master/Excellent_bitmoji.png)
