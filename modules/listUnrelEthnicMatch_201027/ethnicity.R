#
#
# subset to uk etnicity
#
#
# -----------------

ph_cols <- data.frame(
  sample.id=h5read(h5.fn,"sample.id"),
  country=h5read(h5.fn,"f.1647/f.1647")[,1], # country of birth in UK
  country2=h5read(h5.fn,"f.20115/f.20115")[,1], # country of birth outside UK
  ethnic=h5read(h5.fn,"f.21000/f.21000")[,1], # self-report ethnicity
  stringsAsFactors = F
) 


# ---------------------------------------------
#
# filter
#
# Used.in.pca.calculation filter 

qc_pass <- (sqc2$het.missing.outliers==0 &
              sqc2$excluded.from.kinship.inference==0 &
              sqc2$excess.relatives==0 #&
            #sqc2$used.in.pca.calculation==1
)

qc2 <- sqc2[qc_pass,]
ph2 = subset(ph_cols, sample.id %in% qc2$eid)
df <- merge(ph2, qc2, by.y="eid", by.x="sample.id")
df$exome <- 0
df$exome[df$sample.id %in% samplewmh] <- 1


# get self-report whites
df$white <- (df$ethnic %in% c(1,1001,1002,1003))
df$ethnic_miss <- (df$ethnic %in% c(-3,-1,-9999))

df$genCac = rep(0, nrow(df))
samplesGenCac = qcTab$sample.id[qcTab$genCacuasian == 1]
sum(df$sample.id %in% samplesGenCac)
df$genCac[df$sample.id %in% samplesGenCac] <- 1

sum(df$white == T | df$ethnic_miss == T)
dfW <- df[df$white == T | df$ethnic_miss == T,]
dfOth <- df[!df$sample.id %in% dfW$sample.id,]

pcs = dfW[,paste0("PC",1:40)]

# ---------------------------------------------
#
# cluster
#



aberrant_1 <- aberrant(x = pcs[,1:2], niter = 10000,lambda = 40)
aberrant_2 <- aberrant(x = pcs[,3:4], niter = 10000,lambda = 40)
aberrant_3 <- aberrant(x = pcs[,5:6], niter = 10000,lambda = 40)
#aberrant_4 <- aberrant(x = pcs[,7:8], lambda = 60)

length(unique(c(aberrant_1$outlier, aberrant_2$outlier, aberrant_3$outlier)))
idxEthOutliers = unique(c(aberrant_1$outlier, aberrant_2$outlier, aberrant_3$outlier))

dfW$eur_select <- 0 
dfW$eur_select[-idxEthOutliers] <- 1


# check other group
pcRanges = apply((dfW[dfW$eur_select == 1,c("PC1","PC2","PC3","PC4","PC5","PC6")]),2, range)
idxUknw = inside.range(x = dfOth$PC1,r = pcRanges[,1]) &
      inside.range(x = dfOth$PC2,r = pcRanges[,2]) &
      inside.range(x = dfOth$PC3,r = pcRanges[,3]) &
      inside.range(x = dfOth$PC4,r = pcRanges[,4]) &
      inside.range(x = dfOth$PC5,r = pcRanges[,5]) &
  inside.range(x = dfOth$PC5,r = pcRanges[,6]) 
table(dfOth$ethnic[idxUknw])


#sum(sample.id[-idxEthOutliers] %in% sample2CKExomes)
#sum(sample.id[dfW$genCac == 1] %in% sample2CKExomes)

# ---------------------------------------------
#
# Summaries
#


print("versus white British")
table(dfW$in.white.British.ancestry.subset,dfW$eur_select,useNA="al")

print("versus reported ethnicity")
table(dfW$ethnic, dfW$eur_select,useNA="al")

print("versus reported country of birth in UK")
table(dfW$country,dfW$eur_select,useNA="if")

print("versus reported country of birth outside UK")
table(dfW$country2, dfW$eur_select,useNA="if")




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
####
# get white european selection
####
# 
# # get mean and SD of each PC among 
# # the curated white British sample
# # and self-reported whites
# pc_nams <- paste("PC",1:40,sep="")
# mm_white <- colMeans(df[df$white==1,pc_nams])
# ss_white <- apply(df[df$white==1,pc_nams],2,sd)
# mm_brit <- colMeans(df[df$in.white.British.ancestry.subset==1,pc_nams])
# ss_brit <- apply(df[df$in.white.British.ancestry.subset==1,pc_nams],2,sd)
# 
# # draw ellipses
# dd_white <- rep(0,nrow(df))
# dd_brit <- rep(0,nrow(df))
# for(i in 1:ells){
#   dd_white <- dd_white + (df[,pc_nams[i]]-mm_white[i])^2/(ss_white[i]^2)
#   dd_brit <- dd_brit + (df[,pc_nams[i]]- mm_brit[i])^2/(ss_brit[i]^2)
# }
# 
# # make selection
# # intersection of:
# # - curated white british ellipse
# # - self-reported white ellipse
# # - self-reported white
# #df$eur_select <- (dd_white < sds_white^2) & (dd_brit < sds_brit^2) & (df$white | df$ethnic_miss)
# df$eur_select <- (dd_brit < sds_brit^2) & (df$white | df$ethnic_miss)
# 
# # save selection
# write.table(df,file="../../data/ukb_eur_samples.tsv",sep='\t',col.names=T,row.names=F)
# 
# 
# summary(df[df$eur_select, "PC1"])
# hist(df[df$eur_select, "PC1"])
# summary(df[df$eur_select, "PC2"])
# hist(df[df$eur_select, "PC2"])
# 
# 
# 
# ####
# # plot
# ####
# 
# # colors
# set <- rep(1,nrow(df))
# set[df$genCac == 1] <- 5
# set[df$white] <- 4
# set[df$eur_select] <- 3
# #set[df$in.white.British.ancestry.subset==1] <- 2
# #set[df$genCac == 1] <- 5
# cols <- c("gray80",brewer.pal("Dark2",n=4)[1],brewer.pal("Dark2",n=4)[2], brewer.pal("Dark2",n=4)[3],
#           brewer.pal("Dark2",n=4)[4])
# 
# samp=sample(nrow(df),replace=F)
# plot(df[samp,c("PC1","PC2")],col=cols[set[samp]],cex=.3,
#      xlim = c(-20,20), ylim = c(-20,20))
# 
# 
# #samp <- 1:nrow(df)
# png("ukb41714_eur_repcardiac_selection_pca.png",width=18,height=18,res=300,units="in")
# pairs(df[samp,c("PC1","PC2","PC3","PC4","PC5")],col=cols[set[samp]],cex=.1)
# dev.off()

###
# summaries
###

# cases.unrel.etn = df[df$eur_select == T,]
# dim(cases.unrel.etn)
# 
# print("versus white British")
# table(df$in.white.British.ancestry.subset,df$eur_select,useNA="al")
# 
# print("versus reported ethnicity")
# table(df$ethnic,set,useNA="al")
# 
# print("versus reported country of birth in UK")
# table(df$country,set,useNA="if")
# 
# print("versus reported country of birth outside UK")
# table(df$country2,set,useNA="if")
# 
# 
# summary(qcTab$PC1[qcTab$genCacuasian == 1])
# #summary(AFpheno.unrel.etn$PC1)
# summary(qcTab$PC2[qcTab$genCacuasian == 1])
# #summary(AFpheno.unrel.etn$PC2)

# eof

# sum(qcTab$genCacuasian == 1)
# 
# sample.etn = as.character(qcTab$sample.id[which(qcTab$genCacuasian == 1)])
# AFpheno.etn = AFpheno[sample.etn, ]
# 
# colnames(qcTab)
# 


