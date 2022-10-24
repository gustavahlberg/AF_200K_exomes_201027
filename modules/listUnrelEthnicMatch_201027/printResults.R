
write.table(x = sample.eth.id,
            file = "results/samplesUKBB.etn.201030.list",
            col.names = F,
            row.names = F,
            quote = F)


sum(sample.eth.id %in% sample2CKExomes)
sample.eth.2CKEx.id <- sample.eth.id[which(sample.eth.id %in% sample2CKExomes)]

write.table(x = sample.eth.2CKEx.id,
            file = "results/samples200Kexomes.etn.201030.list",
            col.names = F,
            row.names = F,
            quote = F)