#Image: gzynda/tacc-centos7-intelOPA10.7
#Version: 0.0.1

FROM gzynda/tacc-centos7:0.0.1

########################################
# Install mpi
########################################

# Download OPA

# Install mvapich2-2.2
ARG MAJV=2
ARG MINV=2
ARG DIR=mvapich${MAJV}-${MAJV}.${MINV}

# necessities and IB stack
RUN yum -y groupinstall "Development tools" \
    && yum -y install libgfortran libibmad-devel libibumad libibverbs-devel librdmacm libxml2-devel \
    && docker-clean

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
