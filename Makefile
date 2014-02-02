FLAGS=-use-ocamlfind -yaccflags --explain -use-menhir -lib str
PKGS=
INC=src

TESTS_FLAGS=$(FLAGS)
TESTS_PKGS=oUnit
TESTS_INC=$(INC),tests

COVERAGE_FLAGS=$(TESTS_FLAGS)
COVERAGE_TAGS=package\(bisect\),syntax\(camlp4o\),syntax\(bisect_pp\)
COVERAGE_INC=$(TESTS_INC)

all: to.ml.cmxa

to.ml.cmxa:
	ocamlbuild $(FLAGS) -pkgs $(PKGS) -I $(INC) $@

test: test_toml.native
	@echo '*******************************************************************'
	@./test_toml.native

test_toml.native:
	ocamlbuild $(TESTS_FLAGS) -pkgs $(TESTS_PKGS) -Is $(TESTS_INC) $@

coverage:
	ocamlbuild $(COVERAGE_FLAGS) -pkgs $(TESTS_PKGS) -tags $(COVERAGE_TAGS) -Is $(COVERAGE_INC) test_toml.byte
	BISECT_FILE=_build/coverage ./test_toml.byte
	cd _build && bisect-report -verbose -html report coverage*.out

clean:
	ocamlbuild -clean

