# Run this script with the following arguments to produce test data: 1 200000 3

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set number of blocks to produce
block_num=$3

# Here the set block length is 500
length_chrom=$(tail -n +1 TAIR10_chr$chrom.fas | wc -c) # extract length of chromosome

for block in $(seq 1 $block_num); do # loop based on number of blocks
    if [[ $block -eq 1 ]]
    then 
        block_begin=$start
        block_end=$(expr "$start" + 499)
    else
        block_begin=$(expr "$block_end" + 1)
        block_end=$(expr "$block_begin" + 499)
    fi
    if [[ $block_end -gt $length_chrom ]]
    then 
        $block_end=$length_chrom # accounts for end block that may be shorter than rest
    fi
    echo "$block_begin - $block_end bp for block $block"
    ./test_3_build_individual_genomes.sh $chrom $block_begin $block_end
    if [[ $block_end -eq $length_chrom ]]
    then  
        break
    fi
done
