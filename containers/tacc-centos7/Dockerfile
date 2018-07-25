#Image: gzynda/tacc-centos7
#Version: 0.0.1

FROM library/centos:7

########################################
# Add docker-clean
########################################

ADD extras/docker-clean /usr/bin/docker-clean
RUN chmod a+rx /usr/bin/docker-clean && docker-clean

########################################
# Add mount points
########################################

RUN mkdir /scratch /work /home1 /gpfs /corral-repl /corral-tacc /data
