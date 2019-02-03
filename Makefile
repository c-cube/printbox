
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

VERSION=$(shell awk '/^version:/ {print $$2}' printbox.opam)
update_next_tag:
	@echo "update version to $(VERSION)..."
	sed -i "s/NEXT_RELEASE/$(VERSION)/g" $(wildcard src/**/*.ml) $(wildcard src/**/*.mli)
	sed -i "s/NEXT_RELEASE/$(VERSION)/g" $(wildcard src/*.ml) $(wildcard src/*.mli)

.PHONY: all build test clean doc
