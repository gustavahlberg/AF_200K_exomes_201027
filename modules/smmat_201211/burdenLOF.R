# ---------------------------------------------
#
# Burden LOF
#
# ---------------------------------------------
#
# load data
#

library(SeqVarTools)

#load("../nullmodel_201202/results/model0_210213.Rdata", verbose = T)

group_file <- paste0("../groupVariants_201117/groups/group_LOF/set_lof_chr", chr, ".txt")

# group_file <- "../groupVariants_201117/groups/group_LOF/test_lof.txt"
# group_file <- "../groupVariants_201117/groups/group_LOF/test_TTN.txt"
geno_file <- "../../data/ukb23156_ALL_v1.filter.miss.norm.gds" 
#gds <- seqOpen(geno_file)
#seqClose(gds)


#seqSetFilter(gds, variant.id = 1)
#tmp <- getGenotype(gds)


# ---------------------------------------------
#
# Variant set tests
#


res <- SMMAT(model0,
             group.file = group_file,
             geno.file = geno_file,
             MAF.range = c(1e-7, 0.5),
             miss.cutoff = 0.1,
             tests = c("B", "E"),
             MAF.weights.beta = c(1, 1),
             verbose = TRUE
             )

             #ncores = cores

# ---------------------------------------------
#
# Save
#

res <- res[order(res$E.pval, decreasing = F), ] 
res_fn <- paste0(outPath, "/burden_lof_chr", chr, ".txt")
#res_fn <- paste0("results/burden_lof_chr", chr, ".txt")

write.table(file = res_fn,
            res,
            col.names = T,
            row.names = F,
            quote = F,
            sep = "\t"
            )


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################







