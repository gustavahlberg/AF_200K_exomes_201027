library("SeqVarTools")
args = commandArgs(trailingOnly=TRUE)
print(args)
vcf = args[1]
gds = args[2]
cores = as.numeric(args[3])

# vcf='tmp.gz'
# gds='tmp.gds'

#cores=1
seqVCF2GDS(vcf, gds, parallel = cores)


#gds = seqOpen(gds)
# ann = seqGetData(gds, 'annotation/info/ANN')
#tmp = seqGetData(gds, 'annotation/info/dbNSFP_gnomAD_genomes_POPMAX_AF')


## idx = which(tmp$length == 3) 
## varid = seqGetData(gds, 'variant.id')
## seqSetFilter(gds, variant.id = varid[idx])
## seqGetData(gds, "allele")
## varid = varid[idx]
## varid
## idx = rep(1:406139,tmp$length)
## data = tmp$data
## names(data) <- idx
## data[names(data) %in% as.character(varid[1])]
## data[as.character(varid[1])]
## as.character(varid[1])
