# This shell script was written for Mac OS operating system
# This script uses the output of `3_build_individual_genomes.sh` to generate a given number of blocks of nucleotides of with a set length
# The script takes three inputs chrom (1-5, C or M) starting position (e.g 1) and number of blocks to produce (e.g. 1,2,..)

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set number of blocks to produce
block_num=$3
#optional, set block size
#if [[ $4 -eq 0 ]]
#then 
#    declare -i block_sz
#    block_sz=499
#    echo "No block length given, default is 500"
#else
#    block_sz=$4
#fi

# Here the set block length is 500
#length_chrom=$(tail -n +1 data/TAIR10_chr$chrom.fas | wc -c) # extract length of chromosome
length_chrom=$(tail -n +1 data_sub/TAIR10_chr$chrom.fas | wc -c) # extract length of chromosome

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
    scripts/3_build_individual_genomes.sh $chrom $block_begin $block_end
    # Change filename
    mv alignments/chr${chorm}_${block_begin}_to_${block_end}.phy alignments/chr${chorm}_${block_begin}.phy
    if [[ $block_end -eq $length_chrom ]]
    then  
        break
    fi
done
