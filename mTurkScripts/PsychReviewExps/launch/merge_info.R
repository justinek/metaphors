library(plyr)
library(tidyr)
expt <- "scalarFree1"
n_rounds <- 4

dirpath<-(paste(expt, '/', sep=""))

rounds<-seq(1,n_rounds,1)

## merge invoices
invoice<-data.frame()
for (i in rounds){
  inv<-read.csv(paste(dirpath, "round",i,'/', expt,"_invoice.csv", sep=""))
  invoice<-rbind(invoice,inv[1:9,])
}

write.csv(invoice,
          paste(dirpath,expt,"-totalinvoice.csv", sep=""))

### merge data sets
num_round_dirs = 4
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.table(paste(dirpath,
                         'round', i, '/',expt,'_anonymized.results', sep=''), sep="\t", header=TRUE) %>%
            mutate(workerid = (workerid + (i-1)*9)))}))

write.table(df,
          paste("../../../Data/PsychReviewExps/",expt,"_raw.csv", sep=""),
          row.names=F, sep="\t")


### merge subject info
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.csv(paste(dirpath,
                         'round', i, '/',expt,'-subject_information.csv', sep='')) %>%
            mutate(workerid = (workerid + (i-1)*9)))}))

write.csv(df,
          paste("../../data/",expt,"-subject_information.csv", sep=""),
          row.names=F)



### merge catch info
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.csv(paste(dirpath,
                         'round', i, '/',expt,'-catch_trials.csv', sep='')) %>%
            mutate(workerid = (workerid + (i-1)*9)))}))

write.csv(df,
          paste(dirpath,"../../data/",expt,"-catch_trials.csv", sep=""),
          row.names=F)