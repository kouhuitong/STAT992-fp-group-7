# This shell script was written for Mac OS operating system
# This script uses IQ-TREE to calculate the Robinson-Foulds (RF) distance between pairs of (unrooted) trees from 30 blocks (435 pairs of trees) and between pairs of trees from consective blocks only (29 pairs).

# concatenated all .treefile files into one and move to treedist/
touch treedist/chr1-all.tre
for file in $(ls iqtree/chr*.treefile)
do
cat $file >> treedist/chr1-all.tre
done

cd treedist/
# comparing distance between all trees
iqtree -t chr1-all.tre -rf_all -T AUTO --no-log -quiet

# compare pairs of adjacent trees (i.e. trees on adjacent lines in the file)
iqtree -t chr1-all.tre -rf_adj -T AUTO -quiet -pre chr1-all.adj.tre
