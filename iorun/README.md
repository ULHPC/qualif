-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-

`README.md`

Copyright (c) 2014 Hyacinthe Cartiaux <Hyacinthe.Cartiaux@uni.lu>

        Time-stamp: <Dim 2014-01-28 18:14 hcartiaux>

-------------------


# UL HPC Admin Tutorial: IORUN on the clusters

The objective of this tutorial is to launch IORUN on the UL HPC Platform shared
filesystems.

You will find in the [UL HPC tutorial](https://github.com/ULHPC/tutorials)
repository in the `admin/iorun` directory, a Makefile and a launcher script.

The launcher script will launch iorun with OpenMPI

* running `make fetch` will automatically download IORUN
* running `make build` will build it src/ior and link the binary in /runs
* running `make run` will submit a job, iorun will run on all the reserved nodes
* running `make clean` will remove the local install of iorun
* running `make plot` will generate the gnuplot data file

* a launcher script is proposed in `runs/launch_iorun`. You can either
  edit the OAR directives in order to specify the wanted resources, or overload
  them on the command line

    # Run of IORUN on the 72 nodes of the second IB pool for 2 hours
		(access-gaia)$> oarsub -l nodes=72,walltime=2:0:0 -p ibpool=2 -S "./runs/launch_iorun"

The `runs/data/` directory host all the results (ioruns output).

