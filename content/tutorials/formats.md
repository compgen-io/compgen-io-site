+++
date = "2015-12-15T00:54:57-05:00"
draft = true
title = "File formats"
type = "tutorials"

+++
## Sequencing formats
<a name="fasta"></a>
### FASTA [#](/tutorials/formats#fasta)

FASTA [_fast-ay_] files are the de-facto standard for storing and sharing DNA/RNA/amino acid
sequences. It is a text-file format with a header line followed by one or more lines of sequence.
The header line starts with a '>' character, which may be used for parsing the file. The remainder
of the header line consists of a name, optionally followed by a comment. The name and comment are 
separated by whitespace. The name must not contain a whitespace (` `, or `\t`) character.

The remaining lines consist of DNA, RNA, or amino acid sequences using IUPAC notation. There are no
technical specifications for line length or wrapping, but it is common practice for long sequences
(genes/genomes) to be have a consistent line length. However, it is not required for the sequence to have
any breaks. Blank lines and any whitespace in the sequence line(s) should be ignored.

FASTA is the most common format for distributing reference genome sequences. Reference genomes will
contain one sequence for each chromosome. In addition to chromosomes, some reference genomes will
also include unplaced contigs, which are sequences known to be part of the organism's genome, but
the exact position is unclear.

#### Variations
FASTA files are commonly stored as `gzip` compressed files, due to their large size and general space inefficiency. However, 
files that need to be randomly accessed need to be stored uncompressed, or compressed with a tool like `bgzip` (although the
latter is less common).

#### Example
    >sequence1 This is the comment line
    ATCGATCGATCGACTACGACTACGACGACGACATCGACATCTACT
    GGCGCGCGCTAGAGCTAGCTTGAGATAAATCGACTAGCGACTGAG
    CTATCTTCTCTATATATTTAAAAAGCGCAACTACTGACTA
    >seq2
    AATAGCGCGCGCGCGCTCATATATCTATATATAAAAACCTACTAC
    GACTACGACTATCGATCGATTATCGGTATCGTATCGGTATTATTA
    TTTAATGCGCGCGCGCCGACTAGCTAGCTATCGATCGATCGATCG
    ACTACGACTACGACGACGACATCGACATCTACT

#### Tools
FASTA files can be indexed and queried with the program `samtools faidx`. This requires a well-formatted FASTA file with
consistent line lengths.

[ngsutilsj](/ngsutilsj) contains a number of tools for managing FASTA files, including indexed FASTA files. These tools
including tagging sequence names, masking regions of sequences, splitting a FASTA file by sequence name, changing the
line wrapping for a file, or generating mock [FASTQ](/tutorials/formats#fastq) reads.

#### External links
https://en.wikipedia.org/wiki/FASTA_format

<a name="fastq"></a>
### FASTQ [#](/tutorials/formats#fastq)

FASTQ [_fast-kew_] is the most common sequencing read format. FASTQ files are text files with a four-line record
for each sequence. The first line starts with an '@' character and the unique name for the read. The 
second line is the sequence. The third line starts with the '+' character, and may optionally contain
the read name again. The fourth line is the quality score for each of the basecalls in [Phred](https://en.wikipedia.org/wiki/Phred_quality_score) scale.

#### Variations
The sequence and quality lines in the FASTQ record may be word-wrapped, like FASTA files, but this is not seen very often.

FASTQ files are almost always stored compressed, usually with `gzip`, although `bzip2` compression is sometimes
also used. FASTQ record information can also be stored in other compressed formats, such as [unaligned BAM](/tutorials/formats#unalignedbam) files 
or [SQZ](/tutorials/formats#sqz) files. However, almost all publicly available data is distributed as gzip-compressed
FASTQ files.

Paired-end sequencing data is commonly stored as two separate FASTQ files, one for each read. But, it is also possible
to store both reads in the same file. These are called *interleaved* FASTQ files. Many aligners support interleaved
files out of the box for paired end data. For those that don't an adapter tool can be used to convert interleaved files
to non-interleaved files using named FIFO pipes. Interleaved FASTQ files are slightly have slightly more efficient
compression ratios when compared to using two separate FASTQ files, but the main benefit is the need to only manage
one file per sample. Interleaved files can also be easier to filter using a tool like [ngsutilsj fastq-filter](/ngsutilsj/fastq-filter).

#### Example
    @seq1 This is the comment line
    ATCGATCGATCGACTACGACTACGACGACGACATCGACATCTACT
    +
    BBBB,(,,7AA,<((,A<,,,FKAF,,,F,F7F,7,,,AA##@!@


#### External links
https://en.wikipedia.org/wiki/FASTQ_format

<a name="unalignedbam"></a>
### Unaligned BAM file [#](/tutorials/formats#fastq)

BAM files are typically associated with read alignments to a genome, but they can also be used to store unaligned/raw 
sequences too. Unaligned BAM files store the same read information as a FASTQ file (name, sequence, and 
quality scores) and they can also store multiple reads in the same file (like interleaved FASTQ files). Also,
unaligned BAM files are compressed, and store quality score information in an optimized manner versus character
encoding. Even with the extra overhead of the BAM format, these factors make this a slightly more efficient way 
to store raw sequencing reads over FASTQ files.
