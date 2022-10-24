library("SeqVarTools")
args = commandArgs(trailingOnly=TRUE)
print(args)
vcf = args[1]
gds = args[2]
cores = as.numeric(args[3])

seqVCF2GDS(vcf, gds, parallel = cores)



