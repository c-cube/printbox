
OPT = -use-ocamlfind -classic-display
TARGETS = src/printbox.cma src/printbox.cmxa src/printbox.cmxs \

NATIVE ?= true
NATIVE_DYNLINK ?= true
HTML ?= true

all:
	./pkg/build.ml native=$(NATIVE) native-dynlink=$(NATIVE_DYNLINK) html=$(HTML)

install: all
	ocamlfind install printbox src/META $(TARGETS) _build/src/*.cmi

doc:
	ocamlbuild src/printbox.docdir/index.html

clean:
	ocamlbuild -clean
watch:
	while find src/ -print0 | xargs -0 inotifywait -e delete_self -e modify ; do \
		echo "============ at `date` ==========" ; \
		make ; \
	done

.PHONY: all clean
