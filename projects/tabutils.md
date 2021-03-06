---
title: tabutils
path: /projects/tabutils
layout: default
nav_order: 22
parent: Projects
---

# tabutils
[Github](https://github.com/mbreese/tabutils)

tabutils is a set of programs for viewing and working with tab-delimited text files. Because of
its utility, this is usually one of the first programs I end up installing on a new system.

## Installation

The easiest way to install tabutils is to clone the Github repository and run `make`.

## tabutils filter
Allows you to view only lines that meet certain criteria.

tabutils filter file.txt {criteria}

Eg: 

1 eq foo

- Column 1 (first column) is equal to 'foo'

1 eq foo 2 lt 3

- Column 1 (first column) is equal to 'foo' and column 2 is less than 3

Valid operations:
eq
ne
lt
lte
gt
gte
contains

## tabutils merge

Merges tab-delimited files together, combining common columns and adding uncommon columns. This is very useful for
combining data from multiple samples together into one master file. This is useful for producing "fat" files for
downstream analysis.

## tabutils concat

Combines tab-delimited files together, one after the other (concatenating). Optionally adds an additional column
to include the original filename. This is useful for producing "skinny" input files for down-stream analysis.

## tabutils view

Displays tab-delimited files, spacing columns appropriately to keep them in-line. This command is useful for viewing
and exploring data files.

## tabutils combine

Combines multiple tab-delimited files together into one Excel worksheet. Remember: for data analysis, Excel is evil. But
for those instances where you have to share data with someone who is more comfortable with Excel, this can make your
life easier.
