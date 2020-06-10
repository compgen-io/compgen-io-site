---
title: cgsplice
path: /projects/cgsplice
parent: Projects
#grand_parent: Projects
#parent: NGS
nav_order: 2
---

# cgsplice
[Github](https://github.com/compgen-io/cgsplice)

cgsplice is a set of tools to support direct measurement of splice junctions in 
RNA-seq data. cgsplice works by finding and counting reads that span splice junctions. 
It does this by searching for reads with an "N" gap in their CIGAR alignment string. 
Next, for all junctions, it determines the donor and acceptor sites and tallies how 
many reads span each donor/acceptor pair. Finally, using these counts for multiple 
samples, it will calculate a permuted p-value for how likely it is that a given donor 
or acceptor had differential splicing between two conditions. Reads supporting a 
cassette exon, but that don't cross a junction are not included in this model.

## Counting junction-spanning reads

The `junction-count` command will count how many reads span any particular splice
junction. Specifically, each junction is split into donor/acceptor pairs. Then for
all junctions with a common donor or acceptor, the number of supporting reads is
calculated. Only reads that have split-mapping (N gaps in the CIGAR string) are used.

Counting is done in a gene model-free method, allowing for discovery of unannotated
transcripts (if a suitable aligner is used). In addition to counting reads that span
junctions, reads that represent retained introns can also be counted.

## Differential splicing

The `splice-diff` command takes a series of `junction-count` outputs and performs a 
permutation analysis to determine which splicing donor/acceptor sites exhibit differential
splicing between two conditions. The statistical metric used is a Student's t-score with
Binomial variance. Samples are permuted across different conditions to calculate a p-value
for each donor/acceptor.

## Splicing events

The `combine-events` command merges donor/acceptors into complete splicing events, such
as cassette exons. Only donor/acceptor that meet certain criteria (FDR, effect-size)
are merged.

## Stats

The `bam-stats` command can be used to determine how many junction-spanning reads are
present in any given sample, among other things. These QC metrics can be used to assess
how useful a given BAM file is for junction analysis.

## Installing cgsplice

cgsplice is implemented in Java and distributed as a self-executing fast-JAR file. This 
requires only a recent version of Java to be installed on the system. Otherwise, cgsplice
acts as a normal command-line program.
