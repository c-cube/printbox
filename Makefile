
all: build

build:
	@dune build @install

test:
	@dune runtest --no-buffer --force

doc:
	@dune build @doc

clean:
	@dune clean

.PHONY: all build test clean doc
