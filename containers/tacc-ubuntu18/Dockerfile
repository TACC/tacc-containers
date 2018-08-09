#Image: gzynda/tacc-ubuntu18
#Version: 0.0.1

# Use 18.04 LTS
FROM library/ubuntu:bionic

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
