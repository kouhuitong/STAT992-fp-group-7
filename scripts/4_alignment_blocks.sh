# This shell script was written for Mac OS operating system
# This script uses the output of/ or builds on `3_build_individual_genomes.sh`

#set the chromosome
chrom=$1
#set the starting position
start=$2
#set number of blocks to produce
block_num=$3
#optional, set block size (write if?)
block_sz=$4

#set the output filename
s=$(printf "%06d\n" $start) #opadding

# use 20,000 bp by default for chrom C & M
# use 100,000 bp by default for chrom 1-5
# start with 5 strains, 3 alignment blocks, each with 500 bp (C 0 3 500) --> result is 3 files, each with 5 seq. of 500 nucleotides

filename="chr${chrom}_${s}.phy"


```
Example in python: using chromosome C
str = subprocess.check_output("tail +2 TAIR10_chrC.fas| awk '{print}' ORS=''", shell=True)
n = 10000

blocks = []

i = 0
while i < len(str):
    if i+n < len(str):
        blocks.append(str[i:i+n])
    else:
        blocks.append(str[i:len(str)])
    i += n
    print(blocks) #all blocks can be called by list, example blocks[0]. Not sure how to write files

```

# Not sure how to modify for bash, and include variants
#extract the corresponding block pairs for only the chromosome of interest
consec_pos=$start
consec_pos+=$consec_pos
#pair=$(cat $strain | awk -v chr="chr$chrom" '$2 ~ chr' |tail -n +$start | head -n $block_sz | cut -f4 | awk '{print}' ORS='')
pair=$(cat $strain | awk -v chr="chr$chrom" '$2 ~ chr' | tail -n +$consec_pos | head -n $block_sz | cut -f4 | awk '{print}' ORS='')
tail -n +($consec_pos+$block_sz)

chr= $(tail +2 TAIR10_chrC.fas| awk '{print}' ORS='') #removes header lines
chr_length = $(wc -c $chr) 
