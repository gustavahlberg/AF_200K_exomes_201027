#
#
# Group variants
# created: 201119
#
# 1) LOF groups
# 2) Missense variants
# 3) SKAT
#
# 1) filter MAFs
# 2) plink to vcf
# 3) check reference and exclude mismatches
# 4) subset and add allele annotations (AF,AC,AN)
# 5) make vcf w/o sample ids
# 6) make gds files 
# -----------------------------------------------------------
#
# configs 
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
data=/home/projects/cu_10039/data/UKBB/Exomes/200K_exomes
module load bcftools/1.10.2
module load plink2/1.90beta6.18

mkdir -p ${DIR}/intermediate
vcfDir=/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/vcfs


# -----------------------------------------------------------
#
# fix header
#

qsub -t 1-22 fixheader.pbs
#bash fixHeader.sh $chr

# -----------------------------------------------------------
#
# make gds
#

qsub -t 1-22 makeGds.pbs

#Rscript makeGds.R $vcfCheckAnnon $gds $cores

# -----------------------------------------------------------
#
# install cadd
#

# installCADD.sh


# -----------------------------------------------------------
#
# Groups Variants
#

groupsVariants.R


# ---------------------------------------------
#
# fix alleles 
#

Rscript fixAlleles.R


# ---------------------------------------------
#
# new genotype gds
#

qsub -t 1-22 makeGdsGeno.pbs



# ---------------------------------------------
#
# seq merge
#

qsub seqMerge.pbs


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
