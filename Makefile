.PHONY: build test docker help stage release clean
ifndef VERBOSE
.SILENT: build test docker help stage release clean
endif

docker:
	docker info 1> /dev/null 2> /dev/null && \
	if [ ! $$? -eq 0 ]; then \
		echo "\n[ERROR] Could not communicate with docker daemon. You may need to run with sudo.\n"; \
		exit 1; \
	fi

build: base-images

tacc-ubuntu16: docker
	scripts/build_docker.sh build containers $@
tacc-centos7: docker
	scripts/build_docker.sh build containers $@
base-images: tacc-ubuntu16 tacc-centos7

tacc-ubuntu16-mvapich2.2: tacc-ubuntu16
	scripts/build_docker.sh build containers $@
tacc-centos7-mvapich2.2: tacc-ubuntu16
	scripts/build_docker.sh build containers $@
mpi-images: tacc-ubuntu16-mvapich2.2 tacc-centos7-mvapich2.2
	

build: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $${TARGET} in \
	base) \
		build/build_jupyteruser.sh build images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh build images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh build images/singularity; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

test: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh test images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh test images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh test images/singularity; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

stage: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh stage images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh stage images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh stage images/singularity; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

release: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	case $$TARGET in \
	base) \
		build/build_jupyteruser.sh release images/base; \
		;; \
	sd2e) \
		build/build_jupyteruser.sh release images/sd2e; \
		;; \
	singularity) \
		build/build_jupyteruser.sh release images/singularity; \
		;; \
	*) \
		$(MAKE) help; \
		;; \
	esac

clean: docker
	TARGET=$(filter-out $@,$(MAKECMDGOALS)) && \
	build/build_jupyteruser.sh clean images/singularity && \
	build/build_jupyteruser.sh clean images/sd2e && \
	build/build_jupyteruser.sh clean images/base
