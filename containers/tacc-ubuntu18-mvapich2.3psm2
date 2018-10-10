#Image: gzynda/tacc-ubuntu18-mvapich2.3psm2
#Version: 0.0.1

FROM gzynda/tacc-ubuntu18:0.0.1

########################################
# Install mpi
########################################

# necessities and IB stack
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        ca-certificates build-essential curl gfortran bison \
        libibverbs-dev libibmad-dev libibumad-dev \
        librdmacm-dev libxml2-dev \
        libnuma-dev \
    && docker-clean

# Install PSM2
ARG PSM=IFS
ARG PSMV=10.7.0.0.145
ARG PSMD=opa-psm2-${PSM}_${PSMV}

RUN curl -L https://github.com/intel/opa-psm2/archive/${PSM}_${PSMV}.tar.gz | tar -xzf - \
    && cd ${PSMD} \
    && make PSM_AVX=1 -j $(nproc --all 2>/dev/null || echo 2) \
    && make LIBDIR=/usr/lib/x86_64-linux-gnu install \
    && cd ../ && rm -rf ${PSMD}

# Install mvapich2-2.3
ARG MAJV=2
ARG MINV=3
ARG DIR=mvapich${MAJV}-${MAJV}.${MINV}

RUN curl http://mvapich.cse.ohio-state.edu/download/mvapich/mv${MAJV}/${DIR}.tar.gz | tar -xzf - \
    && cd ${DIR} \
    && ./configure --with-device=ch3:psm --with-device=ch3:nemesis \
    && make -j $(nproc --all 2>/dev/null || echo 2) && make install \
    && mpicc examples/hellow.c -o /usr/bin/hellow \
    && cd ../ && rm -rf ${DIR} && rm -rf /usr/local/share/doc/mvapich2

# Test installation - doesn't work without opa device
#RUN mpirun -n 2 hellow
