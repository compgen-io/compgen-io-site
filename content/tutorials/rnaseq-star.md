+++
date = "2015-12-15T00:54:57-05:00"
draft = true
title = "RNA-Seq workflow (with STAR)"
type = "tutorials"

+++

## Experimental design

The first step in getting good results from an RNA-Seq experiment is choosing a good experimental
design. This means that you need to have enough replicates, with sufficient sequencing depth to
be able to answer your research question. 

### Depth 

For differential gene expression, I recommend having at least 4 biological replicates for each
condition with a minimum of 20M reads per sample (30M recommended). Additionally, we've found that pair-end sequencing
produces more uniquely aligned reads than single-end sequencing. If you want to investigate
changes in splicing, I recommend at least 40M reads per sample (50M recommended).

### Batch effects

Additionally, you need to try to reduce any possible batch effects in your data. One common batch 
effect is due to a lane-effect present when samples are sequenced only on a single lane. If your 
control and experimental samples are sequenced on different lanes, there is no way to differentiate
between a lane-effect and biological signal. A different experimental design can be used to avoid 
batch effects by pooling (and barcoding) all of your samples together. Then you can sequence that 
pool as many times as necessary to get the required sequencing depth. So, for example, if you require
two lanes worth of data, you would sequence all samples across all lanes.

## Pre-processing

RNA-Seq reads should undergo the same pre-processing/QC filtering steps that you'd use in DNA-Seq.

It is almost more important to measure and track QC metrics with RNA-Seq data than with DNA-Seq.
Because RNA-Seq is most commonly used for gene expression analysis, it is important to make sure that
each same has a similar QC profile. It isn't necessarily important to hit exact 
QC benchmarks, but rather it is more important to make sure that all samples have a *similar* profile.
If one of your samples has vastly more rRNA or many more adapter truncted sequences, this could affect
your downstream analysis. If all of the samples have a similar profile, then you can be more confident
that your results are due to biological differences, not technical differences.

## Ribosomal RNA filtering

Ribosomal RNA is always a concern with RNA-Seq. rRNA is vastly more abundant in total RNA extractions
than mRNA or other non-coding RNAs. Because of this, it is sometimes useful to remove rRNA sequences
before mapping the remaining reads. Even if you don't filter out rRNA reads, it is a useful QC
metric to observe and track.

rRNA filtering can be done using an rRNA reference index and an alignment tool like `bwa`. `bwa` is
used instead of an RNA-specific aligner because we don't need to keep track of splicing in this
step.  The source of a good rRNA reference varys based on the organism, but possible sources 
include searching NCBI Genbank for molecules of the type *rRNA*, species-specific rRNA databases,
or pulling ribosomal regions from references genomes using RepeatMasker.

