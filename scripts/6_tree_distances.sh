# This shell script was written for Mac OS operating system.
# Run this script in the main directory.
# This script uses IQ-TREE to calculate the Robinson-Foulds (RF) distance between pairs of (unrooted) trees from 30 blocks (435 pairs of trees) and between pairs of trees from consective blocks only (29 pairs).

# Extract chromosome number from .treefile
chrom=$(ls -d $(ls iqtree/*.treefile | head -1) | xargs basename | cut -d _ -f1)

# Concatonate all .treefile files into one and move to treedist/
: > treedist/$chrom-all.tre

for file in $(ls iqtree/$chrom*.treefile)
do
cat $file >> treedist/$chrom-all.tre
done

cd treedist/
# comparing distance between all trees
iqtree -t $chrom-all.tre -rf_all -T AUTO --no-log -quiet

# compare pairs of adjacent trees (i.e. trees on adjacent lines in the file)
iqtree -t $chrom-all.tre -rf_adj -T AUTO -quiet -pre $chrom-all.adj.tre
