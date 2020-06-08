---
title: cgpipe
permalink: /cgpipe
layout: default
nav_order: 2
parent: Projects
#grand_parent: Projects
#parent: Pipelines
---

# cgpipe

CGpipe is a bioinformatics pipeline development language. It is very similar in spirit (and practice) to
the venerable Makefile, but geared towards execution in an HPC environment. Like Makefiles, cgpipe
pipelines establish a series of build targets, their required dependencies, and a recipe (shell script)
used to build the outputs. Unlike Makefiles, cgpipe pipelines are scripts that can incorporate logic 
and flow control in the setup and execution of the build-graph.

CGpipe is distributed as a self-executing fat-JAR file. This means that for installation, all one needs is
a working copy of Java and the `cgpipe` file.

For more information, please see the following documentation: https://github.com/compgen-io/cgpipe/tree/master/docs

