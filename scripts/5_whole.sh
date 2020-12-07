#!/bin/bash

# This shell script is used to link task 3, 4 and 5.
# This script uses the output of `3_build_individual_genomes.sh` to generate a given number of blocks of nucleotides of with a set length.
# And then build a iqtree for each block separately.
# The script takes four inputs chrom (1-5, C or M) starting position (e.g 1), number of blocks to produce (e.g. 1,2,..) 
# and the block size (optional; 100000 by default)

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set number of blocks to produce
block_num=$3
#set the block size, optionally (100000 by default)
if[[ $# -eq 4 ]]
then
    block_length=$4
else
    block_length=100000
fi

# Here the set block length is 10000
length_chrom=$(tail -n +1 data/TAIR10_chr$chrom.fas | wc -c) # extract length of chromosome 

for block in $(seq 1 $block_num); do # loop based on number of blocks
    if [[ $block -eq 1 ]]
    then 
        block_begin=$start
        block_end=$(expr "$start" + "$block_length" - 1)
    else
        block_begin=$(expr "$block_end" + 1)
        block_end=$(expr "$block_begin" + "$block_length" - 1)
    fi
    if [[ $block_end -gt $length_chrom ]]
    then 
        $block_end=$length_chrom # accounts for end block that may be shorter than rest
    fi
    echo "$block_begin - $block_end bp for block $block"
    # Call the script for task 3
    scripts/3_build_individual_genomes.sh $chrom $block_begin $block_end
    # Change filename
    mv alignments/chr${chorm}_${block_begin}_to_${block_end}.phy alignments/chr${chorm}_${block_begin}.phy
    if [[ $block_end -eq $length_chrom ]]
    then  
        break
    fi
done

# Build a iqtree for each block separately
for file in $(ls alignments/*.phy)
do
    # Extract the basename
    filename=$(basename $file | sed 's/.phy//g') 
    # Build the tree:
    #   '-T AUTO': To automatically choose the number of threads appropriate for your machine;
    #   '-pre': Use the basename as prefix for outputs (in the main directory);
    #   '--no-log --no-iqtree -djc': To suppress the creation of the '.log', '.iqtree', '.bionj', and '.mldist' files;
    #   '-quiet': To run quietly without printing information to the screen);
    iqtree -s $file -m HKY+G -T AUTO -pre $filename --no-log --no-iqtree -djc -quiet
    # Move the output '.treefile' from main directory to 'iqtree/'
    mv $filename.treefile iqtree/$filename.treefile
    # Remove other output files in main directory
    rm $filename.*
done