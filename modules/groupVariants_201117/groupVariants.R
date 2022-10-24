#
# Grouping variants
#
# ---------------------------------------------
#
# Set relative path an source enviroment
#


rm(list = ls())
set.seed(100)
DIR <- system(intern = TRUE, ignore.stderr = TRUE,
           "cd \"$( dirname \"${BASH_SOURCE[0]}\" )\" && pwd ")

library(SeqVarTools)
gdsfns <- list.files("../../data/gds",
                     pattern = "dbnsfp.geneset.gds",
                     full.names = T)

args <- commandArgs(trailingOnly = TRUE)
i <- as.numeric(args[1])
print(i)

# ---------------------------------------------
#
# load 
#

gdsfn <- gdsfns[i]
gds <- seqOpen(gds.fn = gdsfn)

chr <- gsub("ukb23156_c(\\d+)_v1.+",
           "\\1",
           basename(gdsfn))



# ---------------------------------------------
#
# make info table
#

# source("makeInfoTable.R")


# ---------------------------------------------
#
# add external maf annotations
#

# source("mafAnnotations.R")

# ---------------------------------------------
#
# save tab
#

# source("saveTab.R")

# ---------------------------------------------
#
# add cadd
#


# system("bash runCADD.sh")
#for (chr in 1:22) {
#    source("caddAnnotations.R")
#}

# ---------------------------------------------
#
# group variants
#

## for (chr in 1:22) {

##     source("group_LOF.R")
##     source("group_raremissense.R")
##     source("group_w_raremissense.R")
##     source("group_skat_missense.R")
## }





# ---------------------------------------------
#
# fix alleles 
#

#source("fixAlleles.R")


#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################


## variantid <- seqGetData(gds, var.name = "variant.id")

## library(GenomicScores)
## gr <- granges(gds)
## allele <- seqGetData(gds, "allele")
## allele <- do.call(rbind, strsplit(allele, ","))

## # BiocManager::install("GenomicScores")
## # BiocManager::install("MafDb.TOPMed.freeze5.hg38")
## library(MafDb.TOPMed.freeze5.hg38)
## mafdb <- MafDb.TOPMed.freeze5.hg38
## populations(mafdb)
## # BiocManager::install("MafDb.gnomADex.r2.1.GRCh38")
## library(MafDb.gnomADex.r2.1.GRCh38)

## mafdb <- MafDb.gnomADex.r2.1.GRCh38
## detach("package:SeqArray", unload = TRUE)


## popmax <- gscores(mafdb, gr, pop=c("AF_popmax"))

## varname <- "annotation/info/dbNSFP_gnomAD_genomes_POPMAX_AF"
## ann <- seqGetData(gds, varname)
## ann$data <- as.numeric(ann$data)
## gnomAD_POPMAX_AF <- rep(0, length(ann$length))
## varid <- rep(variantid, ann$length)
## datalist <- split(ann$data, varid)

## # rm multiple entries
## idxMultiple <- which(lengths(datalist) > 1)
## for(i in idxMultiple) {
##     #print(i)
##     datalist[[i]] <- max(datalist[[i]])
## }

## data <- unlist(datalist)
## names(popmax) <- as.character(variantid)

