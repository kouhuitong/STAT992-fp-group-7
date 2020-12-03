#!/bin/bash

#run shell script in the main directory
#<usage> ./3_build_individual_genomes.sh chromosome starting_base_position ending_base_position

if [ $# != 3 ] ; then
echo "USAGE: ./scripts/3_build_individual_genomes.sh <chromosome> <starting_base_position> <ending_base_position>" 1>&2
exit 1;
fi

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set the ending position
ending=$3

#count the number of the strains
#cnt=$(ls  data/quality* | wc -l)
#calculate the length of the cut
length=$(expr $ending - $start)

#set the output filename
s=$(printf "%08d\n" $start) #opadding
e=$(printf "%08d\n" $ending)
filename="chr${chrom}_${s}_to_${e}.phy"

# Create a blank alignment file "$filename"
: > alignments/$filename

tail -n +2 data_sub/TAIR10_chr$chrom.fas | awk '{print}' ORS='' > chromosome_sub #chromosome for indexing

#going to loop to get the corresponding base pairs of each strain
#for strain in $(ls data/quality_variant_*)
for strain in $(ls data_sub/quality_variant_*)
do
#get the strain name
strain_name=$(echo $(basename $strain) | sed -E 's/.*quality_variant_(.*).txt/\1/' )
#echo $strain_name #used for debugging

#get the corresponding pairs for only the chromosome of interest
#pair=$(cat $strain | tail -n +$start |head -n $length | cut -f4 | awk '{print}' ORS='')
#pair=$(cat $strain | awk -v chr="chr$chrom" '$2 ~ chr' |tail -n +$start | head -n $length | cut -f4 | awk '{print}' ORS='')
#check if corresponding pairs exist
cat $strain |awk -v chr="chr$chrom" '$2 ~ chr' |awk '$3 >= start && $3 <= ending { print $0 ;}' start="$start" ending="$ending" > int1
exist_factor=$(cat int1 | wc -l)
if [ $exist_factor -ne 0 ];then
#pair=$(cat $strain | awk -v chr="chr$chrom" '$2 ~ chr' | awk '$3 >= start && $3 <= ending  { print $0 ;}' start="$start" ending="$ending" | cut -f4 | awk '{print}' ORS='') 

#check the absent index
for index in $(eval echo "{$start..$ending}");
do
    #debugging strings
    #echo $strain
    #echo $index
    cat int1 | awk -v ind="$index" '{ if($3 == ind ) {print $4 ;} }' > int2
    ind_checker=$(cat int2 | wc -l );
    #echo $index_checker
    if [ $ind_checker -gt 0 ];
    then cat int2 >> int3 ;
    #else echo "-" >> int3 ;
    else 
        cut -c$index ./chromosome_sub >> int3 ; # prints the nucleotide from the chromosome at index position
    fi; 
done; 

pair=$(cat int3 | awk '{print}' ORS='')
rm int2
rm int3

# In case there are no strain-specific nucleotide differences
# else pair=$(cut -c$start-$ending ./chromosome_sub) 

# This line for debug
echo "$strain_name $pair" >> alignments/$filename

fi

done
cnt=$(cat alignments/$filename |wc -l)

# Insert the first line
sed -i "1i $cnt $length" alignments/$filename

rm int1


