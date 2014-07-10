#!/bin/bash
###############################################################################
### Benchmarking Annex v1.3 2014-07-10 Valentin.Plugaru@gmail.com           ###
###                                                                         ###
###############################################################################


####################### Pre-benchmark initializations #########################

### The following variable should be set to the full path of the SAN volume 
### mount point on which the benchmarking will be performed
### e.g. MOUNTPOINT=/mnt/nfs/
MOUNTPOINT=

usage(){
	cat << EOF
DD/IOzone based SAN benchmark v1.2
Script usage: $(basename $0) [-h] [-m MOUNTPOINT | MOUNTPOINT] [-t 1|2|3|a]
	'-h'		: Show this help message
	'-m MOUNTPOINT' : Set full path to the SAN mountpoint to benchmark
	'-t 1|2|3|a'	: Perform the tests defined in Section:
			1 - DD read/write tests, 2 - IOZone tests, 
			3 - Kernel compilation, a - all tests (default)
EOF
exit
}

TESTSEL='a'
while getopts "hm:t:" opt; do
	case $opt in
		h) usage ;;
		m) MOUNTPOINT=$OPTARG ;;
		t) TESTSEL=$OPTARG ;;
		*) usage ;;
	esac
done
MOUNTPOINT=${MOUNTPOINT:-"$1"}

if [[ -z "$MOUNTPOINT" ]]; then
    echo "== The SAN volume mountpoint was not specified, cannot execute tests."
    exit 1
fi

if [[ "$MOUNTPOINT" != /* ]]; then
    echo "== The SAN volume mountpoint was not given as a full path."
    exit 1
fi

if [[ ! -d "$MOUNTPOINT" ]]; then
    echo "== The SAN volume mountpoint '$MOUNTPOINT' is not a directory, cannot execute tests."
    exit 1
fi

if [[ "$TESTSEL" != 'a' && "$TESTSEL" != '1' && "$TESTSEL" != '2' && "$TESTSEL" != '3' ]]; then
    echo "== Unknown test selected, rerun script with -h to see available options."
    exit 1
fi

if [[ "$(id -u)" != "0" ]]; then
    echo "== These tests must be ran as root, as some steps involve freeing caches"
    echo "--   by writing to /proc/sys/vm/drop_caches"
    exit 1
fi

if [[ ! -x "$(which dd)" ]]; then
    echo "== The base 'dd' utility was not found, cannot execute tests."
    echo "-- On Debian systems install the coreutils package with: apt-get install coreutils"
    echo "-- On RedHat systems install the coreutils package with: yum install coreutils"
    echo "-- then rerun this script."
    exit 1
fi

if [[ ! -x "$(which iozone)" ]]; then
    echo "== The 'iozone' utility was not found, cannot execute tests."
    echo "-- Compile it with the following instructions (requires system C compiler)"
    echo "-- then rerun this script:"
    echo "wget http://www.iozone.org/src/current/iozone3_427.tgz"
    echo "tar xzvf iozone3_427.tgz"
    echo "cd iozone3_427/src/current"
    echo "make linux-AMD64"
    echo "export PATH=$(pwd)/iozone3_427/src/current:$PATH"
    exit 1
fi

if [[ "$(iozone -v | grep Version | grep -c 3.427)" != "1" ]]; then
    echo "== This script requires 'iozone' v3.427, cannot execute tests."
    echo "-- Compile iozone with the following instructions (requires system C compiler)"
    echo "-- then rerun this script:"
    echo "wget http://www.iozone.org/src/current/iozone3_427.tgz"
    echo "tar xzvf iozone3_427.tgz"
    echo "cd iozone3_427/src/current"
    echo "make linux-AMD64"
    echo "export PATH=$(pwd)/iozone3_427/src/current:$PATH"
    exit 1
fi

TMPFILE=/tmp/BenchAnnexTMP.$$
touch $TMPFILE
if [[ "$?" != "0" ]]; then
    echo "== Cannot create a required temporary file '$TMPFILE'"
    exit 1
fi

### Define the list of tests, and preinitialize results (-1: did not run test, 0 - test passed, 1 - test failed)
testnames=("DD 1GB write" "DD 10GB write" "DD 100GB write" "DD 1TB write" "DD 1GB read" "DD 10GB read" "DD 100GB read" "DD 1TB read" "IOZONE auto" "IOZONE 1GB" "IOZONE 10GB" "IOZONE 100GB" "IOZONE 1TB" "IOZONE throughput 1GB" "IOZONE throughput 10GB" "IOZONE throughput 100GB" "IOZONE throughput 1TB" "KERNEL COMPILATION")
declare -a testresults
declare -a testperformance
for i in {0..17}; do
	testresults[$i]=-1
	testperformance[$i]=""
done

############################# Section 1 - DD tests #############################
if [[ "$TESTSEL" == 'a' || "$TESTSEL" == '1' ]]; then
	DDINPUTSRC=/dev/zero
	DDREADDST=/dev/null
	
	#### Section 1a - DD write tests
	
	dd if=$DDINPUTSRC of=$MOUNTPOINT/1gbfile bs=1M count=1000 conv=fsync 1>$TMPFILE 2>&1
	testresults[0]=$?
	testperformance[0]="$(grep copied $TMPFILE)"
	dd if=$DDINPUTSRC of=$MOUNTPOINT/10gbfile bs=1M count=10000 conv=fsync 1>$TMPFILE 2>&1
	testresults[1]=$?
	testperformance[1]="$(grep copied $TMPFILE)"
	dd if=$DDINPUTSRC of=$MOUNTPOINT/100gbfile bs=1M count=100000 conv=fsync 1>$TMPFILE 2>&1
	testresults[2]=$?
	testperformance[2]="$(grep copied $TMPFILE)"
	dd if=$DDINPUTSRC of=$MOUNTPOINT/1tbfile bs=1M count=1000000 conv=fsync 1>$TMPFILE 2>&1
	testresults[3]=$?
	testperformance[3]="$(grep copied $TMPFILE)"
	
	#### Section 1b - DD read tests
	
	# free pagecache, dentries and inodes before next read test
	sync ; echo 3 > /proc/sys/vm/drop_caches
	dd if=$MOUNTPOINT/1gbfile of=$DDREADDST bs=1M 1>$TMPFILE 2>&1
	testresults[4]=$?
	testperformance[4]="$(grep copied $TMPFILE)"
	
	# free pagecache, dentries and inodes before next read test
	sync ; echo 3 > /proc/sys/vm/drop_caches
	dd if=$MOUNTPOINT/10gbfile of=$DDREADDST bs=1M 1>$TMPFILE 2>&1
	testresults[5]=$?
	testperformance[5]="$(grep copied $TMPFILE)"
	
	# free pagecache, dentries and inodes before next read test
	sync ; echo 3 > /proc/sys/vm/drop_caches
	dd if=$MOUNTPOINT/100gbfile of=$DDREADDST bs=1M 1>$TMPFILE 2>&1
	testresults[6]=$?
	testperformance[6]="$(grep copied $TMPFILE)"
	
	# free pagecache, dentries and inodes before next read test
	sync ; echo 3 > /proc/sys/vm/drop_caches
	dd if=$MOUNTPOINT/1tbfile of=$DDREADDST bs=1M 1>$TMPFILE 2>&1
	testresults[7]=$?
	testperformance[7]="$(grep copied $TMPFILE)"
	
	rm -f $MOUNTPOINT/1gbfile
	rm -f $MOUNTPOINT/10gbfile
	rm -f $MOUNTPOINT/100gbfile
	rm -f $MOUNTPOINT/1tbfile
fi
########################### Section 2 - IOZONE tests ###########################
if [[ "$TESTSEL" == 'a' || "$TESTSEL" == '2' ]]; then

	#### Section 2a - IOZONE auto mode test
	
	sync ; echo 3 > /proc/sys/vm/drop_caches
	cd $MOUNTPOINT
	iozone -a 1>$TMPFILE 2>&1
	testresults[8]=1
	if [[ "$(grep -c 'iozone test complete' $TMPFILE)" == "1" ]]; then
	 	testresults[8]=0
		testperformance[8]="$(sed -n '127p' $TMPFILE)"
	fi
	
	#### Section 2b - IOZONE 1GB file test
	
	sync ; echo 3 > /proc/sys/vm/drop_caches
	cd $MOUNTPOINT
	iozone -s 1g -r 1m 1>$TMPFILE 2>&1
	testresults[9]=1
	if [[ "$(grep -c 'iozone test complete' $TMPFILE)" == "1" ]]; then
	 	testresults[9]=0
		testperformance[9]="$(sed -n '27p' $TMPFILE)"
	fi
	
	#### Section 2c - IOZONE 10GB file test
	
	sync ; echo 3 > /proc/sys/vm/drop_caches
	cd $MOUNTPOINT
	testresults[10]=1
	iozone -s 10g -r 1m 1>$TMPFILE 2>&1
	if [[ "$(grep -c 'iozone test complete' $TMPFILE)" == "1" ]]; then
	 	testresults[10]=0
		testperformance[10]="$(sed -n '27p' $TMPFILE)"
	fi
	
	#### Section 2d - IOZONE 100GB file test
	
	sync ; echo 3 > /proc/sys/vm/drop_caches
	cd $MOUNTPOINT
	testresults[11]=1
	iozone -s 100g -r 1m 1>$TMPFILE 2>&1
	if [[ "$(grep -c 'iozone test complete' $TMPFILE)" == "1" ]]; then
	 	testresults[11]=0
		testperformance[11]="$(sed -n '27p' $TMPFILE)"
	fi
	
	#### Section 2e - IOZONE 1TB file test
	
	sync ; echo 3 > /proc/sys/vm/drop_caches
	cd $MOUNTPOINT
	testresults[12]=1
	iozone -s 1000g -r 1m 1>$TMPFILE 2>&1
	if [[ "$(grep -c 'iozone test complete' $TMPFILE)" == "1" ]]; then
	 	testresults[12]=0
		testperformance[12]="$(sed -n '27p' $TMPFILE)"
	fi
	
	#### Section 2f - IOZONE throughput 1GB file size with 1,2,5,10 threads
	
	testresults[13]=0
	for i in 1 2 5 10; do
	  sync ; echo 3 > /proc/sys/vm/drop_caches
	  cd $MOUNTPOINT
	  FSIZE=1000
	  let FSIZEPERTHREAD=$FSIZE/i
	  iozone -s ${FSIZEPERTHREAD}m -r 1m -t $i 1>$TMPFILE 2>&1
	  let testresults[13]+=$(grep -c 'iozone test complete' $TMPFILE)
	done
	if [[ "${testresults[13]}" == "4" ]]; then
	 	testresults[13]=0
		testperformance[13]="$(sed -n '28p;35p;42p;49p;56p;63p;70p;77p;84p;91p;98p;105p;112p' $TMPFILE | cut -d = -f 2 | paste -sd '')"
	else
		testresults[13]=1
	fi
	
	#### Section 2g - IOZONE throughput 10GB file size with 1,2,5,10 threads
	
	testresults[14]=1
	for i in 1 2 5 10; do
	  sync ; echo 3 > /proc/sys/vm/drop_caches
	  cd $MOUNTPOINT
	  FSIZE=10000
	  let FSIZEPERTHREAD=$FSIZE/i
	  iozone -s ${FSIZEPERTHREAD}m -r 1m -t $i 1>$TMPFILE 2>&1
	  let testresults[14]+=$(grep -c 'iozone test complete' $TMPFILE)
	done
	if [[ "${testresults[14]}" == "4" ]]; then
	 	testresults[14]=0
		testperformance[14]="$(sed -n '28p;35p;42p;49p;56p;63p;70p;77p;84p;91p;98p;105p;112p' $TMPFILE | cut -d = -f 2 | paste -sd '')"
	else
		testresults[14]=1
	fi

	#### Section 2h - IOZONE throughput 100GB file size with 1,2,5,10 threads
	
	testresults[15]=1
	for i in 1 2 5 10; do
	  sync ; echo 3 > /proc/sys/vm/drop_caches
	  cd $MOUNTPOINT
	  FSIZE=100000
	  let FSIZEPERTHREAD=$FSIZE/i
	  iozone -s ${FSIZEPERTHREAD}m -r 1m -t $i 1>$TMPFILE 2>&1
	  let testresults[15]+=$(grep -c 'iozone test complete' $TMPFILE)
	done
	if [[ "${testresults[15]}" == "4" ]]; then
	 	testresults[15]=0
		testperformance[15]="$(sed -n '28p;35p;42p;49p;56p;63p;70p;77p;84p;91p;98p;105p;112p' $TMPFILE | cut -d = -f 2 | paste -sd '')"
	else
		testresults[15]=1
	fi

	#### Section 2i - IOZONE throughput 1TB file size with 1,2,5,10 threads
	
	testresults[16]=1
	for i in 1 2 5 10; do
	  sync ; echo 3 > /proc/sys/vm/drop_caches
	  cd $MOUNTPOINT
	  FSIZE=1000
	  let FSIZEPERTHREAD=$FSIZE/i
	  iozone -s ${FSIZEPERTHREAD}g -r 1m -t $i 1>$TMPFILE 2>&1
	  let testresults[16]+=$(grep -c 'iozone test complete' $TMPFILE)
	done
	if [[ "${testresults[16]}" == "4" ]]; then
	 	testresults[16]=0
		testperformance[16]="$(sed -n '28p;35p;42p;49p;56p;63p;70p;77p;84p;91p;98p;105p;112p' $TMPFILE | cut -d = -f 2 | paste -sd '')"
	else
		testresults[16]=1
	fi
fi

################### Section 3 - Kernel compilation test ########################
if [[ "$TESTSEL" == 'a' || "$TESTSEL" == '3' ]]; then
	cd $MOUNTPOINT
	rm -rf linux-3.13.6
	wget -q -c http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.13.6.tar.gz
	if [[ "$?" != 0 ]]; then
		testresults[17]=-1
	else
		sync ; echo 3 > /proc/sys/vm/drop_caches
		tar xzf linux-3.13.6.tar.gz
		cd linux-3.13.6
		make mrproper > /dev/null 2>&1
		make alldefconfig > /dev/null 2>&1
		COMPILEOK=$(make 2>&1 | grep -c "Kernel: arch/x86/boot/bzImage is ready")
		if [[ -f "$MOUNTPOINT/linux-3.13.6/arch/x86/boot/bzImage" && "$COMPILEOK" == "1" ]]; then
			testresults[17]=0
		else
			testresults[17]=1
		fi
	fi
fi


################################## Results #####################################
echo "== TEST RESULTS:"
for i in {0..17}; do
	RESULT="FAILED"
	[[ ${testresults[$i]} == '-1' ]] && RESULT="NOT PERFORMED"
	[[ ${testresults[$i]} == '0' ]] && RESULT="PASSED"
	echo "-- Test $i: ${testnames[$i]} : $RESULT : ${testperformance[$i]}"
done

rm -f $TMPFILE
