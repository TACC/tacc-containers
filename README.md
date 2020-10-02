# TACC Containers

A curated set of starter containers for building containers to eventually run on TACC systems.

| Image                                                             | Frontera | Stampede2 | Maverick2 | Wrangler | Hikari | Local Dev |
|-|:-:|:-:|:-:|:-:|:-:|:-:|
| [tacc/tacc-centos7](#minimal-base-images)                                     | X | X | X | X | X | X |
| [tacc/tacc-centos7-mvapich2.3-ib](#infiniband-base-mvapich2-images)           | X |   | X | X | X | X |
| [tacc/tacc-centos7-mvapich2.3-psm2](#omni-path-base-mvapich2-images)          |   | X |   |   |   |   |
| [tacc/tacc-centos7-impi19.0.5-ib](#infiniband-base-intel-mpi-images)          | X |   |   |   |   | X<sup>*</sup> |
| [tacc/tacc-centos7-impi18.0.2-psm2](#omni-path-base-intel-mpi-images)         |   | X |   |   |   | X |
| [tacc/tacc-centos7-impi19.0.7-common](#common-base-intel-mpi-images)          | X | X |   |   |   | X<sup>*</sup> |
| [tacc/tacc-centos7-intel19.1.1-impi19.0.7-common](#common-base-intel-images)  | X | X |   |   |   | X<sup>*</sup> |
| [tacc/tacc-ubuntu18](#minimal-base-images)                                    | X | X | X | X | X | X |
| [tacc/tacc-ubuntu18-mvapich2.3-ib](#infiniband-base-mvapich2-images)          | X |   | X | X | X | X |
| [tacc/tacc-ubuntu18-mvapich2.3-psm2](#omni-path-base-mvapich2-images)         |   | X |   |   |   |   |
| [tacc/tacc-ubuntu18-impi19.0.5-ib](#infiniband-base-intel-mpi-images)         | X |   |   |   |   | X<sup>*</sup> |
| [tacc/tacc-ubuntu18-impi18.0.2-psm2](#omni-path-base-intel-mpi-images)        |   | X |   |   |   | X |
| [tacc/tacc-ubuntu18-impi19.0.7-common](#common-base-intel-mpi-images)         | X | X |   |   |   | X<sup>*</sup> |
| [tacc/tacc-ubuntu18-intel19.1.1-impi19.0.7-common](#common-base-intel-images) | X | X |   |   |   | X<sup>*</sup> |

<sup>*</sup>May need `export I_MPI_FABRICS=shm` to run locally.

## Contents

* [Container Descriptions](#container-descriptions)
* [Running on TACC](#running-on-tacc)
  * [Stampede 2](#stampede-2)
  * [Hikari](#hikari)
* [Building from our Containers](#building-from-our-containers)
* [Performance](#performance)
* [Troubleshooting](#troubleshooting)
* [Known Issues](#known-issues)
* [Frequently Asked Questions](#frequently-asked-questions)

## Container Descriptions

### Minimal base images

* tacc/tacc-centos7
  * [Dockerfile](containers/tacc-centos7) - [Container](https://hub.docker.com/r/tacc/tacc-centos7)
* tacc/tacc-ubuntu18
  * [Dockerfile](containers/tacc-ubuntu18) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18)

These are the starting point for our downstream images, and the operating systems we support.
They are meant to be extremely light and only contain the following:

* TACC mount points (for legacy containers)
* [docker-clean](containers/extras/docker-clean) script for cleaning up temporary files between layers
* System GCC toolchains (build-essential)
* Generic `$CFLAGS/$CXXFLAGS` that will work on both _your_ build system and fairly well on ours
  * `-O2 -pipe -march=x86-64 -ftree-vectorize -mtune=core-avx2`
* Version recorded in /etc/tacc-[OS]-release for troubleshooting

> The architecture flags in our `$CFLAGS` are not more system specific due to the age of the system compilers. As we support newer operating systems, those flags will better match the contemporary hardware at TACC

### InfiniBand base MVAPICH2 images

* tacc/tacc-centos7-mvapich2.3-ib
  * [Dockerfile](containers/tacc-centos7-mvapich2.3-ib) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-mvapich2.3-ib)
* tacc/tacc-ubuntu18-mvapich2.3-ib
  * [Dockerfile](containers/tacc-ubuntu18-mvapich2.3-ib) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-mvapich2.3-ib)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on our InfiniBand systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-mvapich2.3-ib for troubleshooting
* InfiniBand system development libraries
* [MVAPICH2 v2.3](http://mvapich.cse.ohio-state.edu/downloads/)
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`

### Omni-Path base MVAPICH2 images

* tacc/tacc-centos7-mvapich2.3-psm2
  * [Dockerfile](containers/tacc-centos7-mvapich2.3-psm2) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-mvapich2.3-psm2)
* tacc/tacc-ubuntu18-mvapich2.3-psm2
  * [Dockerfile](containers/tacc-ubuntu18-mvapich2.3-psm2) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-mvapich2.3-psm2)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on our [Intel Omni-Path](https://www.intel.com/content/www/us/en/high-performance-computing-fabrics/omni-path-driving-exascale-computing.html) (psm2) systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-mvapich2.3-psm2 for troubleshooting
* InfiniBand system development libraries
* [PSM2 development library](https://github.com/intel/opa-psm2)
* [MVAPICH2 v2.3](http://mvapich.cse.ohio-state.edu/downloads/)
  * configured with `--with-device=ch3:psm`
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`

Please note that while you can build software in these images, they will **not** run on systems without Omni-Path devices, which probably includes your development system.

### InfiniBand base Intel MPI images

* tacc/tacc-centos7-impi19.0.5-ib
  * [Dockerfile](containers/tacc-centos7-impi19.0.5-ib) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-impi19.0.5-ib)
* tacc/tacc-ubuntu18-impi19.0.5-ib
  * [Dockerfile](containers/tacc-ubuntu18-impi19.0.5-ib) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-impi19.0.5-ib)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on our InfiniBand systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-impi19.0.5-ib for troubleshooting
* InfiniBand system development libraries
* [Mellanox OpenFabrics Enterprise Distribution](https://www.mellanox.com/support/mlnx-ofed-public-repository)
* Intel MPI 19.0.5 ([yum repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-yum-repo.html), [apt repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-apt-repo.html))
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`
* docker-entrypoint.sh - To initialize necessary environment variables for Intel MPI.

Please note that you will need to use `singularity run` to get the `docker-entrypoint.sh` invoked properly under Singularity. 

### Omni-Path base Intel MPI images

* tacc/tacc-centos7-impi18.0.2-psm2
  * [Dockerfile](containers/tacc-centos7-impi18.0.2-psm2) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-impi18.0.2-psm2)
* tacc/tacc-ubuntu18-impi18.0.2-psm2
  * [Dockerfile](containers/tacc-ubuntu18-impi18.0.2-psm2) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-impi18.0.2-psm2)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on our [Intel Omni-Path](https://www.intel.com/content/www/us/en/high-performance-computing-fabrics/omni-path-driving-exascale-computing.html) (psm2) systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-impi18.0.2-psm2 for troubleshooting
* InfiniBand system development libraries
* [PSM2 development library](https://github.com/intel/opa-psm2)
* [OpenFabrics Interfaces](https://github.com/ofiwg/libfabric)
* Intel MPI 18.0.2([yum repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-yum-repo.html), [apt repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-apt-repo.html))
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`
* docker-entrypoint.sh - To initialize necessary environment variables for Intel MPI.
* [A patch for strtok_r](containers/extras/strtok_fix.c) is included in the Ubuntu image to fix a bug due to incompatible GNU C Library.

Please note that while you can build software in these images, they will **not** run on systems without Omni-Path devices, which probably includes your development system.

Please note that you will need to use `singularity run` to get the `docker-entrypoint.sh` invoked properly under Singularity. 

### Common base Intel MPI images

* tacc/tacc-centos7-impi19.0.7-common
  * [Dockerfile](containers/tacc-centos7-impi19.0.7-common) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-impi19.0.7-common)
* tacc/tacc-ubuntu18-impi19.0.7-common
  * [Dockerfile](containers/tacc-ubuntu18-impi19.0.7-common) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-impi19.0.7-common)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on both our InfiniBand systems and Omni-Path systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-impi19.0.7-common for troubleshooting
* InfiniBand system development libraries
* [PSM2 development library](https://github.com/intel/opa-psm2)
* [Mellanox OpenFabrics Enterprise Distribution](https://www.mellanox.com/support/mlnx-ofed-public-repository)
* Intel MPI 19.0.7 ([yum repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-yum-repo.html), [apt repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-apt-repo.html))
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`
* docker-entrypoint.sh - To initialize necessary environment variables for Intel MPI.

Please note that you will need to use `singularity run` to get the `docker-entrypoint.sh` invoked properly under Singularity. 

### Common base Intel images

* tacc/tacc-centos7-intel19.1.1-impi19.0.7-common
  * [Dockerfile](containers/tacc-centos7-intel19.1.1-impi19.0.7-common) - [Container](https://hub.docker.com/r/tacc/tacc-centos7-intel19.1.1-impi19.0.7-common)
* tacc/tacc-ubuntu18-intel19.1.1-impi19.0.7-common
  * [Dockerfile](containers/tacc-ubuntu18-intel19.1.1-impi19.0.7-common) - [Container](https://hub.docker.com/r/tacc/tacc-ubuntu18-intel19.1.1-impi19.0.7-common)

Each image starts from their respective minimal base, and inherits those base features.
The goal of these images is to provide a base MPI development environment that will work on both our InfiniBand systems and Omni-Path systems, and will specifically contain the following:

* Version recorded in /etc/tacc-[OS]-intel19.1.1-impi19.0.7-common for troubleshooting
* InfiniBand system development libraries
* [PSM2 development library](https://github.com/intel/opa-psm2)
* [Mellanox OpenFabrics Enterprise Distribution](https://www.mellanox.com/support/mlnx-ofed-public-repository)
* [Intel Parallel Studio XE 2020 (Update1) Composer Edition](https://software.intel.com/content/www/us/en/develop/tools/parallel-studio-xe.html)
  * The license file (`/opt/intel/licenses/intel.lic`) only works within TACC's subnetwork
  * Users can replace with their own license to use Intel compiler locally 
* Intel MPI 19.0.7 ([yum repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-yum-repo.html), [apt repo](https://software.intel.com/content/www/us/en/develop/articles/installing-intel-free-libs-and-python-apt-repo.html))
* [`hellow`](containers/extras/hello.c) - A simple "Hello World" test program on the system path
* [OSU micro benchmarks](http://mvapich.cse.ohio-state.edu/benchmarks/)
  * Installed in /opt/osu-micro-benchmarks
  * Not on system `$PATH`
* docker-entrypoint.sh - To initialize necessary environment variables for Intel MPI.

Please note that you will need to use `singularity run` to get the `docker-entrypoint.sh` invoked properly under Singularity. 

## Running on TACC
Mult-node jobs need to be invoked with the system `ibrun`.

> Single-node, multi-core applications _can_ be invoked with the container's `mpirun`, but we do not recommend it unless absolutely necessary.

**NOTE:** large MPI applications must be run on our high-performance filesystems (not $WORK) in the following manner:

1. Pull container once, using a single process <br>
`idev -N 1; singularity pull docker://tacc/tacc-centos7-mvapich2.3-psm2:latest`
2. Move the container to a high-performance filesystem like `$SCRATCH` or maybe `$HOME` <br>
`mv tacc-centos7-mvapich2.3-psm2_latest.sif $SCRATCH/`
   * You could also `sbcast` the image to `/tmp` inside a job
3. Launch MPI application <br>
`cd $SCRATCH; idev -N 2; ibrun singularity exec tacc-centos7-mvapich2.3-psm2_latest.sif hellow`

### Stampede 2

```bash
# Start 2-node compute session
$ idev -N 2 -n 2

# Load the tacc-singularity module
$ module load tacc-singularity

# Pull your desired image
$ singularity pull docker://tacc/tacc-centos7-mvapich2.3-psm2:latest

# Run Hello World
$ ibrun singularity exec tacc-centos7-mvapich2.3-psm2_latest.sif hellow
TACC:  Starting up job 4784577
TACC:  Starting parallel tasks...
Hello world!  I am process-1 on host c460-032.stampede2.tacc.utexas.edu
Hello world!  I am process-0 on host c460-031.stampede2.tacc.utexas.edu
TACC:  Shutdown complete. Exiting.
```

### Hikari

```bash
# Start 2-node compute session
$ idev -N 2 -n 2

# Load the tacc-singularity module
$ module load tacc-singularity

# Pull your desired image
$ singularity pull docker://tacc/tacc-centos7-mvapich2.3-ib:latest

# Run Hello World
$ ibrun singularity exec tacc-centos7-mvapich2.3-ib_latest.sif hellow

TACC: Starting up job 48655
TACC: Starting parallel tasks...
Warning: Process to core binding is enabled and OMP_NUM_THREADS is set to non-zero (1) value
If your program has OpenMP sections, this can cause over-subscription of cores and consequently poor performance
To avoid this, please re-run your application after setting MV2_ENABLE_AFFINITY=0
Use MV2_USE_THREAD_WARNING=0 to suppress this message
Hello world!  I am process-1 on host c262-170.hikari.tacc.utexas.edu
Hello world!  I am process-0 on host c262-169.hikari.tacc.utexas.edu
 
TACC: Shutdown complete. Exiting.
```

## Building from our Containers

In the [examples](examples) directory, we have a file called `run_julia.py`, which computes the [Julia set](https://en.wikipedia.org/wiki/Julia_set) and was adapted from one of [mpi4py's examples](https://mpi4py.readthedocs.io/en/stable/mpi4py.futures.html#examples).

To build a container to run `run_julia.py` on an InfiniBand system at TACC, a new Docker container needs to be built with the following requirements:

* Starts **FROM** `tacc-[OS]-mvapich2.3-ib`
* Installs necessary python dependencies
  * pip/setuptools
  * mpi4py
* Adds the `run_julia.py` program and updates the permissions

```
ARG VER=latest
FROM tacc/tacc-ubuntu18-mvapich2.3-ib:${VER}

# Install dependencies
RUN apt-get update \
        && apt-get install -yq --no-install-recommends python3-dev python3-pip \
                python3-setuptools python3-wheel python3-numpy \
        && docker-clean

RUN pip3 install mpi4py \
        && docker-clean

# Add/compile application
ADD run_julia.py /usr/local/bin/run_julia.py

# Make sure permissions are correct for singularity
RUN chmod a+rx /usr/local/bin/run_julia.py
```

You can either manually recreate this, or take advantage of the provided `Makefile`.

```
$ make ORG=[your dockerhub username] julia
```

After the image is done being pushed to dockerhub, you can pull it down to the InfiniBand system of your choice.

```
$ idev -N 2 -n 4
$ module load tacc-singularity
$ singularity pull docker://gzynda/julia:latest
$ ibrun -np 4 singularity exec julia_latest.sif run_julia.py
```

<details><summary>Results</summary>
	
```
$ ibrun -np 4 singularity exec julia_latest.sif run_julia.py
TACC: Starting up job 48657
TACC: Starting parallel tasks...
Running COMM
Running COMM
Running COMM
Loaded Executor
c262-169.hikari.tacc.utexas.edu - Julia Set 1600x1200 in 1.92 seconds.
Running COMM 
TACC: Shutdown complete. Exiting.

$ ibrun -np 2 singularity exec julia_latest.sif run_julia.py
TACC: Starting up job 48657
TACC: Starting parallel tasks...
Running COMM
Loaded Executor
c262-169.hikari.tacc.utexas.edu - Julia Set 1600x1200 in 5.72 seconds.
Running COMM
TACC: Shutdown complete. Exiting.

$ ibrun -np 1 singularity exec julia_latest.sif run_julia.py
TACC: Starting up job 48657
TACC: Starting parallel tasks...
Running COMM
Loaded Executor
c262-169.hikari.tacc.utexas.edu - Julia Set 1600x1200 in 5.59 seconds.
TACC: Shutdown complete. Exiting.
```

</details>

> The [MPIPoolExecutor](https://mpi4py.readthedocs.io/en/stable/mpi4py.futures.html#mpipoolexecutor) version of `run_julia.py` does not work

## Performance

There should be no serial performance loss when running from a single node container - assuming the same compilers, libraries, and flags were used.
We did want to measure communication latency to confirm that the correct fabric devices were used and no significant communication performance was lost when programs were compiled against container MPI libraries.

Performance was measured using [osu_latency](http://mvapich.cse.ohio-state.edu/benchmarks/) which exists in all of our tacc-[OS]-mvapich2.3-[fabric] containers at:

 * `/opt/osu-micro-benchmarks/pt2pt/osu_latency`

<details><summary>Stampede 2 Run commands</summary>

```
# Prepare compute environment
$ idev -N 2 -n 2
$ module load tacc-singularity

# Native
$ ibrun osu_latency

# centos7
$ ibrun singularity exec tacc-centos7-mvapich2.3-psm2_latest.sif /opt/osu-micro-benchmarks/pt2pt/osu_latency

# ubuntu18
$ ibrun singularity exec tacc-ubuntu18-mvapich2.3-psm2_latest.sif /opt/osu-micro-benchmarks/pt2pt/osu_latency
```

</details>
<details><summary>Hikari Run commands</summary>

```
# Prepare compute environment
$ idev -N 2 -n 2
$ module load tacc-singularity

# Native
$ ibrun osu_latency

# centos7
$ ibrun singularity exec tacc-centos7-mvapich2.3-ib_latest.sif /opt/osu-micro-benchmarks/pt2pt/osu_latency

# ubuntu18
$ ibrun singularity exec tacc-ubuntu18-mvapich2.3-ib_latest.sif /opt/osu-micro-benchmarks/pt2pt/osu_latency
```

</details>

### Frontera Performance

| Size    | inter-native | inter-centos7 | inter-ubuntu18 | intra-native | intra-centos7 | intra-ubuntu18 | 
|---------|--------------|---------------|----------------|--------------|---------------|----------------| 
| 0       | 1.15         | 1.16          | 1.16           | 0.42         | 0.22          | 0.21           | 
| 1       | 1.14         | 1.2           | 1.19           | 0.4          | 0.22          | 0.21           | 
| 2       | 1.14         | 1.19          | 1.19           | 0.4          | 0.22          | 0.22           | 
| 4       | 1.14         | 1.19          | 1.19           | 0.4          | 0.22          | 0.22           | 
| 8       | 1.13         | 1.19          | 1.19           | 0.4          | 0.22          | 0.21           | 
| 16      | 1.13         | 1.23          | 1.22           | 0.41         | 0.23          | 0.22           | 
| 32      | 1.15         | 1.23          | 1.22           | 0.42         | 0.25          | 0.22           | 
| 64      | 1.2          | 1.23          | 1.22           | 0.42         | 0.27          | 0.24           | 
| 128     | 1.22         | 1.28          | 1.27           | 0.51         | 0.3           | 0.27           | 
| 256     | 1.7          | 1.69          | 1.69           | 0.59         | 0.32          | 0.31           | 
| 512     | 1.53         | 1.77          | 1.78           | 0.79         | 0.4           | 0.4            | 
| 1024    | 1.7          | 1.93          | 1.93           | 0.88         | 0.51          | 0.49           | 
| 2048    | 2.25         | 2.3           | 2.31           | 1.03         | 0.66          | 0.63           | 
| 4096    | 3            | 3.4           | 3.36           | 1.48         | 1             | 0.95           | 
| 8192    | 3.98         | 4.56          | 4.64           | 1.94         | 1.7           | 1.87           | 
| 16384   | 5.49         | 7.36          | 7.39           | 3.27         | 3.09          | 3.27           | 
| 32768   | 9.76         | 9.53          | 9.54           | 4.69         | 4.86          | 5.32           | 
| 65536   | 12.74        | 12.43         | 12.44          | 7.81         | 4.06          | 4.64           | 
| 131072  | 18.44        | 21.63         | 21.55          | 13.78        | 6.79          | 8.12           | 
| 262144  | 33.23        | 32.55         | 32.47          | 25.86        | 12.43         | 15.46          | 
| 524288  | 56.55        | 54.73         | 54.28          | 60.53        | 26.54         | 32.34          | 
| 1048576 | 100.07       | 96.91         | 97.03          | 117.08       | 81.49         | 80.25          | 
| 2097152 | 184.95       | 182.18        | 185.47         | 226.64       | 207.01        | 214.86         | 
| 4194304 | 356.57       | 352.09        | 352.55         | 447.13       | 431.6         | 437.29         | 

[Full run logs](run_metrics/frontera)

### Legacy Performance

| Size    | S2 Native | centos7-psm2 | ubuntu18-psm2 | Hikari Native | centos7-ib | ubuntu18-ib |
|---------|----------:|-------------:|--------------:|--------------:|-----------:|------------:|
| 0       | 4.09      | 2.63         | 2.95          | 1.27          | 0.23       | 0.19        |
| 1       | 4.11      | 2.72         | 3.12          | 1.22          | 0.23       | 0.2         |
| 2       | 4.19      | 2.72         | 3.04          | 1.19          | 0.22       | 0.2         |
| 4       | 4.13      | 2.63         | 3.05          | 1.16          | 0.22       | 0.21        |
| 8       | 4.07      | 2.76         | 3.01          | 1.15          | 0.22       | 0.21        |
| 16      | 5.28      | 3.43         | 3.38          | 1.13          | 0.22       | 0.2         |
| 32      | 5.28      | 3.42         | 3.46          | 1.51          | 0.24       | 0.21        |
| 64      | 5.05      | 3.49         | 3.33          | 1.5           | 0.26       | 0.22        |
| 128     | 5.86      | 3.38         | 3.39          | 1.55          | 0.29       | 0.26        |
| 256     | 6.04      | 3.61         | 3.52          | 1.59          | 0.33       | 0.29        |
| 512     | 5.99      | 3.57         | 3.57          | 1.68          | 0.37       | 0.33        |
| 1024    | 6.2       | 3.86         | 3.7           | 1.83          | 0.44       | 0.4         |
| 2048    | 6.56      | 4.28         | 4.2           | 2.14          | 0.62       | 0.55        |
| 4096    | 7.22      | 5.1          | 5.09          | 2.65          | 0.96       | 0.84        |
| 8192    | 9.22      | 8.11         | 7.32          | 3.74          | 1.68       | 1.56        |
| 16384   | 11.51     | 10.79        | 10.47         | 4.97          | 3.19       | 2.98        |
| 32768   | 14.95     | 14.67        | 14.56         | 6.88          | 3          | 3.14        |
| 65536   | 21.34     | 23.33        | 22.11         | 10.99         | 4.86       | 5.05        |
| 131072  | 47.5      | 53.72        | 56.2          | 19.21         | 9.34       | 9.61        |
| 262144  | 69.47     | 71.54        | 85.29         | 73.09         | 21.58      | 21.69       |
| 524288  | 93.18     | 96.16        | 124.98        | 115.63        | 44.44      | 44.93       |
| 1048576 | 141.3     | 148.33       | 170.54        | 198.8         | 87.28      | 93.64       |
| 2097152 | 242.13    | 250.47       | 267.76        | 373.42        | 177.26     | 186.89      |
| 4194304 | 470.69    | 460.34       | 465.2         | 711.79        | 371.62     | 381.16      |

## Troubleshooting

TODO

## Known Issues

* [mpi4py.futures](https://mpi4py.readthedocs.io/en/stable/mpi4py.futures.html) fails on `*psm2` - please submit a pull request if you find a solution
* [MPIPoolExecutor](https://mpi4py.readthedocs.io/en/stable/mpi4py.futures.html#mpipoolexecutor) failes on `*ib` - please submit a pull request if you find a solution
  * Still true with mvapich 2.3.1 in release 0.0.3
* `*psm2` containers cannot run locally
* Running with `MV2_ENABLE_AFFINITY=0` in your environment is sometimes required for some code if it fails and you see the following warning <blockquote>
```
Warning: Process to core binding is enabled and OMP_NUM_THREADS is set to non-zero (1) value
If your program has OpenMP sections, this can cause over-subscription of cores and consequently poor performance
To avoid this, please re-run your application after setting MV2_ENABLE_AFFINITY=0
Use MV2_USE_THREAD_WARNING=0 to suppress this message
```
</blockquote>

## Frequently asked questions

<details><summary>What happens if I run a `*ib` container on Stampede2?</summary>

Multi-node
```
gzynda@Sc460-031[osu-bench]$ ibrun singularity exec tacc-centos7-mvapich2.3-ib_0.0.2.sif hellow
TACC:  Starting up job 4784577
TACC:  Starting parallel tasks...
[c460-032.stampede2.tacc.utexas.edu:mpi_rank_1][error_sighandler] Caught error: Segmentation fault (signal 11)
[c460-031.stampede2.tacc.utexas.edu:mpi_rank_0][error_sighandler] Caught error: Segmentation fault (signal 11)
TACC:  MPI job exited with code: 139
TACC:  Shutdown complete. Exiting.
```

Single-node
```
gzynda@Sc460-031[osu-bench]$ singularity exec tacc-centos7-mvapich2.3-ib_0.0.2.sif bash -c 'mpirun -n 2 -launcher fork hellow'
Hello world!  I am process-0 on host c460-031.stampede2.tacc.utexas.edu
Hello world!  I am process-1 on host c460-031.stampede2.tacc.utexas.edu
```

</details>
<details><summary>What happens if I run a `*psm2` container on Hikari?</summary>


Multi-node
```
c262-169.hikari(44)$ ibrun singularity exec tacc-centos7-mvapich2.3-psm2_0.0.2.sif hellow
TACC: Starting up job 48655
TACC: Starting parallel tasks...
psm2_init failed with error: PSM Unresolved internal error
psm2_init failed with error: PSM Unresolved internal error
[cli_1]: aborting job:
Fatal error in MPI_Init: Internal MPI error!, error stack:
MPIR_Init_thread(490): 
MPID_Init(395).......: channel initialization failed
(unknown)(): Internal MPI error!
[cli_0]: aborting job:
Fatal error in MPI_Init: Internal MPI error!, error stack:
MPIR_Init_thread(490): 
MPID_Init(395).......: channel initialization failed
(unknown)(): Internal MPI error!
TACC: MPI job exited with code: 16
 
TACC: Shutdown complete. Exiting.
```

Single-node
```
c262-169.hikari(51)$ singularity exec tacc-centos7-mvapich2.3-psm2_0.0.2.sif bash -c 'MV2_USE_CMA=0; mpirun -n 2 -launcher fork hellow'
psm2_init failed with error: PSM Unresolved internal error
psm2_init failed with error: PSM Unresolved internal error
[cli_0]: aborting job:
Fatal error in MPI_Init: Internal MPI error!, error stack:
MPIR_Init_thread(490): 
MPID_Init(395).......: channel initialization failed
(unknown)(): Internal MPI error!
[cli_1]: aborting job:
Fatal error in MPI_Init: Internal MPI error!, error stack:
MPIR_Init_thread(490): 
MPID_Init(395).......: channel initialization failed
(unknown)(): Internal MPI error!
```

</details>
