ISTANBUL=node_modules/.bin/istanbul
MOCHA=node_modules/.bin/_mocha
DOCCO=node_modules/.bin/docco
PEG=node_modules/.bin/pegjs
PEGARGS=--plugin pegjs-coffee-plugin

SRC=$(shell find lib/ -type f) lib/parser.js
TESTSRC=$(shell find test/ -type f)
DOCS=$(patsubst lib/%.js, docs/%.html, $(SRC))

all: test docs lib/parser.js

.PHONY: test docs

test: coverage/coverage.json

docs: $(DOCS)

docs/%.html: lib/%.js
	docco $^

coverage/coverage.json: $(SRC) $(TESTSRC)

coverage/coverage.json:
	$(ISTANBUL) cover $(MOCHA) -- --require test/bootstrap.js --compilers coffee:coffee-script/register --recursive test/unit

coverage/index.html: coverage/coverage.json
	$(ISTANBUL) report html

coverage/lcov.info: coverage/coverage.json
	$(ISTANBUL) report lcov

lib/parser.js: lib/parser.pegcoffee
	$(PEG) $(PEGARGS) $^ $@
