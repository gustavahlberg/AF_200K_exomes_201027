#
# make gds
#
# ----------------------------------------------------
#
# configs
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
module load plink2/1.90beta5.4 



# -----------------------------------------------------------
#
# IOs
#

mkdir -p $DIR/intermediate
data=/home/projects/cu_10039/data/UKBB/Genotype/EGAD00010001497
ukb=$data/ukb
ukbSubset=$DIR/../../data/ukbSubset
ukbMaf=$DIR/intermediate/$(basename ${ukbSubset}).maf
ukbMafReg1=${ukbMaf}.reg1
ukbMafReg=${ukbMafReg1}.reg
samples=${DIR}/../../data/samples200Kexomes.etn.201030.list
exlReg=$DIR/exclusion_regions_hg19.txt
gds=$DIR/../../data/ukbSubset.filtered.gds

# -----------------------------------------------------------
#
# 1) subset 
#

plink --bfile $ukb \
    --keep-fam $samples \
    --make-bed \
    --out $ukbSubset



# -----------------------------------------------------------
#
# 2) Select snps
#
# - MAF > 5%
# - MISSINGNESS < 2%
# - P HWE > 1e-6 
#

plink --bfile $ukbSubset \
    --maf 0.01 \
    --geno 0.02 \
    --hwe 1e-6 \
    --autosome \
    --make-bed \
    --out $ukbMaf


# -----------------------------------------------------------
#
#  2b) Remove regions
#
# - no AT/GC SNPs (strand ambiguous SNPs)
# - no MHC (6:25-35Mb)
# - no Chr.8 inversion (8:7-13Mb)
#

Rscript rmRegions.R intermediate/ukbSubset.maf.bim

plink --bfile $ukbMaf \
    --exclude $DIR/rsId_StrAmb.tsv \
    --make-bed \
    --out $ukbMafReg1

plink --bfile $ukbMafReg1 \
    --exclude 'range' $exlReg \
    --make-bed \
    --out $ukbMafReg


# -----------------------------------------------------------
#
# 4) make gds
#

bed=${ukbMafReg}.bed
bim=${ukbMafReg}.bim
fam=${ukbMafReg}.fam
cores=12

Rscript makeGds.R $bed $bim $fam $gds $cores




#################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#################################################
