# ---------------------------------------------
#
# make info table
#
# ---------------------------------------------
#
# info annotation
#


header <- c("Allele", "Annotation", "Annotation_Impact", "Gene_Name", "Gene_ID", "Feature_Type", "Feature_ID", "Transcript_BioType", "Rank", "HGVS.c", "HGVS.p", "cDNA.pos/cDNA.length", "CDS.pos/CDS.length", "AA.pos/AA.length", "Distance", "ERRORS/WARNINGS/INFO")

varname <- "annotation/info/ANN"
ann <- seqGetData(gds, varname)

ann$data <- paste0(ann$data, " ")

infomat <- do.call(rbind, strsplit(ann$data, "\\|"))
colnames(infomat) <- header

varid <- rep(1:length(ann$length), ann$length)
infomat <- cbind(varid, infomat)


# ---------------------------------------------
#
# Select Moderate and High impact
#

idxeffect <- which(infomat[, "Annotation_Impact"] %in% c("HIGH", "MODERATE"))


infomat <- infomat[idxeffect, ]
infomat <- as.data.frame(infomat, stringsAsFactors = F)

# rm pseudo genes
biotypes <- unique(infomat[, "Transcript_BioType"])
idxpseudo <- which(infomat$Transcript_BioType %in% biotypes[grep("pseudogene", biotypes)])

infomat <- infomat[-idxpseudo, ]

# ---------------------------------------------
#
# add MAF etc
#

seqSetFilter(gds, variant.id = as.numeric(unique(infomat$varid)))

varname <- "annotation/info/EUR_MAF"
ann <- seqGetData(gds, varname)
names(ann) <- seqGetData(gds, var.name = "variant.id")
infomat$maf <- ann[infomat$varid]

varname <- "annotation/info/EUR_AC_ALT"
ann <- seqGetData(gds, varname)
names(ann) <- seqGetData(gds, var.name = "variant.id")
infomat$ac <- ann[infomat$varid]

varname <- "annotation/info/EUR_AN"
ann <- seqGetData(gds, varname)
names(ann) <- seqGetData(gds, var.name = "variant.id")
infomat$an <- ann[infomat$varid]

## varname <- "annotation/info/ExcHet"
## ann <- seqGetData(gds, varname)
## names(ann) <- seqGetData(gds, var.name = "variant.id")
## infomat$exchet <- ann[infomat$varid]


# ---------------------------------------------
#
# rm AC = 0 & ExcHet < 0.05
#

sum(infomat$ac == 0 )
idxrm <- which(infomat$ac == 0 )

infomat <- infomat[-idxrm, ]




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################


## seqSetFilter(gds, variant.id = as.numeric(unique(infomat$varid)))

## varname <- "annotation/info/dbNSFP_CADD_phred"
## ann <- seqGetData(gds, varname)
## names(ann$length) <- seqGetData(gds, var.name = "variant.id")

## infomat[infomat$varid == 23, ]



## varname <- "annotation/info/dbNSFP_CADD_phred"

## varname <- "annotation/info/dbNSFP_UK10K_AF"
## # varname <- "annotation/info/dbNSFP_gnomAD_genomes_POPMAX_AF"
## ann <- seqGetData(gds, varname)
## ann$data <- as.numeric(ann$data)
## gnomAD_POPMAX_AF <- rep(0, length(ann$length))
## varid <- rep(1:length(ann$length), ann$length)
## datalist <- split(ann$data, varid)

## # rm multiple entries
## idxMultiple <- which(lengths(datalist) > 1)
## for(i in idxMultiple) {
##     print(i)
##     datalist[[i]] <- max(datalist[[i]])
## }

## data <- unlist(datalist)



## infomat <- do.call(rbind, strsplit(ann$data, "\\|"))
## colnames(infomat) <- header

## varid <- rep(1:length(ann$length), ann$length)
## infomat <- cbind(varid, infomat)



## for (i in which(duplicated(varid))) {
##     print(c(ann$data[i - 1], ann$data[i]))
##     vec = c(ann$data[i - 1], ann$data[i])
##     idx <- which.max(c(ann$data[i - 1], ann$data[i]))
##     c(ann$data[i - 1], ann$data[i])[idx]
## }
