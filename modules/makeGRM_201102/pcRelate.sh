# ----------------------------------------------------
#
# PC-Relate
#
# ----------------------------------------------------
#
# 1) pcrelate_beta.R
# 2) pcrelate.R
# 3) pcrelate_correct.R
# 4) kinship_plots.R
#
# ----------------------------------------------------
#
# configs
#



# ----------------------------------------------------
#
# 1) pcrelate_beta.R
# 


Rscript ${DIR}/pcrelate_beta.R


# ----------------------------------------------------
#
# 2) pcrelate.R
# 
# a) segment into jobs

Rscript segmentPcrelate.R

# b) run jobs
#Rscript pcrelate.R $i
msub -t 1-351%30 pcrelate.pbs


# b) rerun failed jobs
cat pcrelate.e279* | grep Killed
msub -t 0-1 pcrelate.pbs


# ----------------------------------------------------
#
# 3) pcrelate_correct.R
# 

pcrelate_correct.R



#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
