#Image: tacc-ubuntu16-mvapich2.2
#Version: 0.0.1

FROM gzynda/tacc-ubuntu16:0.0.1

########################################
# Install mpi
########################################

# necessities and IB stack
RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential curl gfortran bison libibverbs-dev libibmad-dev libibumad-dev librdmacm-dev libmlx5-dev libmlx4-dev && \
    docker-clean

# Install mvapich2-2.2
ARG MAJV=2
ARG MINV=2
ARG DIR=mvapich${MAJV}-${MAJV}.${MINV}

RUN curl http://mvapich.cse.ohio-state.edu/download/mvapich/mv${MAJV}/${DIR}.tar.gz | tar -xzf - \
    && cd ${DIR} \
    && ./configure \
    && make -j $(nproc --all 2>/dev/null || echo 2) && make install \
    && mpicc examples/hellow.c -o /usr/bin/hellow \
    && cd ../ && rm -rf ${DIR}

# Test installation
RUN MV2_SMP_USE_CMA=0 mpirun -n 2 hellow
