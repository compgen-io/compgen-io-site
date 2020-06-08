---
title: basespace-download
path: /projects/basespace-download
parent: Projects
nav_order: 23

---

# basespace-download
[Github](https://github.com/compgen-io/basespace-download)

basespace-download is a tool for downloading FASTQ files from Illumina's BaseSpace
cloud service. For some instruments, analysis happens (by default) in the cloud. This tool is for downloading that data for local processing and analysis. Thankfully, Illumina provides a good API for interacting with BaseSpace!

## App-token

You must possess a valid app-token from BaseSpace in order to use this application. This
is your method for authenticating with BaseSpace.

For more information on getting an app-token, see here: [https://support.basespace.illumina.com/knowledgebase/articles/403618-python-run-downloader](https://support.basespace.illumina.com/knowledgebase/articles/403618-python-run-downloader)

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

