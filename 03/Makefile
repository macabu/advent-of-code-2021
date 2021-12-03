.PHONY: build run

build:
	@dmd -release -inline -m64 -boundscheck=off -O main.d

run: build
	@./main
