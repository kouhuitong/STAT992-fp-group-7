# Result Summary for Final Project
This report is used to record the details of each script mentioned in [readme](readme.md) as well as our practice concentrating on the **30 blocks, with starting position at 300,000 and length of 100,000 base pairs, of 216 strains for chromosome 1**.

## task 1
[1_get_reference_genome.sh](scripts/1_get_reference_genome.sh) firstly creates the directory `data/` (ignore if existing) and download 7 chromosomes: chromosomes 1 though 5, the mitochondrial DNA ("chrM") and the chloroplast DNA ("chrC"), into the directory `data/` by `wget` command. Totally 7 `.fas` files  are downloaded by running this script and downloading time depends on network situation. You can check [here](documents/task1.txt) for the list of these files with their size. Because we focus on the **chromosome 1** in our practice, only this chromosome `.fas` file is kept in `data/`.

So, to reproduce our practice in task 1, run
```
bash ./scripts/1_get_reference_genome.sh
```

## task 2
[2_get_SNP_data.sh](scripts/2_get_SNP_data.sh) firstly reads the web info in the "Genomes Finished" section from the [website](http://signal.salk.edu/atg1001/download.php) into an intermediate file [web.txt](documents/web.txt) and then gets all of the strain names with a link from it by `grep` command. Totally 217 strains are extracted and there is [one](http://signal.salk.edu/atg1001/data/Salk/quality_variant_Utrecht.txt) whose link fails. So, with a `for` loop structure of `wget` command, 216 files named `quality_variant_<strain_name>.txt` would be downloaded into the directory `data/`. You can check [here](documents/task2.txt) for the list of these files with their size.

To reproduce our practice in task 2, run
```
bash ./scripts/2_get_SNP_data.sh
```

By the way, due to large file size and to save time for following testing, only the first 5 strains are kept in `data/` directory now.

## task 3
Here is an [example](documents/strain_example.md) of a strain data file. The first 5 columns indicate the strain name, chromosome, position, the reference base of this position and the substitute base respectively. 
The [3_build_individual_genomes.sh](scripts/3_build_individual_genomes.sh) script takes 3 arguments: 
- chromosome (in 1-5,C or M)
- starting base position (e.g. 1,2,...)
- ending base position

It extracts a specific alignment by `starting base position` to `ending base position` from `.fas` related to the input `chromosome`, 
and searchs in each strain in `data/` to find rows whose **content in column 2** matches the input `chromosome` and **the number indicating the position in column 3** are in the range from `starting base position` to `ending base position`. Then it replaces the base in the specific position by its **substitute base in column 5**. The process above is achieved by a nesting loop. 

For testing, `bash ./script/3_build_individual_genomes.sh 1 4000000 4000499` was run on 5 strains and it took about 2.5 minutes to finish.

**This script will be called in next two tasks so it is not to run individually.**

## task 4
The shell script [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh) takes 4 arguments: 
- chromosome (in 1-5,C or M)
- starting position index in base pairs (e.g. 1,2,...)
- number of blocks to produce
- length of block (optional; 100000 bp by default)

Firstly, the length of alignment (number of base pairs) in `.fas` file related to input `chromosome` will be counted. Then the starting position and ending position of each block will be inferred by inputs `starting position index in base pairs`, `number of blocks to produce` and `length of block`. Within each loop, the script from task 3 `3_build_individual_genomes.sh` would be called one time with arguments input `chromosome`, the starting position and ending position, to generate a `chr<chromosome>_<starting position>.phy` storing the information of each block.

For testing, `bash ./script/4_alignment_blocks.sh 1 4000000 5 500` was run on 5 strains, which generated 5 consercutive block of length 500bp and starting at 4000000. It took about 13 minutes to finish.

**This script will be called in next two tasks so it is not to run individually.**


## task 5
The shell script [5_build_iqtree.sh](scripts/5_build_iqtree.sh) takes in 4 arguments:
- chromosome (in 1-5,C or M)
- starting position index in base pairs (e.g. 1,2,...)
- number of blocks to produce
- length of block (optional; 100000 bp by default)

It is modified and expanded based on [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh), by a loop going through every `.phy` in the directory `alignments/` to establish an iqtree and output the `.treefile` into `iqtree/` for each. The output `.treefile` would keep the same name as its corresponding alignment. 

The `iqtree` command in [5_build_iqtree.sh](scripts/5_build_iqtree.sh) uses the following options:
- '-T AUTO': To automatically choose the number of threads appropriate for your machine;
- '-pre': Use the same basename as corresponding `.treefile` to be prefix for outputs (in the main directory);
- '--no-log --no-iqtree -djc': To suppress the creation of the '.log', '.iqtree', '.bionj', and '.mldist' files;
- '-quiet': To run quietly without printing information to the screen).

For testing, `bash ./script/4_alignment_blocks.sh 1 4000000 5 500` was run on 5 strains, which generated 5 consercutive block of length 500bp and starting at 4000000 and then build an iqtree for each. It took about 22 minutes to finish and its outputs are now in `alignments/`.

In our practice, we hope to get the **30 blocks, with starting position at 300,000 and length of 100,000 base pairs, of 216 strains for chromosome 1**. The command `bash ./script/4_alignment_blocks.sh 1 300000 30` should have been run on our platform but its estimated running time may reach several days. So, we tried to achieve this by 6480 (due to 30 blocks \* 216 strains = 6480) parallel jobs running on HTC (high throughout computer) cluster and it took about 19.5 hours to finish (including queueing time). And its output are now in `/iqtree/` directory.

## task 6
The shell script [6_tree_distances.sh](scripts/6_tree_distances.sh) uses IQ-TREE to calculate the Robinson-Foulds (RF) distance between pairs of (unrooted) trees and between pairs of trees from consective tree in `iqtree/` from task 5.

The expected output files in `treedist/` are:
- `chrX-all.tre`: concontanated file of all trees in `iqtree/`
- `chrX-all.tre.rfdist`: distance between pairs of unrooted trees, where the first column is the Tree index starting at zero, and the matrix of RF distances ordered by Tree similarly to the first column. 
-  `chrX-all.adj.tre.rfdist`: file containing the distances between all pairs of adjacent trees (i.e. trees on adjacent lines in the file).
- `chrX-all.adj.tre.log`: log file from the adjacent tree comparison. More information on file output can be found [here](stepinstructions.md).

To reproduce our practice, run the shell script from the main directory:
```
bash scripts/6_tree_distances.sh
```

## task 7
The R code [7_test_for_tree_similarity.R](scripts/7_test_for_tree_similarity.R) is a R script taking in one input:
- number of strains (used to build iqtrees in `iqtree/`)

to generate 2 plots [7a.png](./images/7a.png) and [7b.png](./images/7b.png) to answer:
- (a) Are the observed tree distances smaller than expected if  the 2 trees were chosen at random uniformly?  We would think so, if each plant was from a distinct population  and if populations did not mix.
- (b) Do trees from consecutive blocks tend to be more similar to each other (at smaller distance) than trees from randomly chosen blocks from the same chromosome?  We would expect so if blocks were small, due to less "recombination" between neighboring blocks than between blocks at opposing ends of the chromosome.

### For question (a)

[7_test_for_tree_similarity.R](scripts/7_test_for_tree_similarity.R) reads the [chr1-all.tre.rfdist](treedist/chr1-all.tre.rfdist) to extract tree distances *D* when 2 trees are chosen at random uniformly, which is a numeric vector of length 30\*(30 - 1)/2 = 435, and then calculate *S* = *n*-3-*D*/2. We drew a histogram for *S*. Then, a series of Poison(1/8) random numbers with the same length as *S* are generated and corresponding histogram is added to the histogram for *S*. Two vertical lines indicating the mean of *S* and the mean of Poison random number are also added to this figure.

  ![alt text](https://github.com/UWMadison-computingtools-2020/fp-group-7/blob/master/images/7a.png)

From the figure above, if we assume *S* is still Poison distributed, then it is obvious that its mean is larger than Poison(1/8), which implies that observed tree distances are smaller than expected if the 2 trees were chosen at random uniformly.
  
### For question (b)  
[7_test_for_tree_similarity.R](scripts/7_test_for_tree_similarity.R) reads the [chr1-all.adj.tre.rfdist](treedist/chr1-all.adj.tre.rfdist) to extract tree distances *D* of consercutive trees, which is a numeric vector of length 30 - 1 = 29, and then also calculate *S* = *n*-3-*D*/2. On basis of the histogram for *S* of randomly chosen trees, the histogram for *S* of consercutive trees, as well as two vertical mean lines are added.
  
  ![alt text](https://github.com/UWMadison-computingtools-2020/fp-group-7/blob/master/images/7b.png)
  
The above figure shows that the mean *S* of consercutive trees is larger than the mean *S* of randomly chosen trees. So, the distance of consecutive blocks is larger than that of randomly chosen blocks.