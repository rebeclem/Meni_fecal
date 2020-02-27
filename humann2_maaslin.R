# Humann2/Maaslin2 for functional analysis
# Rebecca Clement rebeccaclement@gwu.edu
# January 29, 2020

# We ran into many issues trying to do humann2_associate on the terminal so decided we might have better luck doing it in R with Maaslin2. We actually received an email saying that it would be better just to do Maaslin2 that humann2_associate.
# There are a bunch of ones with the output ungrouped
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
install.packages("Maaslin2")
library(Maaslin2)


install.packages("Maaslin2")
library(tidyverse)
library(Maaslin2)

#first do it for pathabund
raw_pathabund <- read_tsv('../../humann2/edited_humann2_pathabundance.tsv') %>%
  t()
raw_pathabund<-raw_pathabund[,2:2992]
write.table(x = raw_pathabund, file = 'rawpath.txt', sep = '\t', row.names = TRUE, col.names = FALSE)

fit_function<-Maaslin2('rawpath.txt',
                      'metapath.txt',
                      'rawpath',
                      fixed_effects = c('Treatment'),
                      random_effects = c('Person'),
                      max_significance = .94,
                      analysis_method = 'LM',
                      normalization = 'TSS',
                      transform = 'log',
                      min_abundance = 0.0,
                      min_prevalence = 0.28)

#Do the same but with pathabund_go

raw_pathabund_go <- read_tsv('../../humann2/edited_humann2_pathabundance_go.tsv') %>%
  t()
raw_pathabund_sub<-raw_pathabund_go[,2:320]
metapath<-raw_pathabund_go[,1]
#meta_genefam<-cbind(row.names(raw_genefam),meta_genefam)
metapath<-cbind(metapath,c("Person",rep("P11",3),rep("P12",3),rep("P13",3),rep("P3",3),rep("P4",3),rep("P7",3),rep("P8",3),rep("P9",3)))
metapath<-cbind(metapath,treats)
write.table(x = raw_pathabund_sub, file = 'pathabundgo.txt', sep = '\t', row.names = TRUE, col.names = FALSE)
write.table(x = metapath, file = 'metapath.txt', sep = '\t', row.names = TRUE, col.names = FALSE)

fit_function<-Maaslin2('pathabundgo.txt',
                       'metapath.txt',
                       'func_pathabundgo',
                       fixed_effects = c('Treatment'),
                       random_effects = c('Person'),
                       max_significance = 1,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)



#Do the same but with genefamilies
raw_genefam <- read_tsv('../../humann2/edited_humann2_genefamilies.tsv') %>%
  t()
raw_genefam_sub<-raw_genefam[,2:1727869]
meta_genefam<-raw_genefam[,1]
meta_genefam<-cbind(row.names(raw_genefam),meta_genefam)
meta_genefam<-cbind(meta_genefam,c("Person",rep("P11",3),rep("P12",3),rep("P13",3),rep("P3",3),rep("P4",3),rep("P7",3),rep("P8",3),rep("P9",3)))
#I want to add a column that will separate S&V1 from V2
treats<-c("Treatment",rep(c("SV1","SV1","V2"),8))
meta_genefam<-cbind(meta_genefam,treats)
write.table(x = raw_genefam_sub, file = 'genefam.txt', sep = '\t', row.names = TRUE, col.names = FALSE)
write.table(x = meta_genefam, file = 'metagene.txt', sep = '\t', row.names = TRUE, col.names = FALSE)

fit_function<-Maaslin2('genefam.txt',
                       'metagene.txt',
                       'func_genefam',
                       #fixed_effects = c('STATUS'),
                       #changing so that it does treatment instead of splitting s, v1,v2
                       fixed_effects = c('Treatment'),
                       random_effects = c('Person'),
                       max_significance = .99,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)




#Do the same but with genefamilies_go

raw_genefam_go <- read_tsv('../../humann2/edited_humann2_genefamilies_go.tsv') %>%
  t()
raw_genefam_sub<-raw_genefam_go[,2:159474]
#meta_genefam<-raw_genefam[,1]
#meta_genefam<-cbind(row.names(raw_genefam),meta_genefam)
#meta_genefam<-cbind(meta_genefam,c("Person",rep("P11",3),rep("P12",3),rep("P13",3),rep("P3",3),rep("P4",3),rep("P7",3),rep("P8",3),rep("P9",3)))
write.table(x = raw_genefam_sub, file = 'genefamgo.txt', sep = '\t', row.names = TRUE, col.names = FALSE)
#write.table(x = meta_genefam, file = 'metagene.txt', sep = '\t', row.names = TRUE, col.names = FALSE)

fit_function<-Maaslin2('genefamgo.txt',
                       'metagene.txt',
                       'func_genefamgo_wrand',
                       fixed_effects = c('Treatment'),
                       random_effects = c('Person'),
                       max_significance = .99,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)



 #Do the same but with pathcoverage

raw_pathcov<- read_tsv('../../humann2/edited_humann2_pathcoverage.tsv') %>%
  t()
raw_pathcov_sub<-raw_pathcov[,2:2992]
meta_cov<-raw_pathcov[,1]
#meta_genefam<-cbind(row.names(raw_genefam),meta_genefam)
meta_cov<-cbind(meta_cov,c("Person",rep("P11",3),rep("P12",3),rep("P13",3),rep("P3",3),rep("P4",3),rep("P7",3),rep("P8",3),rep("P9",3)))
meta_cov<-cbind(meta_cov,treats)
write.table(x = raw_pathcov_sub, file = 'pathcov.txt', sep = '\t', row.names = TRUE, col.names = FALSE)
write.table(x = meta_cov, file = 'metacov.txt', sep = '\t', row.names = TRUE, col.names = FALSE)

fit_function<-Maaslin2('pathcov.txt',
                       'metacov.txt',
                       'func_pathcov ',
                       fixed_effects = c('Treatment'),
                       random_effects = c('Person'),
                       max_significance = .99,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)

### We ran all first without taking random effects into account. Now I want to run them combining S&V1 into one category
# nothing was significant so we decided to try on sample data just to make sure we're doing everything OK
fit_function<-Maaslin2('HMP2_taxonomy.tsv',
                       'HMP2_metadata.tsv',
                       'test_maaslin2',
                       #fixed_effects = c('STATUS'),
                       #changing so that it does treatment instead of splitting s, v1,v2
                       fixed_effects = c('diagnosis'),
                       random_effects = c('site','subject'),
                       max_significance = .99,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)

pathcov <- read.table("../../humann2/edited_humann2_pathcoverage.tsv",header=F,row.names=1,sep="\t")
pathabund <- read.table("../../humann2/edited_humann2_pathabundance.tsv",header=F,sep="\t")
genefam <- read.table("../../humann2/edited_humann2_genefamilies.tsv",header=F,row.names=1,sep="\t")

pathabund_go <- read.table("../../humann2/edited_humann2_pathabundance_go.tsv",header=F,row.names=1,sep="\t")
genefam_go <- read.table("../../humann2/edited_humann2_genefamilies_go.tsv",header=F,row.names=1,sep="\t")

pathabund_sub<-pathabund[c(1,3:2992),]
pathabund.t<-as.data.frame(t(as.matrix(pathabund_sub)))

#look at the structure of these
dim(pathcov) #2992x24 
dim(pathabund) #2992x24
dim(genefam) #1727870x24
dim(pathabund_go) #321x24
dim(genefam_go) #159475x24

library(Maaslin2)
#We need to put these in so that the rows are samples, columns are things you want to test
pathnames<-rownames(pathabund)
pathnames<-gsub("[[:space:]]", "_", pathnames)
pathnames<-gsub("\t","_",pathnames)
rownames(pathabund)<-pathnames
pathabund.t<-as.data.frame(t(as.matrix(pathabund)))
pathabund.t<-as.data.frame(pathabund.t)
#path_meta<-pathabund.t[,1:2]
pathabund_sub<-pathabund[c(1,3:2992)]
#pathabund2 <- pathabund_sub[-1,]
#colnames(pathabund2) <-pathabund_sub[1]
#Try taking all the white space out of the names
#install.packages("stringr")
library(stringr)
names(x)<-str_replace_all(names(x), c(" " = "." , "," = "" ))
pathnames<-names(pathabund_sub)
#pathabund_sub[1,]<-str_replace_all(pathabund_sub[1,], c(" " = "." , "," = "",": "="_"))
#whitespace <- " \t\n\r\v\f"
path_meta[,3]<-c(rep(11,3),rep("P12",3),rep("P13",3),rep("P3",3),rep("P4",3),rep("P7",3),rep("P8",3),rep("P9",3))
colnames(path_meta[3])<-"Person"
names(path_meta) <- c('ID','STATUS','Person')
path_meta <-t(path_meta)
path_meta <- as.data.frame(path_meta)

#Set rownames to first row
#pathabund[,1]<-rownames(pathabund)

#do we need to account for the fact that some of these are from the same people?

#To wriet data for maaslin2:
write.table(path_meta, 'pathmeta.txt', eol = "\n",quote = F, sep = "\t", col.names = T, row.names = F)
write.table(pathabund.t, 'pathabundt.txt', eol = "\n",quote = F, sep = "\t", col.names = F, row.names = F)
#write.csv(pathabund_sub, "pathabund.csv")


#Now what we want to do is do tests to see if there is a functional difference between ones that are S, V1 and V2
#treatment<-pathabund[,1]

#Select only the columns that we are looking at
#meni_meta_sub<-as.data.frame(meni_meta[,c('Total.Fat..g.', 'Energy..kcal.','Total.Dietary.Fiber..g.','Total.Carbohydrate..g.', 'bmi','person','Week')])
#row.names(meni_meta_sub)<-meni_meta[,"X"]

fit_function<-Maaslin2('rawpath.txt',
                   'pathmeta.txt',
                   'rawpath',
                   fixed_effects = c('STATUS'),
                   random_effects = c('Person'),
                   max_significance = .25,
                   analysis_method = 'LM',
                   normalization = 'TSS',
                   transform = 'log',
                   min_abundance = 0.0,
                   min_prevalence = 0.28)

fit_function2<-Maaslin2(pathabund_sub,
                       path_meta,
                       'func2',
                       fixed_effects = c('STATUS'),
                       random_effects = c('Person'),
                       max_significance = .25,
                       analysis_method = 'LM',
                       normalization = 'TSS',
                       transform = 'log',
                       min_abundance = 0.0,
                       min_prevalence = 0.28)
