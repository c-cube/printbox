
all: build

build:
	jbuilder build @install

test:
	jbuilder runtest --no-buffer --force

doc:
	jbuilder build @doc

clean:
	jbuilder clean

.PHONY: all build test clean doc
