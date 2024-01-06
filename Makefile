#

all: test1 test2 test3

test%:
	cd tests/$@ && irun -f test.f

