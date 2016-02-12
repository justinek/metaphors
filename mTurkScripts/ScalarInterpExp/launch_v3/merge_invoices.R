expt <- "interp_v3_fixedbug"
n_rounds <- 3

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
num_round_dirs = 3
df = do.call(rbind, lapply(1:num_round_dirs, function(i) {
  return (read.delim(paste(dirpath,
                         'round', i, '/',expt,'_anonymized.results', sep='')) %>%
            mutate(workerid = (workerid + (i-1)*9)))}))

write.table(df,
          paste("../../../Data/ScalarInterpExp/",expt,"_raw.txt", sep=""),
          row.names=F, sep="\t", quote=FALSE)

