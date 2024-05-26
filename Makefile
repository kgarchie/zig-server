all:
	zig build-exe main.zig

clean:
	rm -f main
	rm -f main.o
	rm -rf zig-cache/
	rm -rf zig-out
	rm -f main.exe
	rm -f main.exe.obj
	rm -f main.pdb