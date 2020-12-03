# This script modify and expand '4_alignment_blocks.sh' to build an alignment and build a tree from it.
# The alignments will be stored in 'alignment/' while tree files in 'iqtree/'. 

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

# Here the set block length is 100,000
length_chrom=$(tail -n +1 data/TAIR10_chr$chrom.fas | wc -c) # extract length of chromosome

for block in $(seq 1 $block_num); do # loop based on number of blocks
    if [[ $block -eq 1 ]]
    then 
        block_begin=$start
        block_end=$(expr "$start" + 99999)
    else
        block_begin=$(expr "$block_end" + 1)
        block_end=$(expr "$block_begin" + 99999)
    fi
    if [[ $block_end -gt $length_chrom ]]
    then 
        $block_end=$length_chrom # accounts for end block that may be shorter than rest
    fi
    echo "$block_begin - $block_end bp for block $block"
    scripts/3_build_individual_genomes.sh $chrom $block_begin $block_end
    # Change filename
    mv alignments/chr${chrom}_${block_begin}_to_${block_end}.phy alignments/chr${chrom}_${block_begin}.phy
    # Build a tree for the alignemnt :
    #   Tree file name the same as alignment; 
    #   Automatically choose the number of threads appropriate for your machine;
    #   Suppress the creation of the '.log', '.iqtree', '.bionj', and '.mldist' files;
    #   Run quietly without printing information to the screen)
    iqtree -s alignments/chr${chrom}_${block_begin}.phy -m HKY+G -T AUTO --no-log --no-iqtree -djc -quiet
    # Move the tree file from main directory to 'iqtree/'
    mv chr${chrom}_${block_begin}.treefile iqtree/chr${chrom}_${block_begin}.treefile
    if [[ $block_end -eq $length_chrom ]]
    then  
        break
    fi
done