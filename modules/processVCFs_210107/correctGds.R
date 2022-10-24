library(SeqVarTools)

gds_fns <- read.table("rereuns.txt")$V2


for (i in 2:length(gds_fns))
    cleanup.gds(gds_fns[i])
