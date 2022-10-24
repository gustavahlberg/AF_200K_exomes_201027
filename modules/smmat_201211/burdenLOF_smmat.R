# ---------------------------------------------
#
# Burden LOF
#
# ---------------------------------------------
#
# load data
#

library(SeqVarTools)

# load("../nullmodel_201202/results/model0_210213.Rdata", verbose = T)

group_file <- paste0("../groupVariants_201117/groups/group_LOF/set_lof_chr", chr, ".txt")

# group_file <- "../groupVariants_201117/groups/group_LOF/test_lof.txt"
# group_file <- "../groupVariants_201117/groups/group_LOF/test_TTN.txt"
geno_file <- "../../data/ukb23155_ALL_b0_v1.gds" 

#gds <- seqOpen(geno_file)
#seqClose(gds)




# ---------------------------------------------
#
# Variant set tests
#


res <- SMMAT(model0,
             group.file = group_file,
             geno.file = geno_file,
             MAF.range = c(1e-7, 0.5),
             miss.cutoff = 0.1,
             tests = c("B", "O", "E"),
             verbose = TRUE,
             ncores = cores
             )

# ---------------------------------------------
#
# Save
#

res <- res[order(res$E.pval, decreasing = F), ] 
res_fn <- paste0(outPath, "/burden_smmat_lof_chr", chr, ".txt")

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







