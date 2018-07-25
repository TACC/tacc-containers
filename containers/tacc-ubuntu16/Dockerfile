#Image: gzynda/tacc-ubuntu16
#Version: 0.0.1

# Use 16.04 LTS
FROM library/ubuntu:xenial

########################################
# Configure ENV
########################################

ENV DEBIAN_FRONTEND=noninteractive

########################################
# Add docker-clean
########################################

ADD extras/docker-clean /usr/bin/docker-clean
RUN chmod a+rx /usr/bin/docker-clean && docker-clean

########################################
# Add mount points
########################################

RUN mkdir /scratch /work /home1 /gpfs /corral-repl /corral-tacc /data
