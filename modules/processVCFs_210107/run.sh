#
# Download 200K exomes
# from ukbb
# date: 210107
#
# 1) download and process subvcf files
# 2) concatanate vcf files per chromosome
# 3) make vcf w/o sample ids
# 4) make gds 
# ----------------------
#
# configs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR


#wget  -nd  biobank.ndph.ox.ac.uk/showcase/util/gfetch
#chmod 755 gfetch

key=.ukbkey


# ----------------------
#
# 1) process vcf
#


#. ${DIR}/processVcf.sh
msub -t 1-977%40 processVcf.pbs


# ----------------------
#
# 2) make gds
#



msub -t 1-977%40 makeGds.pbs


# ----------------------
#
# 3) seq merge
#


qsub -t 1-22 mergeGds.pbs



# -----------------------------------------------------------
#
# 4) make vcf w/o sample ids
#


qsub -t 1-22 makeVcfNoGeno.pbs



bcftools view -G $vcfCheckAnnon -O z \
	 --threads $cores \
	 -o $vcfCheckAnnonOnlyInfo



##################################################
# EOF # # EOF ## EOF ## EOF ## EOF ## EOF ## EOF #
##################################################
#seqMerge...

