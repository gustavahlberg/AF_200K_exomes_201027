library(SeqArray)
args = commandArgs(trailingOnly=TRUE)
print(args)
bed.fn = args[1]
bim.fn = args[2]
fam.fn = args[3]
gds.fn = args[4]
cores = args[5]

seqBED2GDS(bed.fn = bed.fn,
           bim.fn = bim.fn,
           fam.fn = fam.fn,
           out.gdsfn = gds.fn,
           parallel = as.numeric(cores))
