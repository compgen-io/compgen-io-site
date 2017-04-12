+++
date = "2015-12-15T00:54:57-05:00"
draft = true
#nodownloads = true
title = "basespace-download"
github = "compgen-io/basespace-download"
project = "basespace-download"
type = "projects"
icon = "flask"

+++

basespace-download is a tool for downloading FASTQ files from Illumina's BaseSpace
cloud service. For some instruments, analysis happens (by default) in the cloud, which
can make retrieval difficult. Thankfully, Illumina provides a good API for interacting
with BaseSpace. This tool makes downloading files for a particular sample or project
very simple.

## App-token

You must possess a valid app-token from BaseSpace in order to use this application. This
is your method for authenticating with BaseSpace.

For more information on getting an app-token, see here: https://support.basespace.illumina.com/knowledgebase/articles/403618-python-run-downloader

## Usage

    USAGE:
       basespace-download [arguments...]
   
    ARGUMENTS:
       -t           Application token from BaseSpace [$BASESPACE_APP_TOKEN]
       -s           Sample ID to download
       -p           Project ID to download (all samples)
       --dr         Dry-run (don't download files)
       --help, -h       show help
       --version, -v    print the version

## Building from scratch 
You need to have [Go](http://golang.org) installed first. Next, you can retrieve the Go code and build it in one step:

    go get github.com/compgen-io/basespace-download

Next, you can copy the binary from $GOPATH/bin to anywhere in your $PATH.

