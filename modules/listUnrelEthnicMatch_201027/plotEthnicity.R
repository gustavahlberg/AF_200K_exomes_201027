#
#
# Plot PC's
#
# ---------------------------------------------
#
# PC 1&2 all
#

tiff(filename = "results/PC1_2_all.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)
plot(dfOth[,c("PC1","PC2")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfW[dfW$eur_select == 0,c("PC1","PC2")],col= alpha('red',0.3),cex=.3,
       pch = 20)
points(dfW[dfW$eur_select == 1,c("PC1","PC2")],col= alpha('blue',0.3),cex=.3,
       pch = 20)
dev.off()

# ---------------------------------------------
#
# PC 3&4 all
#

tiff(filename = "results/PC3_4_all.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)


plot(dfOth[,c("PC3","PC4")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfW[dfW$eur_select == 0,c("PC3","PC4")],col= alpha('red',0.3),cex=.3,
       pch = 20)
points(dfW[dfW$eur_select == 1,c("PC3","PC4")],col= alpha('blue',0.3),cex=.3,
       pch = 20)
dev.off()

# ---------------------------------------------
#
# PC 5&6 all
#

tiff(filename = "results/PC5_6_all.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)

plot(dfOth[,c("PC5","PC6")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfW[dfW$eur_select == 0,c("PC5","PC6")],col= alpha('red',0.3),cex=.3,
       pch = 20)
points(dfW[dfW$eur_select == 1,c("PC5","PC6")],col= alpha('blue',0.3),cex=.3,
       pch = 20)

dev.off()


# ---------------------------------------------
#
# exomes subset
#

dfWex <- dfW[dfW$sample.id %in% sample2CKExomes,]
dfOthex <- dfOth[dfOth$sample.id %in% sample2CKExomes,]

# ---------------------------------------------
#
# PC 1&2 exomes
#

tiff(filename = "results/PC1_2_exomes.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)
plot(dfOthex[,c("PC1","PC2")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfWex[dfWex$eur_select == 0,c("PC1","PC2")],col= alpha('red',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)
points(dfWex[dfWex$eur_select == 1,c("PC1","PC2")],col= alpha('blue',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)
dev.off()

# ---------------------------------------------
#
# PC 3&4 exomes
#

tiff(filename = "results/PC3_4_exomes.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)


plot(dfOthex[,c("PC3","PC4")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfWex[dfWex$eur_select == 0,c("PC3","PC4")],col= alpha('red',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)
points(dfWex[dfWex$eur_select == 1,c("PC3","PC4")],col= alpha('blue',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)

dev.off()

# ---------------------------------------------
#
# PC 5&6 exomes
#

tiff(filename = "results/PC5_6_exomes.tiff",
     width = 6.1, height = 6.1,
     units = 'in', res = 300)

plot(dfOthex[,c("PC5","PC6")],col= alpha('grey',0.3),cex=.3,
     #xlim = c(-20,20), ylim = c(-20,20),
     pch = 20)
points(dfWex[dfWex$eur_select == 0,c("PC5","PC6")],col= alpha('red',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)
points(dfWex[dfWex$eur_select == 1,c("PC5","PC6")],col= alpha('blue',0.3),cex=.3,
       #xlim = c(-20,20), ylim = c(-20,20),
       pch = 20)

dev.off()

###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################