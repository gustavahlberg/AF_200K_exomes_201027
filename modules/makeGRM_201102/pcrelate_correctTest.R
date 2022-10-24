library(GENESIS)
library(GWASTools)
load("results/segments.RData", verbose = T)
required <- c("pcrelate_prefix")
sparse_threshold=2^(-13/2) # 5th degree


kinSelf <- NULL
kinBtwn <- NULL
kin.thresh <- sparse_threshold
nsampblock = 10

### load results and combine
# i know the order seems weird,
# but this should make sure all the correct data is loaded when needed
for (i in 1:nsampblock){
    for (j in nsampblock:i){
        message('Sample Blocks ', i, ' and ', j)
        
        ## load the data
        res <- getobj(paste0("intermediate/pcrelate", "_block_", i, "_", j, ".RData")) 
        
        if(i == j) kinSelf <- rbind(kinSelf, res$kinSelf)
        
        # correct the IBD estimates
        ## res$kinBtwn <- correctK2(kinBtwn = res$kinBtwn, 
        ##                          kinSelf = kinSelf, 
        ##                          small.samp.correct = FALSE, 
        ##                          pcs = NULL, 
        ##                          sample.include = NULL)
        
        ## res$kinBtwn <- correctK0(kinBtwn = res$kinBtwn)
        
        # this should replace the original results, but i probably wouldn't overwrite them yet
        #save(res, file=paste0(config["pcrelate_prefix"], "_block_", i, "_", j, "_corrected.RData"))

        # save results above threshold in combined file
        kinBtwn <- rbind(kinBtwn, res$kinBtwn)
        
        rm(res); gc()
    }
}

# save pcrelate object
pcrelobj <- list(kinSelf = kinSelf, kinBtwn = kinBtwn)
class(pcrelobj) <- "pcrelate"
save(pcrelobj, file=paste0("results/pcrelate_",date,",RData"))

rm(kinBtwn, kinSelf); gc()
   
# save sparse kinship matrix
km <- pcrelateToMatrix(pcrelobj, thresh = 2*kin.thresh, scaleKin = 2)
save(km, file=paste0("pcrelate_Matrix_",date,".RData"))

# mem stats
ms <- gc()
cat(">>> Max memory: ", ms[1,6]+ms[2,6], " MB\n")
