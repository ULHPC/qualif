-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-

`README.md`

Copyright (c) 2014 Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>

        Time-stamp: <Dim 2014-01-28 18:14 hcartiaux>

-------------------


# UL HPC Admin Tutorial: MPrime on the clusters

The objective of this tutorial is to launch the reference torture test for the
UL HPC Platform: mprime.

You will find in the [UL HPC tutorial](https://github.com/ULHPC/tutorials)
repository in the `admin/mprime` directory, a Makefile and a launcher script.

The launcher script will launch mprime in torture mode, using ~90% of the 
memory, and all available cores.

* running `make fetch` will automatically download mprime
* running `make build` will untar it under /runs/bin
* running `make run` will submit a job, mprime will run on all the reserved nodes
* running `make clean` will remove the local install of mprime

* a launcher script is proposed in `runs/launch_mprime_torture`. You can either
  edit the OAR directives in order to specify the wanted resources, or overload
  them on the command line

    # Run of Mprime on the 72 nodes of the second IB pool for 2 hours
		(access-gaia)$> oarsub -l nodes=72,walltime=2:0:0 -p ibpool=2 -S "./runs/launch_mprime_torture"

The `runs/data/` directory host all the results (mprime output and configuration).

At the end of the job:

* check the state of your job (terminated, error, etc)
* check if some resources are suspected
* grep the output of the mprime processes for hardware related errors

    (access-gaia)$> grep -r -i hardware runs/data/

