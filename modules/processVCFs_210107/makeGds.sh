# ----------------------
#
# vcf 2 gds
#
# ----------------------
#
# IO's
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cores=4
#i=$1

i=$1
P=`cat pvcf_blocks_X.txt | head -${i} | tail -1 | cut -f 2`
Q=`cat pvcf_blocks_X.txt | head -${i} | tail -1 | cut -f 3`


vcf=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter.miss.norm.vcf.gz
gds=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter.miss.norm.gds

# ------------------------------------
#
# make gds 
#

Rscript makeGds.R $vcf $gds $cores


# ------------------------------------
#
# edit gds 
#


Rscript editGds.R $gds $cores




###########################
# EOF # EOF ## EOF ## EOF #
###########################
