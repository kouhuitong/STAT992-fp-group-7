# project: detailed instructions

See [here](overview.md) for general instructions and
for a summary of the overall pipeline. Jump to:

1. get the [reference genome](#1-reference-genome)
2. get the [SNP data](#2-single-nucleotide-polymorphism-snp-data)
3. build [individual genomes](#3-build-individual-genomes)
4. build non-overlapping [blocks](#4-non-overlapping-alignments-blocks)
5. get a [tree](#5-get-a-tree-for-each-block) for each block
6. calculate [distances](#6-calculate-distances-between-all-pairs-of-trees)
  between trees
7. [test](#7-test-for-tree-similarity) tree similarity
8. [optional](#8-optional-challenge) re-run with smaller blocks

---

## 1. reference genome

Download the *Arabidopsis thaliana* reference genome
from the Arabidopsis Information Resource TAIR,
version 10: <ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/>
You should find 7 chromosomes: chromosomes 1 though 5,
the mitochondrial DNA ("chrM") and the chloroplast DNA ("chrC").

Document (and report in your results) the size of each chromosome
in terms of file size.

## 2. single nucleotide polymorphism (SNP) data

The data can be accessed online, starting from
[here](http://signal.salk.edu/atg1001/download.php).

- read the [README](http://signal.salk.edu/atg1001/data/README.txt)
  file in the section "Data Downloading Readme".
  It explains that each strain name links to 3 files.
  We will focus on the file named `quality_variant_<strain_name>.txt` only.
- in the "Genomes Finished" section, click on any one strain, say the first one,
  "Aa_0". The link should take you to a page that lists 3 links, one of them
  (the second) to the file of interest, named `quality_variant_Aa_0.txt`.

Download all of these "quality_variant" files, for all strains listed.
To do this reproducibly, write a script that you will document in your project.
Document and report in your result summary the number of downloaded files,
and the range of their size.
Do *not* track these data files with git!
They should be re-downloadable easily using your script.

Note: you may notice that all (most?) files of interest have a
url's that start with <http://signal.salk.edu/atg1001/data/Salk/>.
You may want to double-check that the list of strains on this page
is the same as the list on the previous page. The goal is to get the
most comprehensive data set of "quality_variant" files.
Check any assumptions that you make regarding web pages,
if data are reachable by several means.
Document and report in your result summary any unexpected links or problems.

## 3. build individual genomes

Write a script that returns an alignment of the DNA sequences of all
strains for a chromosome of interest and for a genomic range of interest.
It should take 3 arguments:

- chromosome (in 1-5, C or M)
- starting base position (e.g. 1,2,...,20000,...), with indexing starting at 1
  because "position" indices start at 1 in the SNP data files
- ending base position (e.g. 1000), in base pairs

The output alignment file should be in phylip format, for which
the conventional extension is `.phy`. As an example,
the script called for chromosome 1, region starting at 997 and
ending at position 1006 (length: 10 base pairs) could output a phylip file
named `chr1_000997_to_001006.phy`, say, which would contain this
if you we considered the first two strains only ("Aa_0" and "Abd_0"):

    2 10
    Aa_0 ATTTGGTTAT
    Abd_0 AATTGGTTAT

The phylip format requires a header (first row) that gives the number of
sequences (here 2) and the length of each sequence (here 10).
Then each line should start with the strain name (some sequence name in general),
then one or more spaces, then the DNA sequence itself. The strain name should
only contain normal word characters: letters, digits, and underscores.

It is possible that some bases will be gaps when absent, coded with a dash `-`.

The example name `chr1_000997_to_001006.phy` uses padding padding zeros to make
sure that this and other files would be sorted correctly when listed
by the shell, python or julia (provided enough padding zeros are used).
This will be important for step 6(b) and 7(b), in which trees from consecutive
blocks will need to be compared.
In other words: using padding zeros here could make step 6(b) easier.

Note that the SNP files have information about the reference base at each
site where a difference was found. Use this information to check your code.
Document any discrepancy found between the reference genome and the reference
nucleotides in the SNP files (if no discrepancy, hopefully, say so).

Annotate and document your script to make it easy to re-use later,
by yourself or someone else.
In your result summary, show how to use the script on a simple example
that should run fast, such as to produce the file `chr1_000997_to_001006.phy` above.

## 4. non-overlapping alignments blocks

### script

Write a script to extract from a chromosome *non-overlapping* and
*consecutive* alignments -or blocks- of some fixed length,
for example 100,000 base pairs (except for the last block perhaps).
This new script should use your script in step 3.
For example:
- a chromosome that has a total of 18,585,056 base pairs (bp)
  would be cut into 186 blocks total: 185 blocks of 100,000 bp each,
  plus 1 final block of only 85,056 bp.
- from a chromosome of 18,585,056 bp total, the script could
  extract 30 blocks of length 100,000 bp each from the "interior"
  of the chromosome, covering the following intervals, say:

      9,000,001 - 9,100,000 bp for block 1,
      9,100,001 - 9,200,000 bp for block 2,
      ...
      11,900,001 - 12,000,000 bp for block 30.

Your script should take 3 or 4 arguments:

- chromosome (1-5, C or M)
- starting position index in base pairs (e.g. 1 in the first example above,
  or 5,000,001 in the second example)
- number of blocks to produce (e.g. 1,2,...)
- optionally, the block size (e.g. 100,000 bp)

For the block size, use 20,000 bp by default for the chloroplast and
mitochondrial genomes (C & M), and use 100,000 bp by default for any
nuclear chromosome (1-5).
The script should be able to produce the 30 blocks as in
the second example above, for example, if given 5000001 as
starting position and 30 as the number of blocks.
You may choose to start indexing at 0 instead of 1,
depending on personal preference and
whether you use the shell, python or julia.

Start small to test your script: say with just 5 strains and 3 alignment blocks,
each with only 500 base pairs, resulting in only 3 files, each with
only 5 sequences of 500 nucleotides. You may choose to track the final
version of these files (after using them to develop and test your code),
as examples to show yourself or others how your pipeline works.
To do this small test, the 4<sup>th</sup> argument (block size)
would come in handy.

You can make these blocks and store them, but that would take a lot of
memory on your machines. Instead, you can make them on the fly as needed
in step 5 below, if you combine this block-making step with
step 5 below in a pipeline or within the same script.
If your script is slow, then it would be safe to save the alignments instead.

**file names**: you are strongly suggested to use names with padding zeros,
such that an alphabetical ordering on your files will correspond to the
physical ordering of the blocks on the genome.
For example, a block starting at position
`9,000,001` could be named `chr1_09000001.phy`,
to make it come before the block starting at position
`11,900,001`, which would be named `chr1_11900001.phy`.
This could be important for step 6(b) and 7(b), in which trees from
*consecutive* blocks will need to be compared.


### results

In what follows (steps 4-7), restrict your analysis to
**one chromosomes of your choice**.
If multiple groups analyze multiple chromosomes, you will be able
to compare the conclusions across different chromosomes during the
peer review process, which could be interesting.

- If you choose one of the nuclear chromosomes (1-5),
  pick an "interior" part of the chromosome and build
  **30 blocks**, each of length **100,000 bp**.
  The ends of nuclear chromosomes (the "telomeres") are weird and should be
  avoided, so definitely *avoid* the first and the last 30 blocks!
- If you choose the chloroplast or the mitochondrial genome (C & M),
  build the most number of blocks, each of length **20,000 bp**
  (except for one block perhaps).

Absolutely document your choice of chromosome and block positions.

The reason for these restrictions is to avoid long computation times,
given the scope and timeframe of a course assignment.

**Do not** track these alignment blocks with git, because they can
be reproduced using your scripts, and because they are very large collectively.
As said earlier, you may instead track a test version
(e.g. 5 strains and 3 short blocks): this would help collaboration
among team members, and would help an outside collaborator
understand or re-run your pipeline.

## 5. get a tree for each block

The goal of this step is to analyze each block and estimate a tree that
describes the genealogy of the plants, based on their DNA.
You do not need to know the statistical basis for this estimation step,
which can be done with the program [IQ-TREE](http://www.iqtree.org).
IQ-TREE is the fastest program with excellent accuracy for estimating
genealogical trees.

### install IQ-TREE

[Download](http://www.iqtree.org) the latest version for your operating system,
move the package in a convenient place, and move the executable in your
`~/bin/` directory to easily run the program from anywhere.
Alternatively, you could make a link in your `~/bin/` folder to point
to wherever the executable is, e.g.

```shell
ln -s ~/apps/iqtree-2.1.1-MacOSX/bin/iqtree2 ~/bin/iqtree
iqtree --version
```

If your Mac refuses to run iqtree because it was download from the web, then:
choose Apple menu  > System Preferences, click Security & Privacy, then click General. You should see a note saying that iqtree was blocked. Click "allow anyway". Then re-try running iqtree, like `iqtree --version`.

For Linux and Windows users, see [here](http://www.iqtree.org/doc/Quickstart)
for installation, using packages managers like `apt-get`, `conda`, `brew` or `pkg`.

### how to run IQ-TREE

As an example, let's say that one of your alignment block is like below,
in a file named `fake.phy` in directory `alignement/`:

    4 10
    Aa_0  ATTTGGTTAC
    Abd_0 AATTGATTCT
    Ag_0  AATTGATTAT
    Ak_1  ATTTGGTTAT

Run this command from directory `iqtree/`, say:

```shell
iqtree -s ../alignments/fake.phy -m HKY+G -T 2 -pre fake
```

IQ-TREE will create output files named `fake.*` in the current directory
because of the `-pre fake` option.
The main output file containing the tree will be in `fake.treefile`.
`fake.iqtree` would contain a quick visualization of the tree, if you are curious.
In this example the tree looks like this,
showing that Abd_0 and Ag_0 are sister:

    % cat fake.treefile
    (Aa_0:0.1072067619,(Abd_0:0.1329274929,Ag_0:0.0000010000):0.2869958964,Ak_1:0.0000010000);

In this "parenthetical description" of the tree, the numbers give branch lengths
measured in average number of DNA changes per site (i.e. per column in the alignment).


#### options to adapt

- the `-s` option is for the sequence file: adapt it to your input file name.
- adapt the `-pre` option value to change the name of output files.
- `-T 2` is to use 2 threads: adapt this to your machine.
  Do *not* use more threads than your machine has! IQ-TREE also has an option
  `-T AUTO` to automatically choose the number of threads appropriate for your machine.
  (This option was `-nt` in versions 1.x.)

Keep the option `-m HKY+G`, which describes the statistical model for sequence evolution:
the choice here is both computationally tractable and biologically flexible
(e.g. allowing for fast-evolving and slow-evolving sites).

You may also consider these other useful options:
- `--no-log` to suppress the creation of the `.log` file,  
  `--no-iqtree` to suppress the creation of the `.iqtree` file
  <!-- `--no-uniqueseq` to suppress the `.uniqueseq.phy` file --no longer created -->
- `-djc` to further suppress the output files `.bionj` and `.mldist`
- `-quiet` to suppress printing information to the screen
- `-redo` to rerun an analysis that had already been started (or finished)
- `-fast` to make the search much faster, but far less accurate --
  definitely document this option if you need to use it.

### script

Write a script to run IQ-TREE and retain the main output file
for each block from a given chromosome, starting at some block and
for some number of blocks. Like in step 4, your script should take
3 or 4 arguments:

- chromosome (1-5, C or M)
- starting position index in base pairs (e.g. 1 in the first example above,
  or 5,000,001 in the second example)
- number of blocks to produce (e.g. 1,2,...)
- optionally, the block size (e.g. 100,000 bp)

You can modify and expand your script from step 4
to make it do both steps 4 & 5: build an alignment and build a tree from it
(then delete the alignment to save memory).
Like always, annotate and document your script to make it easy to re-use later.
Show how to use it in your result summary.

Also, continue to pay attention to file names, to avoid a wrong ordering
of files when comparing consecutive blocks.

Again, start small to test your script: say with the same 5 strains and
3 short (500 bp) alignment blocks that you used to test your script in step 4.

Of course, larger blocks will cause IQ-TREE to run slower.
The running time will increase linearly with the length of the alignment,
that is, an alignment twice as long will roughly take twice as much time.
However, the running time increases far more than linearly with the number
of sequences (i.e. strains): an alignment with 10 strains will take far more
than twice longer than an alignment with 5 strains.
Therefore, to predict running time, first increase the number of strains,
then increase the length of your blocks.
That said, IQ-TREE is amazingly fast for the task.

### results

When your script is ready, use it to analyze your choice of
chromosome and blocks (30 blocks if you choose a nuclear chromosome).

If the computations take a long time (say if you run steps 4 & 5 with
a single script), you may divide them across all team members.
For example, each member could run the code to create & analyze with IQ-TREE
10 of the blocks.

You may track with git the resulting tree files from your test version
(e.g. 5 strains and 3 short blocks: 3 small tree files only).
I recommend that you also track the results on your final blocks,
after you are fairly sure to have their final version:
each tree file is a text file, relatively small, and
there would be 30 of them only.
They can be reproduced with your scripts, yes, but perhaps not easily
and not fast (at least not if you had wanted to analyze a full chromosome
instead of 30 blocks only).
Since they are rather small, it's worth tracking them.

### documentation

As always, comment your code and document its usage outside the code.
But since this step make take a while to run,
you should also document the time it takes. You must be able to predict
the running time for your full 30 blocks
shortly after you start the computations,

For this: document when you started a series or runs,
what you started, on which machines, and when the runs finished.
Write this information in some readme file, update it as runs finish,
and push to / pull from github to share the computations progress
with your team members.
If you use a separate or dedicated readme file for this information,
include a summary of it in your report summary.

You may be interested to predict how much computing time it
would take to analyze all 7 chromosomes,
based on extrapolating from your 30-block analysis.

## 6. calculate distances between all pairs of trees

Calculate the [Robinson-Foulds](https://en.wikipedia.org/wiki/Robinson–Foulds_metric)
(RF) distance between pairs of (unrooted) trees.
You do not need to know how this distance is defined. In case you
wonder, it satisfies the triangle inequality and
d(T<sub>1</sub>,T<sub>2</sub>)=0 only when T<sub>1</sub> and T<sub>2</sub>
have the same unrooted topology.
Calculate the RF distance

<ol>
<li type="a"> between pairs of trees from all your 30 blocks
  (if you chose a nuclear chromosome). That's 30*29/2 = 435 pairs of trees.</li>
<li type="a"> between pairs of trees from consecutive blocks only,
  which would be 29 pairs if you chose a nuclear chromosome.</li>
</ol>

This could be done in several ways. The simplest is to use IQ-TREE.
We provide an example in this repository: file `treedist/fake-chr4-all.tre`
contains this list of 4 trees

    (Aa_0:0.2,(Abd_0:0.1,Ag_0:0.06):0.3,Ak_1:0.04);
    ((Aa_0:0.1,Ak_1:0.03):0.3,Abd_0:0.02,Ag_0:0.4);
    ((Aa_0:0.6,Abd_0:0.1):0.3,Ag_0:0.2,Ak_1:0.5);
    (Aa_0:0.2,Abd_0:0.1,Ag_0:0.06,Ak_1:0.04);

From directory `treedist`, we can compare all pairs of trees in this file with
the option `-t` of IQ-TREE:

```shell
iqtree -t fake-chr4-all.tre -rf_all -T AUTO
```

You may again choose to add options like `-quiet` or `--no-log`.
The main output is a file named `fake-chr4-all.tre.rfdist`
(or some other name if you use the option `-pre xxx`) and contains:

    4 4
    Tree0       0 0 2 1
    Tree1       0 0 2 1
    Tree2       2 2 0 1
    Tree3       1 1 1 0

In this output, the first column (Tree*i*) gives the
index *i* (starting at 0) of each tree in the pair being compared.
Trees are ordered similarly within each row,
although their names are not printed (no header).
The numbers in the matrix are the RF distances.
Here tree 0 and tree 1 are at distance 0 (they are equal as unrooted trees),
but tree 2 is at distance 2 from both tree 0 and from tree 1,
and tree 3 is at distance 1 from all others.

All pairs of adjacent trees (i.e. trees on adjacent lines in the file)
would be compared using this command:

```shell
iqtree -t fake-chr4-all.tre -rf_adj -T AUTO -quiet
```

The output file has the same name as above (beware!) but would look like this:

    XXX        1 4
     0 2 1 0

The first line says that there are 4 trees. The second line gives the distance
between tree 0 and tree 1 (0), between tree 1 and tree 2 (2), and
between tree 2 and tree 3 (1).
The last 0 is... extra for free: it should be ignored.

Again, document this step in your report summary, with the commands
or script that you used, output file names etc.

## 7. test for tree similarity

<ol>
<li type="a">
  Are the observed tree distances smaller than expected if
  the 2 trees were chosen at random uniformly?
  We would think so, if each plant was from a distinct population
  and if populations did not mix.
</li>
<li type="a">
  Do trees from consecutive blocks tend to be more similar to each
  other (at smaller distance) than trees from randomly chosen blocks
  from the same chromosome?
  We would expect so if blocks were small, due to less "recombination"
  between neighboring blocks than between blocks at opposing ends of the chromosome.
</li>
</ol>

Answer these 2 questions for each chromosome separately.

For (a), use the fact that the RF distance between
2 uniform random trees is *D*=2\*(*n*-3-*S*) where

- *n* is the number of plant strains, or number of tips in general,
- *S* has a distribution that is approximately
[Poisson](https://en.wikipedia.org/wiki/Poisson_distribution)
with mean 1/8,
from results in [Steel (1988)](http://epubs.siam.org/doi/abs/10.1137/0401050) and
[Steel & Penny (1993)](https://sysbio.oxfordjournals.org/content/42/2/126.abstract)
(*S* is the number of shared bipartitions).

In other words, *n*-3-*D*/2 = *S* has a Poisson distribution with mean 1/8,
approximately if *n* is large, when *D* is the distance between two
uniformly random trees.

To answer 7(a): plot the distribution of *D* between random trees, and
overlay the distribution of distances obtained in step 6(a).
You may choose to focus on the distribution of the similarity
*n*-3-*D*/2 instead of *D* itself,
observed in your data versus expected from random trees.
You may choose to visualize extra information on your plot, such as the mean of
each distribution, or any other summary that you might find useful to answer 7(a).
Using this display, compare these 2 distributions and conclude to answer 7(a).

To answer 7(b): use a plot to overlay two distributions: the distribution
of distances *D* between consecutive trees as obtained in step 6(b),
and the distribution of distances between trees chosen randomly from
the blocks of the same chromosome, which you have from step 6(a).
Again, you may choose to display the distributions of similarities
*n*-3-*D*/2 instead of the the distributions of *D* itself.
Use this display to answer 7(b) qualitatively.

<!--
Steel, M. A. 1988. Distribution of the symmetric difference metric on phylo- genetic trees. SIAM J. Discrete Math. 1:541–551.
Steel, M. A., and D. Penny. 1993. Distributions of tree comparison metrics— some new results. Syst. Biol. 42:126–141.
-->

notes:

- no statistical test is required (e.g. no p-value), as this
  would add complexity beyond the learning goals of the course.
- *D* and *S* = *n*-3-*D*/2 have discrete distributions, so histograms
  might be appropriate.
- R, Python or Julia may be used to produce the plots needed to answer
  7(a) and 7(b). I recommend R for the quality of its graphics.
  Below are examples to calculate the probability
  that *S*=1 if *S* is Poisson with mean 1/8, in R:

```R
dpois(x=1,lambda=1/8) # 0.1103121
```

or in python:
```python
import scipy.stats
scipy.stats.poisson.pmf(k=1, mu=1/8) # 0.1103121
```

or in julia:
```julia
using Distributions
pdf(Poisson(1/8), 1) # 0.11031211282307445
```

## 8. optional challenge

Now that you have a full pipeline ready: can you
re-run steps 4-7 entirely, but this time using shorter blocks?
Do the conclusions change, depending on the genomic scale that
we are looking at?

For example, you might create blocks of smaller size,
like 50 blocks of 10,000 bp each. Shorter blocks have less data,
so the trees from shorter blocks could be expected to be more noisy,
so more variable and less similar to each other.
But perhaps "spatial" correlation could be higher using smaller blocks:
with neighboring blocks having more similar trees than non-neighboring blocks.
Is it the case?

This part is not required to get full credit on this project.
It is entirely optional. You might as well have fun with your
pipeline now that it's ready, and be proud of it!
