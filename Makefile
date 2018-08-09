.PHONY: build test docker help stage release clean latest
ifndef VERBOSE
.SILENT: build test docker help stage release clean latest
endif

BASE := tacc-ubuntu16 tacc-centos7 tacc-ubuntu18
MPI := tacc-ubuntu16-mvapich2.2 tacc-centos7-mvapich2.2 tacc-ubuntu16-mvapich2.3psm tacc-ubuntu18-mvapich2.3psm2
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

tacc-ubuntu16: docker
	$(BUILD) build containers $@
tacc-ubuntu18: docker
	$(BUILD) build containers $@
tacc-centos7: docker
	$(BUILD) build containers $@
base-images: $(BASE)

# Infiniband
tacc-ubuntu16-mvapich2.2: | tacc-ubuntu16 docker
	$(BUILD) build containers $@
tacc-centos7-mvapich2.2: | tacc-centos7 docker
	$(BUILD) build containers $@
# Intel OPA
tacc-ubuntu16-mvapich2.3psm: | tacc-ubuntu16 docker
	$(BUILD) build containers $@
tacc-ubuntu18-mvapich2.3psm2: | tacc-ubuntu18 docker
	$(BUILD) build containers $@
mpi-images: $(MPI)

push: docker
	$(BUILD) push containers tacc-ubuntu16 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu18 latest $(OPA)
	$(BUILD) push containers tacc-centos7 latest $(SYS)
	$(BUILD) push containers tacc-ubuntu16-mvapich2.2 latest $(EDR)
	$(BUILD) push containers tacc-centos7-mvapich2.2 latest $(EDR)
	$(BUILD) push containers tacc-ubuntu16-mvapich2.3psm latest $(OPA)
	$(BUILD) push containers tacc-ubuntu18-mvapich2.3psm2 latest $(OPA)

clean: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	build/build_jupyteruser.sh clean images/singularity && \
	build/build_jupyteruser.sh clean images/sd2e && \
	build/build_jupyteruser.sh clean images/base
