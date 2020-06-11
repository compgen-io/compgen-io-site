---
title: swalign
path: /projects/swalign
layout: default
nav_order: 3
parent: Projects
---

# swalign
[Github](https://github.com/mbreese/swalign)

This package implements a Smith-Waterman style local alignment algorithm. It works by calculating a sequence alignment between a query sequence and a reference. The scoring functions can be based on a matrix, or simple identity. Weights can be adjusted for match/mismatch and gaps, with gap extention penalties. Additionally, the gap penalty can be subject to a decay to prioritize long gaps over minor mismatches.

The input files are FASTA format files, or strings.

It is a useful example of how one might write an aligner from scratch. Even though it is not optimized, it is widely used as a teaching tool or for quick alignment searches when building an index would be overkill.

The aligner can be used in a stand-alone mode (`bin/swalign`) or as an importable Python library.

## Installation

swalign is available on PyPi and can be installed with pip.

    $ pip install swalign


## Example

    import swalign

    # Setup your scoring matrix
    # (this can also be read from a file like BLOSUM, etc)
    #
    # Or you can choose your own values. 
    # 2 and -1 are common for an identity matrix.
    
    match = 2
    mismatch = -1
    scoring = swalign.NucleotideScoringMatrix(match, mismatch)

    # This sets up the aligner object. You must set your scoring matrix, but
    # you can also choose gap penalties, etc...
    sw = swalign.LocalAlignment(scoring)  
    
    # Using your aligner object, calculate the alignment between 
    # ref (first) and query (second)
    alignment = sw.align('ACACACTA','AGCACACA')
    alignment.dump()

Results:

    Query: 1 AGCACAC-A 8
            | ||||| |
    Ref  : 1 A-CACACTA 8

    Score: 12
    Matches: 7 (77.8%)
    Mismatches: 2
    CIGAR: 1M1I5M1D1M




