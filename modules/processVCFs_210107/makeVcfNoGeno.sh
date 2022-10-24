# -----------------------------------------------------------
#
# 4) make vcf w/o sample ids
#
# -----------------------------------------------------------
#
# configs
#


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
cores=4
i=$1

module load bcftools/1.10.2
#i=22

# vcf=${DIR}/intermediate/ukb23156_c${i}_v1.filter.miss.vcf.gz
vcfInt=${DIR}/intermediate/ukb23156_c${i}_v1.filter.miss.norm.vcf.gz

vcfOut=${DIR}/../../data/vcfs/ukb23156_c${i}_v1.filter.miss.norm.onlyinfo.vcf.gz
ref=/home/projects/cu_10039/data/UKBB/Exomes/1000genomesGrch38/genome.fa

# -----------------------------------------------------------
#
# vcf normalize
#

# cores=1
# bcftools norm  --fasta-ref $ref \
# 	 -O z $vcf \
# 	 --threads $cores \
# 	 -o $vcfInt


# -----------------------------------------------------------
#
# vcf w/o genotypes
#

#tabix $vcf

bcftools view -G $vcfInt -O z \
	 --threads $cores \
	 -o $vcfOut

mv $vcfInt ${DIR}/../../data/vcfs/$(basename $vcfInt)



