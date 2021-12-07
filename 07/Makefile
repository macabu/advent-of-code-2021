.PHONY: build run

build:
	@crystal build main.cr -o main --release --no-debug --progress

run: build
	@./main
