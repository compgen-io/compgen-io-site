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
single file script written in Python that stores job definitions in a dedicated folder on a workstation.
The user can then run those jobs using whatever resource restrictions are necessary.

SBS will run jobs in a first-available, first run basis. Meaning, the first job that fits the available
resources that is also ready to run (has no pending dependencies) will be run. `sbs run` does not run
as a daemon, so it is best executed in the context of a screen or tmux session.

SBS is also supported by [cgpipe](/cgpipe) pipelines as a supported job runner. This lets you run the
same pipelines on your local machine or a HPC cluster.

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



