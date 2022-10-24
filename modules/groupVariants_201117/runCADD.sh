DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
i=$1
nt=$2
CADDrun=/home/projects/cu_10039/TOOLS/cadd/CADD-scripts/CADD.sh 

# i = 22
invcf=${DIR}/intermediate/vcf4cadd_chr${i}.vcf
${CADDrun} -g GRCh37 -a -c $nt $invcf


