#This is trying to use maaslin2 to find associations between microbiome multi'omics features.
#Rebecca Clement rebeccaclement@gwu.edu
# 3 September 2019
#Install devtools and bioconductor dependencies
install.packages('devtools'); 
library('devtools');
install.packages('BiocManager'); 
library('BiocManager');
BiocManager::install('edgeR')
BiocManager::install('metagenomeSeq')
BiocManager::install('lpsymphony')
#Install MaAsLin2 (and also all dependencies from CRAN). For tagged version information, please visit the bioBakery page for MaAsLin2. “Tip” will download the latest development build.
devtools::install_bitbucket("biobakery/maaslin2@default", ref="0.99.12")
library(Maaslin2)
input_data <- system.file(
  'extdata','HMP2_taxonomy.tsv', package="Maaslin2")
input_metadata <-system.file(
  'extdata','HMP2_metadata.tsv', package="Maaslin2")
fit_data <- Maaslin2(
  input_data, input_metadata, 'demo_output', transform = "AST",
  fixed_effects = c('diagnosis', 'dysbiosisnonIBD','dysbiosisUC','dysbiosisCD', 'antibiotics', 'age'),
  random_effects = c('site', 'subject'),
  standardize = FALSE)
#Get the raw data and transpose so that rows are samples, columns are otus
meni_raw_otu<-t(as.data.frame(pathoscope.phy@otu_table))
meni_raw_otu_test <- as.data.frame(meni_raw_otu)
# The data file can contain samples not included in the metadata file (along with the reverse case). For both cases, those samples not included in both files will be removed from the analysis. Also the samples do not need to be in the same order
#filter so we are looking at just the rows we care about
#unwanted_names <- c("11S","12S","13S","13V1","13V2","3S","4S","7S","8S","9S","zymo")
#nameV <- rownames(meni_raw_otu) %in% unwanted_names
#meni_otu.f<- meni_raw_otu[nameV == FALSE,]
#write.csv(meni_otu.f,"meni_otu.f.csv")
#write.csv(meni_raw_otu,"meni_otu.csv")

#We want to make it so that our OTU table has taxa instead of OTU #s
colnames(meni_raw_otu) <- patho.tax[colnames(meni_raw_otu),"species"]
#check to make sure what first taxa should be
patho.tax["1000562",]

#To wriet data for maaslin2:
write.table(meni_raw_otu, 'meni_otu.txt', sep = "\t", eol = "\n", quote = F, col.names = NA, row.names = T)
#open in excel and then save as .txt tab seperated
#read in combined diversity/dietary metadata
meni_meta<-read.csv("comb_div_diet.csv")
#Select only the columns that we are looking at
meni_meta_sub<-as.data.frame(meni_meta[,c('Total.Fat..g.', 'Energy..kcal.','Total.Dietary.Fiber..g.','Total.Carbohydrate..g.', 'bmi','person','Week')])
row.names(meni_meta_sub)<-meni_meta[,"X"]
#Make it so that person is not numeric but categorical
meni_meta_sub$person <- paste("p",meni_meta_sub$person, sep='')
#Write metadata into a table txt file
write.table(meni_meta_sub, 'meni_meta_sub.txt', sep = "\t", eol = "\n", quote = F, col.names = NA, row.names = T)
#write as a csv and then save as .txt
#write.csv(meni_meta_sub,"meni_meta_sub.csv")


#Allison would like all of them where there are at least 4 (4/14=.28), and all of them no matter what their FDR is
fit_meni<-Maaslin2('meni_otu.txt',
         'meni_meta_sub.txt',
         'linear_model_output',
         fixed_effects = c('Total.Fat..g.', 'Energy..kcal.','Total.Dietary.Fiber..g.','Total.Carbohydrate..g.', 'bmi','Week'),
         random_effects = c('person'),
         max_significance = 1,
         analysis_method = 'LM',
         normalization = 'TSS',
         transform = 'log',
         min_abundance = 0.0,
         min_prevalence = 0.28)

#Ali says to use this setup if the data is zero inflated. It takes forever
zi_fit_meni<-Maaslin2('meni_otu.txt','meni_meta_sub.txt', 'linear_model_output/zicp',
        fixed_effects = c('Total.Fat..g.', 'Energy..kcal.','Total.Dietary.Fiber..g.', 'bmi','Week'),
        #random_effects = c('person'),
        max_significance = .2,
        analysis_method = 'ZICP',
        normalization = 'NONE',
        transform = 'NONE',
        min_abundance = 0.0,
        min_prevalence = 0.28)

