cat data/quality_variant_Aa_0.txt | awk -v chr=chr1 ' ~ chr'| awk -v ind=92 '{ if( == ind ) {print /bin/bash ;} }' | wc -l 
