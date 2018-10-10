.PHONY: build test docker help stage release clean latest
ifndef VERBOSE
.SILENT: build test docker help stage release clean latest
endif

ALL := $(BASE) $(MPI)
BUILD := scripts/build_docker.sh
EDR := maverick wrangler
OPA := stampede2 maverick2 hikari
SYS := $(EDR) $(OPA) ls5

docker:
	docker info 1> /dev/null 2> /dev/null && \
	if [ ! $$? -eq 0 ]; then \
		echo "\n[ERROR] Could not communicate with docker daemon. You may need to run with sudo.\n"; \
		exit 1; \
	fi
containers/extras/osu-micro-benchmarks-5.4.4.tar.gz:
	cd $(dir $@) && wget http://mvapich.cse.ohio-state.edu/download/mvapich/$(notdir $@)

####################################
# Base Images
####################################
BASE := $(shell echo tacc-{ubuntu16,centos7,ubuntu18})
xenial:
	docker pull ubuntu:xenial
bionic:
	docker pull ubuntu:bionic
tacc-ubuntu16: | docker xenial
	$(BUILD) build containers $@
tacc-ubuntu18: | docker bionic
	$(BUILD) build containers $@
tacc-centos7: | docker
	$(BUILD) build containers $@

base-images: $(BASE)
push-base: docker
	$(BUILD) push containers tacc-ubuntu16 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu18 latest $(OPA)
	$(BUILD) push containers tacc-centos7 latest $(SYS)

####################################
# MPI Images
####################################
MPI := $(shell echo tacc-{ubuntu16-ompi1.10.2,ubuntu18-ompi2.1.1,centos7-ompi3.0.0} tacc-{ubuntu16,ubuntu18,centos7}-mvapich2.3 tacc-{ubuntu18,centos7}-mvapich2.3psm2)
# Open MPI
tacc-ubuntu16-ompi1.10.2: | tacc-ubuntu16 docker
	$(BUILD) build containers $@
tacc-ubuntu18-ompi2.1.1: | tacc-ubuntu18 docker
	$(BUILD) build containers $@
tacc-centos7-ompi3.0.0: | tacc-centos7 docker
	$(BUILD) build containers $@
# Infiniband
tacc-ubuntu16-mvapich2.3: | tacc-ubuntu16 docker
	$(BUILD) build containers $@
tacc-ubuntu18-mvapich2.3: | tacc-ubuntu18 docker
	$(BUILD) build containers $@
tacc-centos7-mvapich2.3: | tacc-centos7 docker
	$(BUILD) build containers $@
# Intel OPA
tacc-ubuntu18-mvapich2.3psm2: | tacc-ubuntu18 docker
	$(BUILD) build containers $@
tacc-centos7-mvapich2.3psm2: | tacc-centos7 docker
	$(BUILD) build containers $@
mpi-images: $(MPI)
push-mpi: docker
	$(BUILD) push containers tacc-ubuntu16-ompi1.10.2 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu18-ompi2.1.1 latest $(SYS)
	$(BUILD) push containers tacc-centos7-ompi3.0.0 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu16-mvapich2.3 latest $(EDR)
	$(BUILD) push containers tacc-ubuntu18-mvapich2.3 latest $(EDR)
	$(BUILD) push containers tacc-centos7-mvapich2.3 latest $(EDR)
	$(BUILD) push containers tacc-ubuntu18-mvapich2.3psm2 latest $(OPA)
	$(BUILD) push containers tacc-centos7-mvapich2.3psm2 latest $(OPA)

####################################
# CUDA Images
####################################


####################################
# Application Images
####################################

# TODO: Delete system tags after pushing
push: push-base push-mpi push-cuda push-apps
	$(BUILD) push containers tacc-ubuntu16 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu18 latest $(OPA)
	$(BUILD) push containers tacc-centos7 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu16-mvapich2.3 latest $(EDR)
	$(BUILD) push containers tacc-centos7-mvapich2.2 latest $(EDR)
	$(BUILD) push containers tacc-ubuntu16-mvapich2.3psm latest $(OPA)
	$(BUILD) push containers tacc-ubuntu18-mvapich2.3psm2 latest $(OPA)

clean: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	build/build_jupyteruser.sh clean images/singularity && \
	build/build_jupyteruser.sh clean images/sd2e && \
	build/build_jupyteruser.sh clean images/base
