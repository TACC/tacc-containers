.PHONY: build test docker help stage release clean latest
ifndef VERBOSE
.SILENT: build test docker help stage release clean latest
endif

BASE := tacc-ubuntu16 tacc-centos7
MPI := tacc-ubuntu16-mvapich2.2 tacc-centos7-mvapich2.2
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
	$(BUILD) push containers $@ latest $(SYS)
tacc-centos7: docker
	$(BUILD) build containers $@
	$(BUILD) push containers $@ latest $(SYS)
base-images: $(BASE)

tacc-ubuntu16-mvapich2.2: tacc-ubuntu16
	$(BUILD) build containers $@
	$(BUILD) push containers $@ latest $(EDR)
tacc-centos7-mvapich2.2: tacc-centos7
	$(BUILD) build containers $@
	$(BUILD) push containers $@ latest $(EDR)
mpi-images: $(MPI)

#latest: $(ALL)
#	for i in $^; do $(BUILD) push containers $$i $@; done
#maverick: $(MPI)
#	for i in $^; do $(BUILD) push containers $$i $@; done
#wrangler: $(MPI)
#	for i in $^; do $(BUILD) push containers $$i $@; done
#push: latest maverick wrangler

clean: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	build/build_jupyteruser.sh clean images/singularity && \
	build/build_jupyteruser.sh clean images/sd2e && \
	build/build_jupyteruser.sh clean images/base
