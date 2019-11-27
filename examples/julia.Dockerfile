ARG VER=latest
FROM gzynda/tacc-ubuntu18-mvapich2.3-ib:${VER}

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
