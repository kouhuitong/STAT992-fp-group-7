#!/bin/bash

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set the ending position
ending=$3

#count the number of the strains
cnt=$(ls  ../data/quality* | wc -l)
#calculate the length of the cut
length=$(expr $ending - $start)

#set the output filename
s=$(printf "%06d\n" $start) #padding
e=$(printf "%06d\n" $ending)
filename="chr${chrom}_${s}_to_${e}.phy"

echo "$cnt $length" > $filename 

#going to loop to get the corresponding base pairs of each strain
for strain in $(ls ../data/quality_variant_*)
do
strain_name=$(echo $strain | sed -r "s/.*quality_variant_(.*).txt/\1/" )
echo $strain_name

done




