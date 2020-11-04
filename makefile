cw: cw.o
	gcc -o cw cw.o
cw.o: cw.s
	as -o cw.o cw.s