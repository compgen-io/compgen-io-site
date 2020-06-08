---
title: "Tutorial: Docker with cgpipe"
permalink: /tutorials/docker-cgpipe
layout: default
nav_order: 3
parent: Tutorials
---

# Tutorial: Docker with cgpipe
{: .no_toc }

## Overview
{: .no_toc .text-delta}

1. TOC
{:toc}

[CGpipe](/cgpipe) is a powerful tool for executing bioinformatics data analysis workflows. Much
of its power derives from its inherent flexibility. In addition to supporting a variety of batch
scheduling environments (SGE, SLURM, PBS), it can support different modes of 
executing jobs, such as in the context of a Docer container. The way we'll explore executing 
jobs within a container is to use the [HEREDOC pattern](https://en.wikipedia.org/wiki/Here_document).

## Heredocs

What are heredocs? Heredocs are a feature of shell scripts that let you send multiple lines of 
data as *stdin* to a program (an input-stream literal). One common way they are used is to write 
multiple lines to a file at a time.

    cat <<HEREDOC > output.txt
    line 1
    line 2
    etc...
    HEREDOC

You don't need to use the delimiter `HEREDOC`, it could be any string. Another commonly used string is `EOF`.

    cat <<EOF > output.txt
    etc...
    EOF

We are going to use this to have CGPipe wrap a job script and send that as *stdin* to `bash` running in a container.

## Docker

We'll assume you're already familiar with [Docker](http://www.docker.com), but briefly Docker
a platform for running programs within a container. The container lets you build and ship programs with any needed
dependencies intact. This results in a consistent execution environment for data analysis pipelines.

It is out of the scope of this document to go into all of the ways that Docker can be started (or how to 
create a container image). However, if your job can be started as a shell script, you can use this method 
to run your job in a container. We will use `docker run` to start our script.

### Job integration

In order to use the Docker container, we will mount the current working directory as `/data` 
in the Docker container. This will be the working directory for the job. We will then start the 
container and execute the given job snippet in the context of the container by using `/bin/bash` as our 
Docker entrypoint.

Note: This is only one way to do this and may not be the best solution for your environment. But this
should be a good starting point to adapt to your system.

### Alternatives

Here are some alternatives to Docker containers for software versioning: 

* [Environment modules](http://modules.sourceforge.net) - The original method for managing program versions. This (or a similar tool) is installed on most HPC clusters.
* [Singularity containers](http://singularity.lbl.gov/) - Docker-alternative container tool from Berkeley Lab that doesn't require special permissions and is compatible with existing multi-user HPC systems. The technique used here for Docker should also be applicable to Singularity containers.


## Meta-targets

The feature of CGPipe that will help us get our jobs running in a container are the setup/teardown/pre/post meta-targets.


These are named `__setup__`, `__teardown__`, `__pre__`, and `__post__` and are defined like any other job definition.
However, **setup** and **teardown** are executed at pipeline run-time (not submitted to a scheduler) to do things like
make a child directory or remove a temporary file. **Setup** is run before any other jobs are submitted to the 
scheduler and **teardown** is executed before CGPipe returns. However, **pre** and **post** are job
meta-targets that are included in the main job snippet. Crucially, they are *not* job dependencies, they are included
in the body of the job script itself.

How can this be helpful? One example is to track the time required for a job to start/finish.  Let's say you had the 
following job definition:

    output.txt: input.txt
        ./myprog input.txt > output.txt

This would result in the following job script:

    #!/bin/bash
    ./myprog input.txt > output.txt


As an example, this is a pretty simple pipeline that has only one task. If you wanted to write the start / finish
times to stdout for this job, you could use the **pre** and **post** meta-targets like this:

    __pre__:
      echo "Start: \\$(date)"

    __post__:
      echo "Done: \\$(date)"

    output.txt: input.txt
        ./myprog input.txt > output.txt

This will result in a job script that looks something like this:

    #!/bin/bash
    echo "Start: $(date)"
    ./myprog input.txt > output.txt
    echo "Done: $(date)"

If you have multiple tasks, **pre** and **post** are applied to each job. This makes these meta
targets a powerful method for altering or monitoring the execution of each task in a pipeline. Some other examples where
the **pre** and **post** meta-targets could come in handy tracking job start/finish in an external 
monitoring program, downloading inputs from cloud storage (e.g. S3), uploading outputs to cloud storage, changing file
permissions, etc...

Note the escaped `\\$(date)` above -- if this wasn't escaped CGPipe would shell out to get the date at run-time. This would
then show the date/time that the script was run. An alternative would be to avoid the shell escape and do something 
like this:

    __pre__:
      echo -n "Start: "
      date



## Job settings

CGPipe job snippets are nothing more than shell (bash) scripts, which in combination with the **pre** and **post** meta-targets 
gives a pipeline author a lot of flexibility. It also means that you can adapt the pipeline to work with your system, not 
adapt your system to the pipeline.

Because not all jobs will require a Docker container to execute, it is appropriate to configure the container
settings on a job-by-job basis. Like all job settings, it is possible to set these on a per-job, per-pipeline, 
or per-system basis. Any cgpipe variable starting with `job.` (including user-defined ones) is available within
the job snippet context (including **pre** and **post**), so we will use that to set a few 
Docker-specific variables. Specifically, we will use `job.docker.container`. `job.docker.container` 
will be set to the container image name to use for this job.

You can also use a similar strategy to set things like volumes or other resource requirements for the container,
but we'll keep things simple for now.


## Putting it all together

For an example, lets assume you have a BAM file and you'd like to calculate some alignment QC statistics.
One way to do this would be to use [ngsutilsj](/ngsutilsj) and run the following:

    ngsutilsj bam-stats input.bam > output.stats.txt

We may not have `ngsutilsj` installed on our system, but it is available in the `asclab/spcg-working` Docker container.


To setup the Docker container, we'll use the *pre* and *post* 
meta-targets to wrap the entire job snippet in a HEREDOC. That will then send the script to a the container's 
entrypoint (`/bin/bash`) to execute in the context of the container.


Here is what our trival example looks like as a cgpipe script:

    #!/usr/bin/env cgpipe
    output.stats.txt: input.bam
        ngsutilsj bam-stats input.bam > output.stats.txt


Now, we can add the `__pre__` and `__post__` to wrap the snippet. Note: this assumes the program `realpath` 
is installed. `realpath` is used to get the absolute path for the current directory. Absolute paths are
required by Docker to bind local directories as volumes in the container (you can also get this with a 
Perl or Python one-liner).

    #!/usr/bin/env cgpipe
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
    docker run --rm -i \
      -v /my/path:/data \
      -w /data
      asclab/spcg-working /bin/bash <<HEREDOC
    ngsutilsj bam-stats input.bam > output.stats.txt
    HEREDOC

One thing to look out for is the whitespace surrounding the `HEREDOC` in `__post__`. This needs to end up 
as the first thing on a line without any preceeding whitespace. If you use consistent indentation, this normally
isn't a problem, but it's something to look out for.
