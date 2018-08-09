#Image: gzynda/tacc-ubuntu16-mvapich2.3psm
#Version: 0.0.1

FROM gzynda/tacc-ubuntu16:0.0.1

########################################
# Install mpi
########################################

# necessities and IB stack
RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
        ca-certificates build-essential curl gfortran bison \
        libibverbs-dev libibmad-dev libibumad-dev \
        librdmacm-dev libmlx5-dev libmlx4-dev libxml2-dev \
        libpsm-infinipath1-dev libnuma-dev \
    && docker-clean

# Install mvapich2-2.3
ARG MAJV=2
ARG MINV=3
ARG DIR=mvapich${MAJV}-${MAJV}.${MINV}

RUN curl http://mvapich.cse.ohio-state.edu/download/mvapich/mv${MAJV}/${DIR}.tar.gz | tar -xzf - \
    && cd ${DIR} \
    && ./configure --with-device=ch3:psm \
    && make -j $(nproc --all 2>/dev/null || echo 2) && make install \
    && mpicc examples/hellow.c -o /usr/bin/hellow \
    && cd ../ && rm -rf ${DIR} && rm -rf /usr/local/share/doc/mvapich2

# Test installation - doesn't work without opa
#RUN mpirun -genv I_MPI_FABRICS shm:tcp -n 2 hellow
