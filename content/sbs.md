+++
date = "2015-12-15T00:54:57-05:00"
draft = true
title = "SBS"
github = "compgen-io/sbs"
project = "sbs"
docs = "/sbs/docs"
type = "projects"
icon = "sitemap fa-rotate-90"

+++

SBS is a single-user batch job scheduler for workstations or single servers. SBS is a good stand-in for
traditional schedulers like PBS, SGE, or SLURM. Not everyone wants to have a complete install of SGE on
their laptop. In those cases, SBS can be a quick replacement that requires minimal overhead. SBS is a 
single file program written in Python that stores job definitions in a managed folder. All job state is
stored in this folder. There is no requirement for a constantly running daemon to manage the jobs.
The user can start running these jobs at anytime and using whatever resource restrictions are necessary (eg if you
have 4 cores on a laptop, but only want to devote 2 cores to running background jobs, you can do that).

SBS runs jobs in a first-available, first run basis. Meaning, the first job that fits the available
resources that is also ready to run (has no pending dependencies) will be run. This simple scheduling 
algorithm doesn't take into account wall-time, so it is not as efficient as a more complete backfilling
schdeuler. However, SBS is also a single file, so installation is a lot easier than a proper scheduler!
`sbs run` does not run as a daemon, so it is best executed in the context of a screen or tmux session.

SBS is also supported by [cgpipe](/cgpipe) pipelines as a supported job runner. This lets you scale the
same pipelines from your local machine to an HPC cluster.

## Usage

    Usage: sbs {-d sbshome} command {options}

    Commands:
      cancel      Cancel a job
      cleanup     Remove all completed jobs
      help        Help for a particular command
      hold        Hold a job from running until released
      release     Release a job
      run         Start running jobs
      shutdown    Stop running jobs (and cancel any currently running jobs)
      status      Get the run status of a job (run state)
      submit      Submit a new job to the queue


## Example

    $ sbs submit job1.sh
    1

    $ sbs submit job2.sh
    2

    $ sbs status
    job-id   job-name   status   submit                start   end
    1        sbs.1      H        2017-04-12 23:41:47              
    2        sbs.2      H        2017-04-12 23:41:48              

    $ sbs run

## Job options

SBS job scripts support a number of configurable options. Like PBS, SGE, or SLURM, 
these values can be set as arguments at submit time or as part of the script itself.
`sbs submit` will read a job script from a filename or from stdin. Options can be set
within the script if the line starts with `#SBS`.

Here are the available options: 

 |
-------|-------------------------
 -name job-name | The name of the job (easier to track than the number)
 -mem val | Memory units to reserve: 2G, 200M, etc. (not enforced, just used for scheduling)
 -procs N | Number of processor units to use (not enforced, just used for scheduling)
 -mail email@example.com | Email when the job starts and finishes
 -hold | Set a user-hold on the job. Job will not enter the queue until released 
 -stderr fname | Write stderr to this file (default: store in SBS job directory)
 -stdout fname | Write stdout to this file (default: store in SBS job directory)
 -wd | Working directory to use (default: current directory)
 -afterok jobid1:jobid2:...| Dependent jobs - don't start this job until these jobs have finished successfully

### Example script

    #!/bin/bash
    #SBS -name myjob
    #SBS -procs 2
    
    command-goes-here
    

## Run options

Running jobs is a separate process and needs to be manually initiated. 
Each job is independently executed as a new process. If a job ends with a return
code of `0`, it is considered a successful execution.

Here are the available run options:

 |
-----|------
-maxprocs N | The maximum number of processors to schedule (default: all processors)
-maxmem val | The maximum amount of memory to manage (ex: 4G) (default: unlimited, not managed)
-forever    | Keep waiting for new jobs after the job queue has completed (default: exit when all jobs are done)
