## learning goals

- learn a scripting language
- apply good coding practices
- apply a pipeline of commands and make it reproducible
- collaborate with others on code, using a git repository
- document and communicate on computing work

## task and requirements

- write shell, Python and/or Julia scripts to automate a pipeline
- each student should make at least 10 commits
- document each script and each step in the pipeline: with comments to explain
  what each step or function is doing, input, output, example of script usage
- document the analysis in a markdown `readme.md` file:
  why/when/where things were run, how long each step took,
  where the result files are.
  The purpose of the `readme.md` file is to help a scientist interested
  in reproducing the work: details need to be given about how to run things,
  what is the goal of each individual step / script, what files contains,
  at which step a file is created etc.
- organize the project files: with separate folders for data, scripts, results;
  possibly different directories for different types of data or different
  types of results
- write a **summary of results**, in a markdown file `report.md`,
  linked to from the main `readme.md` file.
  The purpose of the `report.md` file is to communicate the results to
  a collaborator or a reviewer. It should provide an answer to the scientific
  question and a broad overview of the pipeline. For details, the report
  should refer to (and link to) the "readme" file.


## group work

You will work in groups of 3 students, with one single github
repository for the team.

At the end of the project, you will submit an estimate
of each team member's percentage effort on the whole project for each of these
categories:

* ideas and design
* code (including comments inside code)
* documentation of the pipeline (markdown style)
* result summary (markdown style)

Ideally, all these estimates should be positive in all categories for
each collaborator, and should average to 33%.
These estimates should be submitted to Canvas.
You should *not* ask your group members to share them with you.
Each commit is authored, so the contribution of each student to actual
code is automatically tracked by git.
The TA and I will check these contributions.

## pipeline overview

The project is inspired by
[Stenz et al (2015)](https://doi.org/10.1093/sysbio/syv039).
Their alignment of the 4th chromosome for 171 plants is
[here](http://datadryad.org/resource/doi:10.5061/dryad.q044d/3),
and some scripts that they used for their analysis are available
[here](https://github.com/nstenz/TICR).

Your task is to reproduce their data collection using the larger database that is
now available, and to perform a short analysis to evaluate the variability of the
genealogical pattern across the genome. An understanding of the subject
matter is not necessary. Here is a summary of the different steps.

1. download the *Arabidopsis thaliana* reference genome,
2. download SNP data from the [1001 genome project](http://1001genomes.org)
   for several hundred accessions
   (i.e. individual [arabidopsis](https://en.wikipedia.org/wiki/Arabidopsis_thaliana)
   plants collected around the world),
3. build individual genomes by mapping the SNPs (step 2)
   onto the reference (step 1),
4. extract from a chromosome consecutive blocks of fixed size
   (like 30 blocks, each with 100,000 base pairs)
   and build one alignment for each block (a base pair is like one nucleotide:
   one A, C, G or T letter),
5. run IQ-TREE on each block to get the estimated
   genealogy (tree) of the plants in your sample from the DNA in that block,
6. calculate pair-wise distances between the trees in step 5:
   * between pairs of trees from all your blocks, and
   * between pairs of trees from consecutive blocks only.
7. compare these distances between trees:
   * Are the observed distances smaller than expected,
     if the 2 trees were chosen at random uniformly from the full set of possible trees?
     We would expect so if all blocks gave the same tree:
     such as if each plant was from a distinct population and populations did not mix.
   * Do trees from 2 consecutive blocks tend to be more similar to each
     other (at smaller distance) than trees from 2 randomly chosen blocks?
     We would expect so if blocks were small, due to less "recombination"
     between neighboring blocks than between blocks at opposing ends of the chromosome.
 8. optional challenge: re-run the scripts from steps 4-7 with a smaller
    block size, to see if the conclusions in 7 depend on the genomic
    scale (say blocks of 10,000 instead of 100,000 bp).

Details on each step are given [here](stepsinstructions.md).
