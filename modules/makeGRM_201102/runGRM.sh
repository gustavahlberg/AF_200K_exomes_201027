#
#
# Run 
# created: 201102
# 1) make gds
# 2) Run PC-air
#
# ----------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 
#module load moab
#module load king/2.1.3

# ----------------------------------------------------
#
# make gds
#


#. ${DIR}/makeGds.sh
#qsub ${DIR}/makeGds.pbs

# ----------------------------------------------------
#
# Run PC-air
#


. ${DIR}/pcAirPipeline.sh



###########################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF #
###########################################
