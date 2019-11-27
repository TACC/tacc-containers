#!/usr/bin/env python3

from __future__ import print_function
from __future__ import division
import sys
import time
from socket import gethostname

from mpi4py import MPI
from mpi4py.futures import MPICommExecutor, MPIPoolExecutor

try:
	range = xrange
except NameError:
	pass

x0 = -2.0
x1 = +2.0
y0 = -1.5
y1 = +1.5

w = 1600
h = 1200

dx = (x1 - x0) / w
dy = (y1 - y0) / h

def julia(x, y):
	c = complex(0, 0.65)
	z = complex(x, y)
	n = 255
	while abs(z) < 3 and n > 1:
		z = z**2 + c
		n -= 1
	return n

def julia_line(k):
	line = bytearray(w)
	y = y1 - k * dy
	for j in range(w):
		x = x0 + j * dx
		line[j] = julia(x, y)
	return line

def test_julia_comm():
	with MPICommExecutor(MPI.COMM_WORLD, root=0) as executor:
		if executor is None:
			# worker process
			return
		print("Loaded Executor")
		tic = time.time()
		image = list(executor.map(julia_line, range(h), chunksize=10))
		toc = time.time()
		print("%s - %s Set %dx%d in %.2f seconds." % (gethostname(), 'Julia', w, h, toc-tic))
def test_julia_pool():
	with MPIPoolExecutor() as executor:
		print("Loaded Executor")
		tic = time.time()
		image = list(executor.map(julia_line, range(h), chunksize=10))
		toc = time.time()
		print("%s - %s Set %dx%d in %.2f seconds." % (gethostname(), 'Julia', w, h, toc-tic))

if __name__ == '__main__':
	if len(sys.argv) > 1:
		if sys.argv[1] == 'pool':
			print("Running POOL")
			test_julia_pool()
		else:
			print("Running COMM")
			test_julia_comm()
	else:
		print("Running COMM")
		test_julia_comm()
