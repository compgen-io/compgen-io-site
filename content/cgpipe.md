+++
date = "2015-12-15T00:54:57-05:00"
draft = true
title = "cgpipe"
github = "compgen-io/cgpipe"
project = "cgpipe"
docs = "https://github.com/compgen-io/cgpipe/tree/master/docs"
type = "projects"
icon = "sitemap fa-rotate-90"

+++

cgpipe is a bioinformatics pipeline development language. It is very similar in spirit (and practice) to
the venerable Makefile, but geared towards execution in an HPC environment. Like Makefiles, cgpipe
pipelines establish a series of build targets, their required dependencies, and a recipe (shell script)
used to build the outputs. Unlike Makefiles, cgpipe pipelines are scripts that can incorporate logic 
and flow control in the setup and execution of the build-graph.

cgpipe is distributed as a self-executing fat-JAR file. This means that for installation, all one needs is
a working copy of Java and the `cgpipe` file.

For more information, please see the following documentation: https://github.com/compgen-io/cgpipe/tree/master/docs

