#
# check definition of AF
# 
# ---------------------------------------------
#
# load
#

source("bin/relatedness.R")

library('rcompanion')
sample.exo.id <- as.character(read.table("../../data/sampleList_200Kexomes.txt")$V1)
sample.exo.id <- sample.exo.id[which(sample.exo.id %in% rownames(i48))]

# rm related
sum(sample.eth.exo.id %in% relatedPairs$remove)
sum(sample.eth.id %in% relatedPairs$remove)
sample.eth.exo.unrel.id <- sample.eth.exo.id[-which(sample.eth.exo.id %in% relatedPairs$remove)]
sample.eth.unrel.id <- sample.eth.id[-which(sample.eth.id %in% relatedPairs$remove)]


h5readAttributes(h5.fn,"f.131351")
h5readAttributes(h5.fn,"f.131351/f.131351")$f.131351

f131351 <- h5read(h5.fn,"f.131351/f.131351")
f131351[f131351 == -9999,] <- 0
i48 <- f131351
i48[i48 != 0,] <- 1
rownames(i48) <- sample.id
rownames(f131351) <- sample.id

sum(i48[sample.eth.exo.unrel.id,])
sum(i48[sample.eth.unrel.id,])


pitx2 <- read.table("rs2129977.tdosage",
                    header = T)

rownames(pitx2) <- pitx2$ID_1

# -------------------------------------------
#
# check
#
# predefined
rownames(I48pheno) <- I48pheno$sample.id

df <- data.frame(y = i48[sample.eth.unrel.id,],
                 x = as.numeric(pitx2[sample.eth.unrel.id,]$SNP),
                 age = cov[sample.eth.unrel.id,]$age,
                 ageOfOnset = I48pheno[sample.eth.unrel.id,]$ageOfI48,
                 sex = cov[sample.eth.unrel.id,]$sex,
                 array = cov[sample.eth.unrel.id,]$genotyping.array,
                 cov[sample.eth.unrel.id, paste0("PC",1:5)]
)



dim(df)
null1 <- glm(y ~ ., data = df[,-c(2,3)] ,family = binomial())
summary(null1)['coefficients']
fit1 <- glm(y ~ ., data = df[,-3] ,family = binomial())
summary(fit)['coefficients']

null2 <- glm(y ~ ., data = df[,-c(2,4)] ,family = binomial())
summary(null2)['coefficients']
fit2 <- glm(y ~ ., data = df[,-4] ,family = binomial())
summary(fit)['coefficients']

summary(fit1)
summary(fit2)
anova(fit2, fit1)

# reg defined
sum(rowSums(AFpheno2[,-1]) > 0)
y2 = ifelse(rowSums(AFpheno2[,-1]) > 0, 1, 0)
df$y <- y2[sample.eth.unrel.id]

fit2 <- glm(y ~ ., data = df ,family = binomial())
null2 <- glm(y ~ ., data = df[,-2] ,family = binomial())
summary(fit2)['coefficients']

AIC(fit,fit2)
nagelkerke(fit, null = null)
nagelkerke(fit2, null = null2)

# ---------------------------------
# check only new cases

y3 = rep(0, length(x))
sum(y2 == 0 & y ==1)
y3[which(y2 == 0 & y ==1)] <- 1
names(y3) <- sample.eth.id

# rm other af cases
sum(!(fit$y == 1 & fit2$y == 1))

df2 <- df[!(i48[sample.eth.unrel.id,] == 1 & y2[sample.eth.unrel.id] == 1),]
fit3 <- glm(y ~ ., data = df2,
            family = binomial())
null3 <- glm(y ~ ., data = df2[,-2],
            family = binomial())

summary(fit3)['coefficients']


table(f131351[rownames(df2), ][df2$y == 1])
table(f131351[rownames(df2), ][df2$y == 1])




# ---------------------------------
# refine

table(f131351[rownames(df2), ])
table(f131351[rownames(df2), ][df2$y == 1])

#f131351[rownames(df2), ][df2$y == 1] == 30

fit4 <- glm(y ~ ., data = df2,
            family = binomial(),
            subset = !(f131351[rownames(df2), ][df2$y == 1] == 30)
            )
null4 <- glm(y ~ ., data = df2[,-2],
            family = binomial(),
            subset = !(f131351[rownames(df2), ][df2$y == 1] == 30)
)


fit5 <- glm(y ~ ., data = df2,
            family = binomial(),
            subset = !(f131351[rownames(df2), ][df2$y == 1] == 40)
)
null5 <- glm(y ~ ., data = df2[,-2],
            family = binomial(),
            subset = !(f131351[rownames(df2), ][df2$y == 1] == 40)
)


summary(fit5)['coefficients']
summary(fit4)['coefficients']
summary(fit3)['coefficients']

nagelkerke(fit, null)$Pseudo.R.squared.for.model.vs.null
nagelkerke(fit2, null2)$Pseudo.R.squared.for.model.vs.null
nagelkerke(fit3, null3)$Pseudo.R.squared.for.model.vs.null
nagelkerke(fit4, null4)$Pseudo.R.squared.for.model.vs.null
nagelkerke(fit5, null5)$Pseudo.R.squared.for.model.vs.null


resSim <- matrix(NA, nrow = 30, ncol = 4, 
                 dimnames = list(NULL,c("Estimate","Std. Error","z value","P")))

for(i in 1:30) {
  
  idx_ysim <- sample(which(y2 == 1), size = sum(fit3$y))
  ysim <- rep(0, length(y2))
  ysim[idx_ysim] <- 1
  names(ysim) <- names(y)
  
  sum(rownames(df) %in% names(which(y == 1 & ysim == 0)))
  
  fitSim <- glm(y ~ ., 
                data = df[!rownames(df) %in% names(which(y == 1 & ysim == 0)),],
                family = binomial()
  )
  
  resSim[i,] <- summary(fitSim)$coefficients['x',]
    
}


nullSim <- glm(ysim[sample.eth.unrel.id] ~ ., data = df[,-2],
              family = binomial(),
              subset = !(rownames(df) %in% names(which(y2 == 1 & ysim == 0)))
)

summary(fitSim)$coefficients['x',]

#nagelkerke(fitSim, nullSim)$Pseudo.R.squared.for.model.vs.null

# ---------------------------------
# both variables

df$y2 <- y2[rownames(df)]
df$y3 <- y3[rownames(df)]

fitLm <- lm(x ~ ., 
            data = df
)

summary(fitLm)$coefficients
summary(fitLm)$r.squared

fitLm <- lm(x ~ ., 
            data = df[,-1]
)

summary(fitLm)$coefficients
summary(fitLm)$r.squared

fitLm <- lm(x ~ ., 
            data = df[,-11]
)

summary(fitLm)$coefficients
summary(fitLm)$r.squared

fitLm <- lm(x ~ ., 
            data = df[,-c(1,11)]
)
summary(fitLm)$coefficients
summary(fitLm)$r.squared



# ---------------------------------
# age

h5readAttributes(h5.fn,"f.131350")
dateI48 <- h5read(h5.fn,"f.131350/f.131350")
dateI48[dateI48 == -9999] <- NA
rownames(dateI48) <- sample.id


ageOfOnset <- round(time_length( difftime(dateI48[sample.eth.id,], 
                                          pheno$dateOfBirth), "years"), digits = 1)

mean(ageOfOnset[y2 == 1], na.rm = T)
mean(ageOfOnset[y == 1], na.rm = T)
mean(ageOfOnset[y3 == 1], na.rm = T)

ageSplit <- split(ageOfOnset,as.factor(f131351[sample.eth.id,]))
sapply(ageSplit, mean)

table(f131351[sample.eth.id,])
table(f131351[sample.eth.id,][y3 == 1])
length(ageOfOnset[y3 == 1 & f131351[sample.eth.id,] == 40])

mean(ageOfOnset[y3 == 1 & f131351[sample.eth.id,] == 40])
mean(ageOfOnset[y3 == 0 & f131351[sample.eth.id,] == 40])

mean(ageOfOnset[y3 == 1 & f131351[sample.eth.id,] == 30])
mean(ageOfOnset[y3 == 0 & f131351[sample.eth.id,] == 30])

mean(ageOfOnset[y2 == 1 & f131351[sample.eth.id,] == 40])
mean(ageOfOnset[y2 == 0 & f131351[sample.eth.id,] == 40])
mean(ageOfOnset[y2 == 1], na.rm = T)
mean(ageOfOnset[ysim == 1], na.rm = T)

dI48 <- as.Date(dateI48[sample.eth.id,])
mean(as.Date(dateI48), na.rm = T)

mean(dI48[y3 == 1] )
mean(dI48[y3 == 1 & f131351[sample.eth.id,] == 40])
mean(dI48[y3 == 0 & f131351[sample.eth.id,] == 40])

mean(dI48[y3 == 1 & f131351[sample.eth.id,] == 30])
mean(dI48[y2 == 1], na.rm = T )



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################


f131351.exo <- f131351[sample.eth.exo.id,]
table(f131351.exo[which(y2 == 0 & y ==1)])
which(f131351.exo[which(y2 == 0 & y ==1)]  == 40)
y4 <- y
y4[names(which(f131351.exo[which(y2 == 0 & y ==1)]  == 40))] <- 0
fit4 <- glm(y4 ~ x + age + sex, 
            family = binomial(),
            subset = !(y2 == 1 & y ==1))
summary(fit4)['coefficients']

mean(cov[names(which(f131351.exo[which(y2 == 0 & y ==1)]  == 40)),]$age)
mean(cov[names(which(y4 == 1)),]$age)


sum(f131351[sample.eth.exo.id,] %in% c(30))
samplesSetZero <- sample.eth.exo.id[which(f131351[sample.eth.exo.id,] %in% c(30))]

table(y[samplesSetZero])
table(y2[samplesSetZero])
table(y3[samplesSetZero])

y3[samplesSetZero] <- 0

fit4 <- glm(y3 ~ x + age + sex, 
            family = binomial(), 
            subset = !(y2 == 1 & y ==1))
summary(fit4)['coefficients']

y4 <- y
y4[samplesSetZero] <- 0

fit4 <- glm(y4 ~ x + age + sex, 
            family = binomial())
summary(fit4)['coefficients']




f1 <-lm(x ~ y )
f2 <- lm(x ~ y2 )
AIC(f2) - AIC(f1)
anova(f2,f1)
fit <- lm(x ~ y + age + sex)
fit <- lm(x ~ y2 + age + sex)

