
dev: build test

build:
	@dune build @install

test:
	@dune runtest --no-buffer --force

install: build
	@dune install

doc:
	@dune build @doc

clean:
	@dune clean

.PHONY: all build test clean doc
