-*- mode: markdown; mode: auto-fill; fill-column: 80 -*-
`README.md`

Copyright (c) 2014 [Sebastien Varrette](mailto:<Sebastien.Varrette@uni.lu>) [www](http://varrette.gforge.uni.lu)

        Time-stamp: <Ven 2014-03-07 16:13 svarrette>

-------------------

# DD/IOzone/Kernel compilation based SAN benchmark


As part of the UL HPC Benchmarking campaign, the `BenchmarkingAnnex.sh` Bourne-Again
shell (bash) script has been developed that can be used to perform several
types of I/O tests. 

The tests are divided in three sections: 

1. DD read/write tests
2. IOZone tests
3. Kernel compilation

Most credits for this section goes to [Valentin Plugaru](https://github.com/vplugaru)

## Synopsis

	$> ./BenchmarkingAnnex.sh -h                                                                                                                                                                                                                                                  	DD/IOzone based SAN benchmark v1.2
	Script usage: BenchmarkingAnnex.sh [-h] [-m MOUNTPOINT | MOUNTPOINT] [-t 1|2|3|a]
	   '-h'		: Show this help message
	   '-m MOUNTPOINT' : Set full path to the SAN mountpoint to benchmark
	   '-t 1|2|3|a'	: Perform the tests defined in Section:
		              	1 - DD read/write tests, 2 - IOZone tests,
			            3 - Kernel compilation, a - all tests (default)

The benchmark script must be ran under the `root` user, with a command line parameter specifying the full path to the mountpoint of the SAN / device being benchmarked.
An optional parameter can also be specified in order to perform the tests in a single section, with the default being to perform all tests in Sections 1-3 (see details below).

The parameters the benchmark script allows on the command line can be shown
by running './BenchmarkingAnnex.sh -h'.

When the script completes the benchmarks it outputs the results of the
tests, showing for each test its name, a "PASSED/FAILED/NOT PERFORMED"
status and optionally performance values gathered during the execution of
the corresponding test.


## Section 1: DD read/write tests

In a first part, we simply test sequential write and read I/O tests based on the [`dd`](http://en.wikipedia.org/wiki/Dd_(Unix)) command: 

* __[1.a]__: `dd` write tests for files of size 1, 10, 100 and 1000 GB
* __[1.b]__: `dd` read  tests for files of size 1, 10, 100 and 1000 GB


## Section 2: IOZone read/write/reread/rewrite, random read/write test

In this part, we perform a backward read, and other tests based on the  [`iozone`](http://www.iozone.org/) utility:

* __[2.a]__ default `iozone` auto test - several file sizes (up to 512MB) with varying record length
* __[2.b-2.e]__ tests for 1, 10, 100 and respectively 1000GB files with 1MB record
* __[2.f-2.i]__ throughput tests for 1, 10, 100 and respectively 1000GB files with 1MB record and varying number of threads on each test (1, 2, 5, 10)

## Section 3: Linux Kernel compilation

Finally, we perform a compilation of a recent linux kernel, since many small files are generated in this context for a sufficiently long time period. 





