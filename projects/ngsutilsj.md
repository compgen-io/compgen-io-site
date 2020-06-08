---
title: "ngsutilsj"
permalink: /ngsutilsj
layout: default
nav_order: 1
parent: Projects
#grand_parent: Projects
#parent: NGS
#has_children: true
#has_toc: false
# nav_exclude: true
---

# ngsutilsj
[Github](https://github.com/compgen-io/ngsutilsj)

ngsutilsj is an updated java port of the NGSUtils toolkit. This new version is largely a Java port of the 
the most commonly used tools from NGSUtils, with some additions thrown in. It is also a library, with utility
classes for use in other various NGS related software (such as [cgsplice](/cgsplice)).

Java was chosen for the ease of installation and relative speed (in comparison to the Python NGSUtils). 
The processing speed for gzipped compressed files was a major reason for the new update. This version has 
also been optimized for working on high-memory HPC clusters and streaming data analysis (to minimize disk IO).


## Installation

ngsutilsj is distributed as a self-executing fat-JAR file. This means that for installation, all one needs is
a working copy of Java and the `ngsutilsj` file. Unlike other JAR-file based NGS packages, ngsutilsj includes a
shell script shim to make it executable like a traditional Unix program. This means that to install the program,
you need to copy the `ngsutilsj` file to somewhere in your `$PATH`.

## Commands available

There are many commands available. For information on an individual command, run `ngsutilsj help command`

    ngsutilsj - Data wrangling for NGS
    ---------------------------------------

    Usage: ngsutilsj cmd [options]

    Available commands:
    [bam]
      bam-basecall     - For a BAM file, output the basecalls (ACGTN) at each genomic position.
      bam-best         - With reads mapped to two bam references, determine which reads mapped best to each
      bam-bins         - Quickly count the number of reads that fall into bins (bins assigned based on 5' end of the first read)
      bam-check        - Checks a BAM file to make sure it is valid
      bam-concat       - Concatenates BAM files (handles @RG, @PG)
      bam-count        - Counts the number of reads for genes (GTF), within a BED region, or by bins (--gtf, --bed, or --bins required)
      bam-coverage*    - Scans an aligned BAM file and calculates the number of reads covering each base
      bam-discord      - Extract all discordant reads from a BAM file
      bam-dups         - Flags or removes duplicate reads
      bam-expressed    - For a BAM file, output all regions with significant coverage in BED format.
      bam-filter       - Filters out reads based upon various criteria
      bam-readgroup    - Add a read group ID to each read in a BAM file
      bam-sample*      - Create a whitelist of read names sampled randomly from a file
      bam-split        - Split a BAM file into smaller files
      bam-stats        - Stats about a BAM file and the library orientation
      bam-tobed*       - Writes read positions to a BED6 file
      bam-tobedgraph   - Calculate coverave for an aligned BAM file in BedGraph format.
      bam-tofastq      - Export the read sequences from a BAM file in FASTQ format

    [bed]
      bed-clean        - Cleans score entries to be an integer
      bed-count        - Given reference and query BED files, count the number of query regions that are contained within each reference region
      bed-nearest      - Given reference and query BED files, for each query region, find the nearest reference region
      bed-reduce       - Merge overlaping BED regions
      bed-resize       - Resize BED regions (extend or shrink)
      bed-tobed3       - Convert a BED3+ file to a strict BED3 file
      bed-tobed6       - Convert a BED6+ file to a strict BED6 file
      bed-tofasta      - Extract FASTA sequences based on BED coordinates

    [fasta]
      fasta-filter     - Filter out sequences from a FASTA file
      fasta-gc         - Determine the GC% for a given region or bins
      fasta-genreads*  - Generate mock reads from a reference FASTA file
      fasta-mask       - Mask regions of a FASTA reference
      fasta-names      - Display sequence names from a FASTA file
      fasta-split      - Split a FASTA file into a new file for each sequence present
      fasta-subseq     - Extract subsequences from a FASTA file (optionally, indexed)
      fasta-tag        - Add prefix/suffix to FASTA sequence names
      fasta-wrap       - Change the sequence wrapping length of a FASTA file

    [fastq]
      fastq-barcode    - Given Illumina 1.8+ naming, find the lane/barcodes included
      fastq-check      - Verify a FASTQ single, paired, or interleaved file(s)
      fastq-demux      - Splits a FASTQ file based on lane/barcode values
      fastq-filter     - Filters reads from a FASTQ file.
      fastq-merge      - Merges two FASTQ files (R1/R2) into one interleaved file.
      fastq-separate   - Splits an interleaved FASTQ file by read number.
      fastq-sort       - Sorts a FASTQ file
      fastq-split      - Splits an FASTQ file into smaller files
      fastq-stats      - Statistics about a FASTQ file
      fastq-tobam      - Converts a FASTQ file (or two paired files) into an unmapped BAM file
      fastq-tofasta    - Convert FASTQ sequences to FASTA format

    [gtf]
      gtf-export       - Export gene annotations from a GTF file as BED regions
      gtf-geneinfo*    - Calculate information about genes (based on GTF model)

    [annotation]
      annotate-gtf     - Annotate GTF gene regions (for tab-delimited text, BED, or BAM input)
      annotate-repeat* - Calculates Repeat masker annotations

    [vcf]
      vcf-annotate     - Annotate a VCF file
      vcf-chrfix       - Changes the reference (chrom) format (Ensembl/UCSC)
      vcf-export       - Export information from a VCF file
      vcf-filter       - Filter a VCF file
      vcf-tobed        - Export allele positions from a VCF file to BED format

    [help]
      help             - Help for a specific command
      license          - Show the license

    * = experimental command

