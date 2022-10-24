# ----------------------
#
# process vcf
#
# ----------------------
#
# IO's
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cores=2
i=$1

P=`cat pvcf_blocks_X.txt | head -${i} | tail -1 | cut -f 2`
Q=`cat pvcf_blocks_X.txt | head -${i} | tail -1 | cut -f 3`

#P=1
#Q=0


ref=/home/projects/cu_10039/data/UKBB/Exomes/1000genomesGrch38/genome_chr.fa


vcf=ukb23156_c${P}_b${Q}_v1.vcf.gz
vcfSplit=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.split.vcf.gz
vcfGtFilter=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter
vcfGtFilterMissing=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter.miss
vcfGtFilterMissingNorm=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter.miss.norm.vcf.gz


## not run
#vcfAnnon=${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1.filter.annon.vcf.gz
#gds=${vcfSplit%.vcf.gz}.gds

# ----------------------
#
# download pVCF format
#

#${DIR}/gfetch 23156 -c${P} -b${Q}


# ----------------------
#
# split multiallelic sites
#

module load bcftools/1.10.2
#bcftools norm -m - $vcf -O z --threads $cores -o $vcfSplit


# ----------------------
#
# vcftools filter GQ < 20 & DP < 10
#

#module load perl/5.30.2
#module load vcftools/0.1.16

# vcftools --gzvcf $vcfSplit --out $vcfGtFilter \
#  	 --minGQ 20 \
#  	 --minDP 10 \
#  	 --recode \
#  	 --recode-INFO-all 2>&1

# -----------------------------------------
#
# vcftools filter miss < 0.1
#


# vcftools --vcf ${vcfGtFilter}.recode.vcf \
#  	 --out ${vcfGtFilterMissing} \
#  	 --max-missing 0.9 \
#  	 --recode \
#  	 --recode-INFO-all 2>&1


# -----------------------------------------------------------
#
# vcf normalize
#


bcftools norm  --fasta-ref $ref \
	 -O z ${vcfGtFilterMissing}.recode.vcf.gz \
	 --threads $cores \
	 -o $vcfGtFilterMissingNorm



# -----------------------------------------------------------
#
# 3) add allele annotations (AF,AC,AN)
#

#bgzip ${vcfGtFilterMissing}.recode.vcf
#tabix ${vcfGtFilterMissing}.recode.vcf.gz

#bcftools +fill-tags ${vcfGtFilterMissing}.recode.vcf.gz \
# 	 -O z --threads $cores \
# 	 -o $vcfAnnon -- -t AC,AN,MAF,AC_Hom,AC_Het,ExcHet


# -----------------------------------------
#
# clean intermediate  vcf
#

#echo "SNP count"
#ls -lrt ${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1*
#vcftools --gzvcf $vcfSplit
#vcftools --vcf ${vcfGtFilter}.recode.vcf
#vcftools --gzvcf ${vcfGtFilterMissing}.recode.vcf.gz
#vcftools --gzvcf $vcfAnnon
#wc ${DIR}/intermediate/ukb23156_c${P}_b${Q}_v1*


# rm $vcf
# rm $vcfSplit
# rm ${vcfGtFilter}.recode.vcf
# rm ${vcfGtFilterMissing}.recode.vcf.gz.tbi
# rm ${vcfGtFilterMissing}.recode.vcf.gz

##################################################
# EOF # # EOF ## EOF ## EOF ## EOF ## EOF ## EOF #
##################################################
#seqMerge...
