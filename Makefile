all:
	zig build

run:
	make all
	cls || clear
	zig-out/bin/main

clean:
	rm -f main
	rm -f main.o
	rm -rf zig-cache/
	rm -rf zig-out
	rm -f main.exe
	rm -f main.exe.obj
	rm -f main.pdb