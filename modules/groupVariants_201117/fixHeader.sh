
chr=$1

vcfDir=/home/projects/cu_10039/projects/AF_200K_exomes_201027/data/vcfs
vcfName=ukb23156_c${chr}_v1.filter.miss.onlyinfo.annon.dbnsfp.geneset.vcf.gz
vcf=${vcfDir}/${vcfName}


gunzip -c $vcf | head -5000 | grep '#' > header_${chr}

cat header_${chr} | \
    perl -ane 'if($_ =~ /dbNSFP/) {$_ =~ s/Number=A/Number=./}; print $_' > tmp_${chr}

mv tmp_${chr} header_${chr}


gunzip -c $vcf | grep -v '#' | cat header_${chr} - | bgzip -c > intermediate/$(basename $vcf) 
tabix intermediate/$(basename $vcf) 


