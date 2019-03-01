# Troubleshooting

## Some things to try

* Try running pathoscope against phiX
* Try cleaning the reads using prinseq using prinseq script
* Prinseq will give you three files as output. You can discard the one called `filename_prinseq_bad_string.fastq` and the one called `filename_prinseq_good_singletons_string.fastq`, and then run pathoscope on the one called `filename_prinseq_good_string.fastq`.
