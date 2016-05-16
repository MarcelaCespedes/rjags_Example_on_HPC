# rjags_Example_on_HPC

All required files to run a small Bayesian model with ``rjags`` R package on Queensland Univeristy of Technology (QUT) High Powered Computer (HPC) facility.

**Note:** These instructions assume user is familiar with running R script files in HPC. Instructions on how to submit an R code to the HPC can be found [here.](https://gist.github.com/brfitzpatrick/132cedf8206ef45abe41f3552819a909)

The aim of this repository is to supply R code to run small and simple Bayesian model on ``rjags`` R package on QUT's HPC. Code includes commands to save basic model summary onto separate text files, and three model diagnostics plots (the trace, auto-correlation and density plots) which will be saved as separate pdf files once the code is run.

The *expected_output* folder contains the out expected from a successful run of the model on the HPC. The *rjags-errors* folder contains a few of the common errors the user may encounter while running their first ``rjags`` model.
