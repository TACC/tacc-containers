FROM gzynda/tacc-ubuntu18-mvapich2.3psm2:0.0.1

RUN apt-get update \
	&& apt-get install -yq --no-install-recommends python3-dev git python3-pip \
		cmake python3-setuptools python3-wheel python3-numpy python3-matplotlib \
		python3-graphviz python3-scipy \
	&& docker-clean

RUN ln -s /usr/bin/python3 /usr/local/bin/python \
	&& ln -s /usr/bin/pip3 /usr/local/bin/pip

RUN pip install mpi4py \
	&& docker-clean

ADD run_julia.py /usr/local/bin/run_julia.py

RUN chmod +x /usr/local/bin/run_julia.py
