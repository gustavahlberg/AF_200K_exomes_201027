#
# install cadd
#
# -----------------------------------------------------------------------------
# can be installed like this

cd /home/projects/cu_10039/TOOLS/cadd 

#wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
unset PYTHONPATH
MINICONDA=/home/projects/cu_10039/TOOLS/cadd
#bash Miniconda3-latest-Linux-x86_64.sh -p $MINICONDA/miniconda3 -b
export PATH=$MINICONDA/miniconda3/bin:$PATH
#conda install -c conda-forge -c bioconda snakemake


#git clone https://github.com/kircherlab/CADD-scripts/

#unzip CADD.zip

cd CADD-scripts
./install.sh


wget -c https://krishna.gs.washington.edu/download/CADD/v1.6/GRCh38/annotationsGRCh38_v1.6.tar.gz


cd data/annotations
tar -zxvf annotationsGRCh37_v1.6.tar.gz
mv GRCh37 GRCh37_v1.4
tar -zxvf annotationsGRCh38_v1.6.tar.gz
cd $OLDPWD


data/prescored/${GENOME_BUILD}_${VERSION}/



# Running CADD
# You run CADD via the script CADD.sh which technically only requieres an either vcf or vcf.gz input file as last argument. You can further specify the genome build via -g, CADD version via -v (deprecated, the new version of the scripts only support v1.6), request a fully annotated output (-a flag) and specify a seperate output file via -o (else inputfile name .tsv.gz is used). I.e:

# ./CADD.sh test/input.vcf

# ./CADD.sh -a -g GRCh37 -o output_inclAnno_GRCh37.tsv.gz test/input.vcf


CADDrun=/home/projects/cu_10039/TOOLS/cadd/CADD-scripts/CADD.sh
