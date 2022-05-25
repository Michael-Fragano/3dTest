.PHONY: test check

build:
	dune build

utop:
	OCAMLRUNPARAM=b dune utop src

test:
	OCAMLRUNPARAM=b dune exec test/main.exe

run:
	OCAMLRUNPARAM=b dune exec bin/main.exe

zip:
	rm -f 3d.zip
	zip -r 3d.zip . -x@exclude.lst

clean:
	dune clean
	rm -f 3d.zip

doc:
	dune build @doc