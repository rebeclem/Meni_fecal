# Troubleshooting

## Some things to try

* Try running pathoscope against phiX
* Try cleaning the reads using prinseq using prinseq script
* Prinseq will give you three files as output. You can discard the one called `filename_prinseq_bad_string.fastq` and the one called `filename_prinseq_good_singletons_string.fastq`, and then run pathoscope on the one called `filename_prinseq_good_string.fastq`.
* Compare the number of unique reads found by using the count.uniq.py script with those given in your .tsv files. Use the command `grep "Total Number of Aligned" * > aligned.csv` to extract just the line with the number of aligned into a csv file.
