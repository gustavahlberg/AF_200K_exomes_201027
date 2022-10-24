#
#
# load qctables etc
#
# ---------------------------------------------
#
# load tables
#

# path on server
# pathQC="/home/projects/cu_10039/data/UKBB/RelatednessETC/"
# path on local
pathQC="/Users/gustavahlberg/Projects/ManageUkbb/data/RelatednessETC/"



sqc_file = paste0(pathQC,"ukb_sqc_v2.txt.gz")
hdr_file = paste0(pathQC,"colnames")
fam_file = paste0(pathQC,"ukb43247_cal_chr1_v2_s488282.fam")

sqc <- fread(sqc_file,stringsAsFactors=F)
sqc <- data.frame(sqc)
sqc <- sqc[,3:ncol(sqc)]
fam <- fread(fam_file)
fam <- data.frame(fam)
eid <- as.character(fam$V1)

sqc2 <- cbind.data.frame(eid,sqc)

hd <- read.table(hdr_file)
## add sample names
hd <- c(c('eid'),as.character(hd$V1)[1:nrow(hd)])
names(sqc2) <- hd

relTab = read.table(paste0(pathQC,"ukb43247_rel_s488288.dat"),
                    header = T,
                    stringsAsFactors = F)

qcTab = fread(paste0(pathQC,"geneticSampleLevel_QCs_190527.tsv.gz"),
              header = T,
              stringsAsFactors = F)

sample2CKExomes <- as.character((read.table("../../data/sampleList_200Kexomes.txt")$V1))

#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
