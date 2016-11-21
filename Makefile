
OPT = -use-ocamlfind -classic-display
TARGETS = src/printbox.cma src/printbox.cmxa src/printbox.cmxs \

NATIVE ?= true
NATIVE_DYNLINK ?= true
HTML ?= true

all: build test

build:
	./pkg/build.ml native=$(NATIVE) native-dynlink=$(NATIVE_DYNLINK) html=$(HTML)

install: build
	ocamlfind install printbox src/META $(TARGETS) _build/src/*.cmi

doc:
	ocamlbuild src/printbox.docdir/index.html

TEST_TARGETS=test/test1.native

test:
	ocamlbuild -I _build/src $(TEST_TARGETS)
	for i in $(wildcard ./test*.native) ; do \
	  ./$$i ; \
	done

clean:
	ocamlbuild -clean
watch:
	while find src/ -print0 | xargs -0 inotifywait -e delete_self -e modify ; do \
		echo "============ at `date` ==========" ; \
		make ; \
	done

.PHONY: all clean test
