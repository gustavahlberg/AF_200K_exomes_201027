#
#
# annotate
# created: 201103
# 1) snpEff
# 2) snpSift
#
# ----------------------------------------------------
#
# configs
#

module load tensorflow/2.5.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
SCRATCH=/home/projects/cu_10039/scratch 
RESRC=/home/projects/cu_10039/data/RESOURCES

# AnnoDbNSFP='GERP++_RS,Uniprot_acc,MutationTaster_pred,FATHMM_pred,SIFT_pred,SIFT_converted_rankscore,Polyphen2_HDIV_pred,Polyphen2_HDIV_rankscore,Polyphen2_HVAR_rankscore,Polyphen2_HVAR_pred,MutationAssessor_rankscore,MutationAssessor_pred,LRT_converted_rankscore,LRT_pred,LRT_Omega,ExAC_Adj_AF,ExAC_NFE_AF,clinvar_clnsig,clinvar_trait,PROVEAN_pred,GERP++_NR,SIFT_score,FATHMM_score,MetaSVM_score,MetaSVM_rankscore,MetaSVM_pred,Reliability_index,PROVEAN_score,phyloP46way_primate,phyloP100way_vertebrate,CADD_raw,CADD_raw_rankscore,CADD_phred'

AnnoDbNSFP='Ensembl_transcriptid,SIFT_score,SIFT_pred,Polyphen2_HDIV_score,Polyphen2_HDIV_pred,ClinPred_score,ClinPred_rankscore,ClinPred_pred,CADD_raw,CADD_phred,GERP++_RS,GERP++_RS_rankscore,clinvar_id,clinvar_clnsig,clinvar_trait,clinvar_review,UK10K_AC,UK10K_AF,gnomAD_genomes_POPMAX_AC,gnomAD_genomes_POPMAX_AF,gnomAD_genomes_POPMAX_nhomalt,Aloft_Fraction_transcripts_affected,Aloft_prob_Tolerant,Aloft_prob_Recessive,Aloft_prob_Dominant,Aloft_pred,Aloft_Confidence'
dbNSFP=$RESRC/dbNSFP4.1a.txt.gz
msigDb=$RESRC/msigDb/msigdb.v7.2.symbols.gmt
#path/to/snpEff/snpEff.config
snpEff=../../../../TOOLS/snpEff/latest_v/snpEff/snpEff.jar
snpSift=../../../../TOOLS/snpEff/latest_v/snpEff/SnpSift.jar

ref=/home/projects/cu_10039/data/UKBB/Exomes/1000genomesGrch38/genome_chr.fa



# ----------------------------------------------------
#
# IO's
#


chr=$1


VCFPATH=/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/vcfs
vcf=${VCFPATH}/ukb23156_c${chr}_v1.filter.miss.norm.onlyinfo.vcf.gz 
vcfEFF=${DIR}/intermediate/$(basename ${vcf%.vcf.gz}).annon.vcf
vcfSift=${vcfEFF%.vcf}.dbnsfp.vcf
vcfSplice=${vcfSift%.vcf}.spliceai.vcf
vcfSiftMsigDb=${DIR}/../../data/vcfs/$(basename ${vcf%.vcf.gz}).annon.dbnsfp.spliceai.geneset.vcf

# ----------------------------------------------------
#
# 1) snpEff
#


java -XX:+UseParallelGC -XX:ParallelGCThreads=8 -Xmx16g -Djava.io.tmpdir=$SCRATCH/TMP -jar $snpEff -v GRCh38.99 $vcf -noStats > $vcfEFF


# ----------------------------------------------------
#
# 2) snpSift dbNSFP
#



java -jar $snpSift dbnsfp -v -db $dbNSFP $vcfEFF -f $AnnoDbNSFP > $vcfSift



# ----------------------------------------------------
#
# 3) splice AI
#


spliceai -I $vcfSift -O $vcfSplice -R $ref -A grch38


# ----------------------------------------------------
#
# 4) snpSift gensets
#


java -jar $snpSift geneSets -v $msigDb $vcfSplice > $vcfSiftMsigDb


# ----------------------------------------------------
#
# 5) zip & rm intermediate
#

bgzip $vcfSiftMsigDb
tabix $vcfSiftMsigDb.gz


#######################################################
# EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF # EOF #
#######################################################
