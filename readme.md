See:
- [overview](overview.md) of the project: learning goals,
  group work, and overview of tasks and pipeline
- [step by step](stepsinstructions.md) instructions.

Now delete these lines and replace by your own "readme"
to document your pipeline.
Your result summary should go in a different markdown file,
`report.md`.

## task 1
A shell script [1_get_refernece_genome.sh](scripts/1_get_refernece_genome.sh) is created to downloead 7 chromosomes: chromosomes 1 though 5, the mitochondrial DNA ("chrM") and the chloroplast DNA ("chrC"), into the directory [data](data).

Run `./scripts/1_get_refernece_genome.sh` to reproduce.

## task 2
A shell script [2_get_SNP_data.sh](scripts/2_get_SNP_data.sh) is created to read the web info in the "Genomes Finished" section from the [website](http://signal.salk.edu/atg1001/download.php), so as to get all of the strain names. With a `for` loop structure of `wget` command, 217 files named `quality_variant_<strain_name>.txt` would be downloaded into the directory [data](data).

Run `./scripts/2_get_SNP_data.sh` to reproduce.

## task 3
The [3_build_individual_genomes.sh](scripts/3_build_individual_genomes.sh) script  returns an alignment of the DNA seqences of the DNA sequences of all strains for a chromosome of interest and for a genomic range of interest.

It takes 3 arguments: chromosome (in 1-5,C or M), starting base position (e.g. 1,2,...), ending base position.

Under `scripts/` folder, run `./3_build_individual_genomes.sh 1 20 40` for example.

## task 4
The shell script [4_alignment_blocks.sh](scripts/4_alignment_blocks.sh) extracts *non-overlapping* and *consecutive* alignments from a chromosome and loops over the script from task 3 `3_build_individual_genomes.sh`. The script produces output files (same as in script 3) into the `alignments/` directory. Each file contains blocks of a set length and base positions from each strain.

It takes 3 arguments: 
- chromosome (in 1-5,C or M)
- starting position index in base pairs (e.g. 1,2,...)
- number of blocks to produce

Run the shell script from the main directory to reproduce (1 300000 5 is an example):
```
bash scripts/4_alignment_blocks.sh 1 300000 5
```