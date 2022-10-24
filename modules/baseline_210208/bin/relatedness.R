#
#
# remove related samples
#
# --------------------------------------------------------------




relatedPairs = read.table("~/Projects/ManageUkbb/data/RelatednessETC/ukb43247_rel_s488288.dat",
                          header = T,
                          stringsAsFactors = F)

relatedPairs$ID1 = as.character(relatedPairs$ID1)
relatedPairs$ID2 = as.character(relatedPairs$ID2)


names(i48[i48 == 1,])
cases = names(i48[i48 == 1,])


# ---------------------------------------------
#
# subset
#

relatedPairs$case.1 = ifelse(relatedPairs$ID1 %in% cases,1,0)
relatedPairs$case.2 = ifelse(relatedPairs$ID2 %in% cases,1,0)

multiples = sort(table(c(relatedPairs$ID1, relatedPairs$ID2)), decreasing = T)
relatedPairs$multiple.1 = sapply(relatedPairs$ID1, function(x){
  multiples[x]
})
relatedPairs$multiple.2 = sapply(relatedPairs$ID2, function(x){
  multiples[x]
})

relatedPairs$remove = NA


for(i in 1:dim(relatedPairs)[1]){
  
  pair = relatedPairs[i,]
  
  if(!is.na(relatedPairs[i,]$remove)) {
    print(paste(i,"row already set"))
    next
  }
  
  # is case 
  if( pair$case.1 > pair$case.2) {
    relatedPairs[relatedPairs$ID1 == pair$ID2 | relatedPairs$ID2 == pair$ID2,]$remove = pair$ID2
    next
  } else if (pair$case.1 < pair$case.2){
    relatedPairs[relatedPairs$ID1 == pair$ID1 | relatedPairs$ID2 == pair$ID1,]$remove = pair$ID1
    next
  }
  
  # is multiple
  if( pair$multiple.1 <= pair$multiple.2) {
    relatedPairs[relatedPairs$ID1 == pair$ID2 | relatedPairs$ID2 == pair$ID2,]$remove = pair$ID2
    next
  } else if (pair$multiple.1 > pair$multiple.2){
    relatedPairs[relatedPairs$ID1 == pair$ID1 | relatedPairs$ID2 == pair$ID1,]$remove = pair$ID1
    next
  }
  
}


# check result
length(unique(relatedPairs$remove))
cases[cases %in% relatedPairs$remove]

# sum(AFpheno$totalHard[AFpheno$sample.id %in% relatedPairs$ID1 | AFpheno$sample.id %in% relatedPairs$ID2])
# sum(AFpheno$totalHard[AFpheno$sample.id %in% relatedPairs$remove])
# relatedPairs[relatedPairs$ID1 == '1000139' | relatedPairs$ID2 == '1000139',]
# sum(AFpheno$totalHard[!AFpheno$sample.id %in% relatedPairs$remove])



# --------------------------------------------------
#
# rm 
#

length(cases)
length(cases[!cases %in% relatedPairs$remove])
length(cases[!cases %in% relatedPairs$remove]) - length(cases)
cases.unrel = cases[!cases %in% relatedPairs$remove]

# AFpheno.unrel = AFpheno[!AFpheno$sample.id %in% relatedPairs$remove,]
# # check
# sum(relatedPairs$ID1 %in% AFpheno.unrel$sample.id & relatedPairs$ID2 %in% AFpheno.unrel$sample.id )


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################