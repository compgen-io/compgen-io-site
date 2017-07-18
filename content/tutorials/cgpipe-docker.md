+++
date = "2017-07-18T13:01:00-05:00"
draft = true
title = "Docker containers with CGPipe"
type = "tutorials"

+++

CGPipe is a powerful tool for executeing bioinformatics data analysis workflows. Much
of its power derives from its inherent flexibility. In addition to supporting a variety of batch
scheduling environments (SGE, SLURM, PBS), it can support different modes of 
executing jobs. The way we'll explore executing jobs within Docker containers is to use the 
[HEREDOC pattern](https://en.wikipedia.org/wiki/Here_document).


## Docker

[Docker](https://www.docker.com/what-docker) is a platform for running programs within a container.
The container lets you build and ship programs with all of their dependencies intact. This is a
really good pattern to use for reproducible research. It's by far not the only pattern, but it's a
good one if your cluster supports it.

Docker containers are started using the command-line `docker` command. It is out of the scope of this
document to go into all of the ways that Docker can be started (or how to create a container image). So,
instead we'll assume you're using the [`asclab/spcg-working`](https://hub.docker.com/r/asclab/spcg-working/) 
container. This container includes BWA, [ngsutilsj](/projects/ngsutilsj), STAR, bcftools, 
and samtools. However, it doesn't include any reference genomes (indexed or FASTA). This is a CentOS 7 based
image, so if your tools are expecting something else, or if you need additional binaries, you'll want to
work with your own image.

### Job integration

In order to use the Docker container, we will mount the current working directory as `/data` 
in the Docker container. We can then use this as the working directory for the job. We will then start the 
container and execute the given job snippet in the context of the container by using `/bin/bash` as our 
Docker entrypoint. Specifics on  how to do this will be described below.

Note: This is only one way to do this and may not be the best. There is no current "best-practice" for this,
merely only something that has worked for us. So please experiment and share your results!

### Security

One downside of Docker is that it requires support from your execution system (HPC cluster). Specifically, 
it requires granting a user the equivalent of root-level permissions, which is obviously a security issue
on multi-user clusters. Reducing this security exposure is an active area of work. However, if your
cluster supports docker (or is single-user), then this is a viable solution.

### Alternatives

Some alternatives to Docker containers are: 

* [Environment modules](http://modules.sourceforge.net) - Old school method for managing program versions
* [Singularity containers](http://singularity.lbl.gov/) - Docker alternative containers from Berkeley Lab that doesn't require root permissions, thus compatible with existing HPC systems. This is a system that we are actively exploring and working to deploy across our HPC clusters and pipelines.


## Meta targets

Currently, CGPipe supports four different "meta-targets": `__setup__`, `__teardown__`, `__pre__`, and `__post__`.


`__setup__` and `__teardown__` are executed at pipeline run-time (not submitted to a scheduler) to do things like
make a child directory or remove a temporary file. `__setup__` is run before any other jobs are submitted to the 
scheduler and `__teardown__` is executed before CGPipe returns. However, `__pre__` and `__post__` are job-specific 
meta-targets that are included in the main job snippet. Crucially, they are *not* job dependencies, they are included
in the body of the job script itself.

One example of this would be to help track the time required for a job to start/finish.  Let's say you had the 
following job definition:

    output.txt: input.txt
        ./myprog input.txt > output.txt

This would result in the following job script (assuming the SBS runner):

    #!/bin/bash
    #SBS -name cgjob_output.txt
    #SBS -wd .
    set -eo pipefail
    ./myprog input.txt > output.txt


As an example, this is a pretty simple pipeline that has only one task. If you wanted to write the start / finish
times to stdout for this job, you could use the `__pre__` and `__post__` meta targets like this:

    __pre__:
      echo "Start: \\$(date)"

    __post__:
      echo "Done: \\$(date)"

    output.txt: input.txt
        ./myprog input.txt > output.txt

This will result in a job script that looks something like this:

    #!/bin/bash
    #SBS -name cgjob_output.txt
    #SBS -wd .
    set -eo pipefail
    echo "Start: $(date)"
    ./myprog input.txt > output.txt
    echo "Done: $(date)"

If you had multiple tasks, then the `__pre__` and `__post__` would be applied to each job. This makes these meta
targets a powerful method for altering or monitoring the execution of each task in a pipeline. Some other ideas where
the `__pre__` and `__post__` meta targets could come in handy tracking job start/finish in an external 
monitoring program, downloading inputs from cloud storage (e.g. S3), uploading outputs to cloud storage, changing file
permissions, etc...

Note the escaped `\\$(date)` above -- if this wasn't escaped CGPipe would shell out to get the date at run-time. This would
then show the date/time that the script was run. An alternative would be to avoid the shell escape and do something 
like this:

    __pre__:
      echo -n "Start: "
      date



## Job settings

CGPipe job snippets are nothing more than shell (bash) scripts, which in combination with the `__pre__`
and `__post__` CGPipe meta targets gives a pipeline author a lot of flexibility. It also means
that you can adapt the pipeline to work with your system, not adapt your system to the pipeline.

Because not all jobs will require a Docker container to execute, it is appropriate to configure the container
settings on a job-by-job basis. Like all job settings, it is possible to set these on a per-job, per-pipeline, 
or per-system basis. Any cgpipe variable starting with `job.` (including user-defined ones) is available within
the job snippet context, so we will use that to set a few Docker-specific variables. Specifically, we will use
`job.docker.container`. `job.docker.container` will be set to the container image name to use for this
job.


## Putting it all together

For a trival example, lets assume you have a BAM file and you'd like to calculate some alignment QC statistics.
A good way to do this would be to use [ngsutilsj](/projects/ngsutilsj) and run the following snippet:

    ngsutilsj bam-stats input.bam > output.stats.txt

We may not have `ngsutilsj` installed on our cluster, but it is available in the `asclab/spcg-working` Docker container.


To setup the Docker container, we'll use the `__pre__` and `__post__` 
meta targets to wrap the entire job snippet in a HEREDOC. That will then send the script to a the container's 
entrypoint (`/bin/bash`) to execute in the context of the container.

Here is what our trival example looks like as a cgpipe script:

    output.stats.txt: input.bam
        ngsutilsj bam-stats input.bam > output.stats.txt


Now, we can add the `__pre__` and `__post__` to wrap the snippet. Note: this assumes the program `realpath` 
is installed. `realpath` is used to get the absolute path for the current directory. Absolute paths are
required by Docker to bind local directories as volumes in the container (you can also get this with a 
Perl or Python one-liner).

    __pre__:
        <% if job.docker.container %>
        docker run --rm -i \
          -v $(realpath .):/data \
          -w /data
          ${job.docker.container} /bin/bash <<HEREDOC
        <% endif %>

    __post__:
        <% if job.docker.container %>
        HEREDOC
        <% endif %>

    output.stats.txt: input.bam
        <%
          job.docker.container="asclab/spcg-working"
        %>
        ngsutilsj bam-stats input.bam > output.stats.txt


This results in the following job script:

    #!/bin/bash
    #SBS -name cgjob_output.stats.txt
    #SBS -wd .
    set -eo pipefail
    docker run --rm -i \
      -v /my/path:/data \
      -w /data
      asclab/spcg-working /bin/bash <<HEREDOC
    ngsutilsj bam-stats input.bam > output.stats.txt
    HEREDOC

One thing to look out for is the whitespace surrounding the `HEREDOC` in `__post__`. This needs to end up 
as the first thing on a line without any preceeding whitespace. If you use consistent indentation, this normally
isn't a problem, but it's something to look out for.

Using variations on this theme, it's possible to do all sorts of things, like dynamically include different volumes,
download or upload Docker images, etc. Also, this isn't a very generic CGPipe script, with the filenames being hard-coded,
but it serves as an example of how to integrate Docker with CGPipe pipelines.