See:
- [overview](overview.md) of the project: learning goals,
  group work, and overview of tasks and pipeline
- [step by step](stepsinstructions.md) instructions.

This readme is used as a brief introduction to the project and the intruction of running code scripts. **So, please always check this readme before running codes.** And for the details of each script as well as our practice, please go to another document [report.md](report.md).

## task 1
A shell script [1_get_reference_genome.sh](scripts/1_get_reference_genome.sh) is created to download 7 chromosomes: chromosomes 1 though 5, the mitochondrial DNA ("chrM") and the chloroplast DNA ("chrC"), into the directory `data/`.

Run the shell script from the main directory to reproduce: 
```
./scripts/1_get_refernece_genome.sh
```

**Now, the `data/`contains only 1 chromosome file `TAIR10_chr1.fas`, which is enough for testing codes of the following tasks.**

See [report](report.md) for details of this task.

## task 2
A shell script [2_get_SNP_data.sh](scripts/2_get_SNP_data.sh) is created to read the web info in the "Genomes Finished" section from the [website](http://signal.salk.edu/atg1001/download.php), so as to get all of the strain names. With a `for` loop structure of `wget` command, 216 files named `quality_variant_<strain_name>.txt` would be downloaded into the directory `data/`.

Run the shell script from the main directory to reproduce: 
```
`./scripts/2_get_SNP_data.sh
``` 

**Now, the `data/`contains only the first 5 strains, which are enough for testing codes of the following tasks. Running the command above will download all 216 strains, which may take a while depending on your network. So, Please forget to remove the other strains and leave only these five so that it won't affect the results of the following testing codes.**

See [report](report.md) for details of this task.


## task 3
The [3_build_individual_genomes.sh](scripts/3_build_individual_genomes.sh) script takes 3 arguments: 
- chromosome (in 1-5,C or M)
- starting base position (e.g. 1,2,...)
- ending base position
to return an alignment of the DNA seqences of the DNA sequences of all strains in `data/` for a chromosome of interest and for a genomic range of interest

**This script will be called in next two tasks and we suggest you not to run it indivially.** If you still want to test this script, the command
```
bash ./script/3_build_individual_genomes.sh 1 4000000 4000499
```
can be run from the main directory based on the situation that `chr1` chromosome and 5 strains work as testing data in `data/`. **Before running, please make sure only the original 5 strains as well as `TAIR10_chr1.fas` are left in `data/` to save time. Please don't forget to remove the output of the above testing command in `alignments` so that it won't affect the results of the following testing codes.**

See [report](report.md) for details of this task.

## task 4
The shell script [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh) takes 4 arguments: 
- chromosome (in 1-5,C or M)
- starting position index in base pairs (e.g. 1,2,...)
- number of blocks to produce
- length of block (optional; 100000 bp by default)
to extract *non-overlapping* and *consecutive* alignments from a chromosome and loops over the script from task 3 `3_build_individual_genomes.sh`. The script produces output files with name `chr<chromosome>_<starting position>.phy` into the `alignments/` directory. Each file contains blocks of a set length and base positions from each strain.

**This script will be called in the next task and we suggest you not to run it indivially.** If you still want to test this script, Run the shell script from the main directory to reproduce:
```
bash scripts/4_alignment_blocks.sh 1 400000 5 500
```
This command will not overwrite any alignment in `alignments/`, which are 5 blocks starting at 400000 with the length of 100000 bp of the original `chr1` chromosome and 5 strains in `data/`. **If the command with different arguments are run, please remove its outputs before the next task.**

See [report](report.md) for details of this task.

## task 5
The shell script [5_build_iqtree.sh](scripts/5_build_iqtree.sh) is modified and expanded based on [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh), takeing 4 arguments: 
- chromosome (in 1-5,C or M)
- starting position index in base pairs (e.g. 1,2,...)
- number of blocks to produce
- length of block (optional; 100000 bp by default)
to extract alignments from a chromosome as what [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh) does in **task 4** and then build a tree for each alignment file in `alignments/` and outputs the corresponding `.treefile` with the same name as alignment into `iqtree/`. 

Run the shell script from the main directory for testing: 
```
bash ./scripts/5_build_tree.sh 1 400000 5 500
``` 
**Before running this testing command, please make sure all outputs of testing codes in the above tasks have been removed. Please don't forget to remove the output of the above testing command in `alignments` so that it won't affect the results of task 6.**.

See [report](report.md) for details of this task.

## task 6

The shell script [6_tree_distances.sh](scripts/6_tree_distances.sh) uses IQ-TREE to calculate the Robinson-Foulds (RF) distance between pairs of (unrooted) trees and between pairs of trees from consective tree in `iqtree/` from task 5.

The expected output files in `treedist/` are:
- `chrX-all.tre`: concontanated file of all trees in `iqtree/`
- `chrX-all.tre.rfdist`: distance between pairs of unrooted trees, where the first column is the Tree index starting at zero, and the matrix of RF distances ordered by Tree similarly to the first column. 
-  `chrX-all.adj.tre.rfdist`: file containing the distances between all pairs of adjacent trees (i.e. trees on adjacent lines in the file).
- `chrX-all.adj.tre.log`: log file from the adjacent tree comparison. More information on file output can be found [here](stepsinstructions.md).

**Since the `iqtree/` directory contains 30 iqtree treefiles from the 30 blocks starting at 300000 with the length of 100000 on all 216 strains and `chr1` chromosome**, we can run the shell script from the main directory to reproduce:
```
bash scripts/6_tree_distances.sh
```
which all files in `treedist/` won't be overwritten so that the results of task 7. **Before running, please make sure all output of the testing command of task6 in `iqtree/` have been removed.**

See [report](report.md) for details of this task.

## task7

The R code [7_test_for_tree_similarity.R](scripts/7_test_for_tree_similarity.R) is a R script taking in one input:
- number of strains *n* (used to build iqtrees in `iqtree/`)
to generate 2 plots [7a.png](./images/7a.png) and [7b.png](./images/7b.png):

- For question 7(a): plot the distribution of *n*-3-*D*/2, and overlay the distribution of distances obtained in step 6(a). 

- For question 7(b): use a plot to overlay two distributions: the distribution of distances *D* between consecutive trees as obtained in step 6(b), and the distribution of distances between trees chosen randomly from the blocks of the same chromosome, which we have from step 6(a). Again, we choose to display the distributions of similarities *n*-3-*D*/2 instead of the the distributions of *D* itself. 

Before running the R script, change the `.rfdist` filenames if needed. Then, run the R script from the main directory to reproduce: 
```
Rscript ./script/7_test_for_tree_similarity.R <number of strains>
``` 
where `<number of strains>` will depend on how many strains used in `data/`. If you have kept the repo the same as the origin, run `Rscript ./script/7_test_for_tree_similarity.R 216` will output the same images as it is shown in [report](report.md).

See [report](report.md) for details of this task.