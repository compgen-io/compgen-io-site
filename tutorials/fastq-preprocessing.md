---
title: "Tutorial: FASTQ Pre-processing"
permalink: /tutorials/fastq-preprocessing
layout: default
nav_order: 2
parent: Tutorials
---

# Tutorial: FASTQ Pre-processing
{: .no_toc }

The first step in NGS analysis is pre-processing your [FASTQ](/tutorials/formats#fastq) files. The
following tutorial uses [ngsutilsj fastq-filter](/ngsutilsj/fastq-filter) to process and filter FASTQ
files.

## Overview
{: .no_toc .text-delta}

1. TOC
{:toc}


## Sequence QC tools

It's important to measure certain quality control metrics with FASTQ files.
You should run the same QC checks against the files before and after pre-
processing. This will help you assess the quality of your data and measure 
how well the pre-processing is working. QC monitoring is a critical part of NGS
analysis that is often neglected. Without monitoring read QC, you may inadvertently 
use low-quality data, which could produce invalid analysis. (and a lot of wasted effort!)

### FastQC

One commonly used program to assess the quality of FASTQ data is [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/). 
FastQC is a good tool for assessing the initial quality of FASTQ reads and provides a number
of quality control metrics, including per-base sequence quality, GC %, per-base 
call frequency, over-represented sequences, and adapter content. The final report
from FastQC can be saves as a ZIP or HTML report for use in pipelines. However,
FastQC can take a while to run on larger files.

### ngsutilsj fastq-stats
For high-throughput streaming workflows, where the FASTQ data is processed on-the-fly, 
it may not be possible (or practical) to save a copy of the data. In this case, you need a tool that
can calculate QC metrics for FASTQ data that is streamed as part of a stdin/stdout pipeline. [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats)
supports this method and calculates per-base sequence quality, GC %, per-base call
frequencgy, and adapter content. Additionally, [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats) also support interleaved FASTQ
files and reporting first/second read stats separately. The final report from [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats) is 
a raw text file that requires further processing to produce figures. 

Importantly, when inserted into a FASTQ pipeline, [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats) requires no extra
processing time, and minimal memory/CPU resources.

## DNA-seq filtering methods

Pre-processing DNA-seq files is more straightforward than RNA-seq, so we'll
start there. For DNA-seq, the primary concern is removing low-quality bases
and reads before sending them through the computationally intensive alignment
process. The more that we clean up the data before alignment, the better the
aligned data will be.

Here are some of the ways to cleanup FASTQ reads with [ngsutilsj fastq-filter](/ngsutilsj/fastq-filter):

1. Remove reads based on a name include/exclude list
  If you have a specific list of reads to keep or drop, they can be passed as a `--include`
  or `--exclude` respectively.

1. Fixed base count 5'/3' trim  
  You can remove a fixed number of bases from the 5' or 3' ends of a read
  with the `--prefixtrim` or `--suffixtrim` options.

1. Remove low quality bases from the 5' and 3' ends  
  It is common for there to be stretches of low-quality base calls at the 3' 
  end of a read. It is less common to see low-quality calls at the 5' end. You 
  can set a fixed threshold for minimum call quality at the 5' or 3' ends using the
  `--prefixqual` and `--suffixqual` options. For example, if the threshold is set at
  3, then any base with a Phred quality score less than 3 will be removed from the
  ends of the reads.

1. Trim adapter sequences  
  If the fragment being sequenced is shorter than the read length, you will see adapter
  sequences as part of the read sequence. Because these are artifacts of the sequencing
  reaction and not part of the organism, it is important to remove these sequences. There are 
  three options for removing adapters: `--trim-seq`, `--trim-seq1`, `--trim-seq2`. The
  first option trims an adapter from all sequences in a file. The second and third options
  trim the adapter from the first and second reads, respectively (assuming an interleaved
  FASTQ file). If you have a non-interleaved file, then `--trim-seq` and `--trim-seq1` are
  equivalent.  As extra options for adapter trimming: `--trim-pct` sets the required match
  percentage a the read has to have to match the adapter. The default is 0.9, or 9 out of
  10 bases must match. The second option is `--trim-overlap`, which sets the minimum amount
  of sequence must match at the 3' end of the read to trigger trimming. The default value
  is 6 bases.  
  <br/>
  Note: adapter trimming is done using a sliding window, so it is necessarily computationally
  intensive. It should only be done when you really need to do it.  
  <br/>
  For Illumina sequencing, the recommended adapter trimming sequences can be set using the 
  `--trim-illumina` option. These sequences are read-specific and are shown below:

    * read1: AGATCGGAAGAGCACACGTC
    * read2: AGATCGGAAGAGCGTCGTGT
  
1. Limit abiguous/wildcard (N) bases  
  Reads with too many *N* calls can be removed using the `--wildcard` option.

1. Size selection
  After all of the above trimming, the final read filter can require a certain minimum read length
  with the `--size` option.

1. Required valid paired reads (requires interleaved FASTQ file)
  If you have an interleaved FASTQ file, you can use the `--paired` option to require that both
  reads from a fragment need to pass the filters. Otherwise, you can end up with an unbalanced FASTQ
  file, which can lead to unpredictable results in the downstream analysis. However, this option
  is only available when using an interleaved FASTQ file. Processing two separate files and trying
  to merge them after the fact is computationally difficult and may require a lot of memory to resolve
  mismatches between the files.


Note: filters are applied in the above order, so that (for example) low-quality bases at the 5'/3' ends can be
trimmed away before triggering the ambiguous base call filters.

### Examples

Here is one way to filter a single-end FASTQ file, or a split paired-end (not interleaved) file:

    # trim 3' low-quality bases
    # remove reads with more than 2 N's
    # require the final size to be at least 50bp

    ngsutilsj fastq-filter --size 50 --wildcard 2 --suffixqual 3 input.fastq.gz > filtered.fastq

<br/>
Here is a more complete set of filters, including a merging step to combine paired-end
files into one interleaved FASTQ file first.

    # trim 3' low-quality bases
    # remove illumina adapters
    # remove reads with more than 2 N's
    # require the final size to be at least 50bp
    # require reads to be properly paired

    ngsutilsj fastq-merge input_R1.fastq.gz input_R2.fastq.gz | \
    ngsutilsj fastq-filter --size 50 --wildcard 2 --suffixqual 3 --trim-illumina --paired - | \
    gzip > filtered.fastq.gz

<br/>
Finally, we can add [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats) into the mix to calculate some
summary statistics on the fly for both the raw FASTQ reads and the post-filtering reads.
By merging the paired FASTQ files and using [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats),
we can efficiently pre-process the FASTQ reads in one pipeline and limit unnecessary disk I/O.

    ngsutilsj fastq-merge input_R1.fastq.gz input_R2.fastq.gz | \
    ngsutilsj fastq-stats --pipe -o raw.stats.txt - | \
    ngsutilsj fastq-filter --size 50 --wildcard 2 --suffixqual 3 --trim-illumina --paired - | \
    ngsutilsj fastq-stats --pipe -o filtered.stats.txt - | \
    gzip > filtered.fastq.gz

<br/>
As shown above and following *nix conventions, many of the [ngsutilsj](/ngsutilsj) tools can 
operate in streaming mode by specifying "`-`" as the input filename, reading input from *stdin*. [ngsutilsj fastq-stats](/ngsutilsj/fastq-stats) 
can be coerced into passing the incoming FASTQ data through to *stdout* with the `--pipe` option.

## RNA-seq filtering methods

Pre-processing RNA-seq data can be done in the same manner as DNA-seq data, with the same general
options. But, with RNA-seq data, there is another filtering step that you should consider: 
ribosomal sequence filtering. A good library prep will remove the majority of rRNA sequences
before they are sequenced. If this depletion fails, then many of reads will be from
rRNAs. This makes tracking the abundance of rRNAs an important QC metric to ensure consistent
data.

Filtering out rRNA reads is covered in-depth in the [RNA-Seq workflow](/tutorials/rnaseq-star) tutorial.
