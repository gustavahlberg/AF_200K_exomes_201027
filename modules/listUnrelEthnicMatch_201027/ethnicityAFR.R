#
#
# subset to AFR ethnicity
#
# -----------------------------------

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
